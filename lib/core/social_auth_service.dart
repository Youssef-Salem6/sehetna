import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sehetna/fetures/auth/manager/sendFcmToken/send_fcm_token_cubit.dart';
import 'package:sehetna/core/nav_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';

class SocialAuthService {
  static const String baseUrl = 'https://api.sehtnaa.com/api';
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  BuildContext? _context;
  Timer? _timeoutTimer;
  bool _isProcessing = false;

  SocialAuthService() {
    _appLinks = AppLinks();
  }

  Future<void> initiateGoogleLogin(BuildContext context) async {
    if (_isProcessing) {
      return;
    }

    try {
      _isProcessing = true;
      _context = context;

      // Start listening for deep links BEFORE launching the URL
      _startListeningForDeepLinks();

      // Set up timeout
      _setupTimeout();

      // 1. Get the Google auth URL from your backend
      final response = await http.get(
        Uri.parse('$baseUrl/auth/social/google/url'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to get Google auth URL: ${response.statusCode}');
      }

      final responseData = json.decode(response.body);

      // Handle different response formats
      String? authUrl;
      if (responseData['success'] == true && responseData['data'] != null) {
        authUrl = responseData['data']['url'];
      } else if (responseData['url'] != null) {
        authUrl = responseData['url'];
      } else {
        throw Exception('No auth URL found in response');
      }

      if (authUrl == null || authUrl.isEmpty) {
        throw Exception('Invalid auth URL received');
      }

      // Show loading message
      _showLoadingMessage(context, 'Opening browser for authentication...');

      // 2. Launch the URL in external browser
      final uri = Uri.parse(authUrl);
      if (await canLaunchUrl(uri)) {
        final launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );

        if (launched) {
          _showLoadingMessage(
              context, 'Please complete authentication in browser...');
        } else {
          throw Exception('Failed to launch auth URL');
        }
      } else {
        throw Exception('Could not launch $authUrl');
      }
    } catch (e) {
      _showErrorMessage(context, 'Google login failed: ${e.toString()}');
      _cleanup();
    }
  }

  void _setupTimeout() {
    // Set up a timeout to stop listening after 5 minutes
    _timeoutTimer = Timer(const Duration(minutes: 5), () {
      if (_context != null) {
        _showErrorMessage(
            _context!, 'Authentication timed out. Please try again.');
      }
      _cleanup();
    });
  }

  void _startListeningForDeepLinks() {
    _linkSubscription?.cancel(); // Cancel any existing subscription

    _linkSubscription = _appLinks.uriLinkStream.listen(
      (uri) {
        _handleDeepLink(uri);
      },
      onError: (err) {
        if (_context != null) {
          _showErrorMessage(_context!, 'Deep link error: $err');
        }
        _cleanup();
      },
    );
  }

  Future<void> _handleDeepLink(Uri uri) async {
    if (!_isProcessing) {
      return;
    }

    if (_context == null) {
      return;
    }

    // Check if it's an auth callback
    if (uri.scheme == 'sehetna' && uri.host == 'auth') {
      _timeoutTimer?.cancel(); // Cancel timeout since we got a response

      final queryParams = uri.queryParameters;

      if (queryParams.containsKey('error')) {
        // Handle authentication error
        final error = queryParams['error'] ?? 'Unknown error';
        final errorDescription = queryParams['error_description'] ?? '';

        String userMessage = 'Authentication failed';
        if (error == 'access_denied') {
          userMessage = 'Login was cancelled by user';
        } else if (errorDescription.isNotEmpty) {
          userMessage = errorDescription;
        }

        _showErrorMessage(_context!, userMessage);
        _cleanup();
        return;
      }

      if (queryParams.containsKey('success') &&
          queryParams['success'] == 'true') {
        // Handle new format with base64 encoded data
        if (queryParams.containsKey('data')) {
          final encodedData = queryParams['data']!;

          await _handleBase64EncodedResponse(encodedData, queryParams);
        } else {
          _showErrorMessage(_context!, 'Authentication response missing data');
          _cleanup();
        }
      } else if (queryParams.containsKey('token')) {
        // Direct token in deep link (legacy format)
        final token = queryParams['token']!;
        await _handleSuccessfulAuth(token, queryParams);
      } else if (queryParams.containsKey('code')) {
        // OAuth authorization code - need to exchange for token
        final code = queryParams['code']!;
        await _exchangeCodeForToken(code);
      } else {
        _showErrorMessage(_context!,
            'Invalid authentication response - no token or code received');
        _cleanup();
      }
    } else {}
  }

  Future<void> _exchangeCodeForToken(String code) async {
    try {
      _showLoadingMessage(_context!, 'Processing authentication...');

      final response = await http.post(
        Uri.parse('$baseUrl/auth/social/google/callback'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'code': code,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);

        // Handle different response formats
        String? token;
        Map<String, dynamic> userData = {};

        if (responseData['success'] == true && responseData['data'] != null) {
          token = responseData['data']['token'];
          userData = responseData['data']['user'] ?? {};
        } else {
          token = responseData['token'] ?? responseData['access_token'];
          userData = responseData['user'] ?? {};
        }

        if (token != null && token.isNotEmpty) {
          await _handleSuccessfulAuth(token, {'user': userData});
        } else {
          throw Exception('No valid token received from server');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorMessage(
          _context!, 'Failed to complete authentication: ${e.toString()}');
      _cleanup();
    }
  }

  Future<void> _handleSuccessfulAuth(
      String token, Map<String, dynamic> extraData) async {
    try {
      _showLoadingMessage(_context!, 'Completing login...');

      // Verify the token and get user data
      final userData = await _verifyAndGetUserData(token);

      // Store authentication data
      await _storeAuthData(token, userData ?? {});

      // Send FCM token if context is still valid
      if (_context != null && _context!.mounted) {
        try {
          BlocProvider.of<SendFcmTokenCubit>(_context!).sendToken();
        } catch (e) {}
      }

      // Navigate to home screen
      if (_context != null && _context!.mounted) {
        Navigator.pushAndRemoveUntil(
          _context!,
          MaterialPageRoute(builder: (context) => const NavView()),
          (route) => false,
        );

        _showSuccessMessage(_context!, 'Login successful! Welcome back.');
      }
    } catch (e) {
      _showErrorMessage(_context!, 'Authentication failed: ${e.toString()}');
    } finally {
      _cleanup();
    }
  }

  Future<Map<String, dynamic>?> _verifyAndGetUserData(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          return responseData['data'];
        } else {
          return responseData;
        }
      } else if (response.statusCode == 401) {
        throw Exception('Invalid token received');
      } else {
        return {}; // Return empty map if profile fetch fails
      }
    } catch (e) {
      // For non-401 errors, return empty data and let login proceed
      if (e.toString().contains('Invalid token')) {
        rethrow;
      }
      return {};
    }
  }

  Future<void> _storeAuthData(
      String token, Map<String, dynamic> userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Store in the format matching your _saveUserData method
      await prefs.setString('id', userData['id']?.toString() ?? '');
      await prefs.setString('email', userData['email'] ?? '');
      await prefs.setString('firstName', userData['first_name'] ?? '');
      await prefs.setString('lastName', userData['last_name'] ?? '');
      await prefs.setString('gender', userData['gender'] ?? '');
      await prefs.setString('phone', userData['phone'] ?? '');
      await prefs.setString('address', userData['address'] ?? '');
      await prefs.setString('image', userData['profile_image'] ?? '');
      await prefs.setString('token', token);
      await prefs.setBool('isFirstTime', false);

      // Also store the complete user data as JSON for backward compatibility
      await prefs.setString('user_data', json.encode(userData));
      await prefs.setBool('is_logged_in', true);
    } catch (e) {
      rethrow;
    }
  }

  // Check for initial deep link when app starts
  Future<void> checkInitialLink(BuildContext context) async {
    try {
      final uri = await _appLinks.getInitialLink();
      if (uri != null) {
        _context = context;
        _isProcessing = true;
        await _handleDeepLink(uri);
      } else {}
    } catch (e) {}
  }

  void _cleanup() {
    _timeoutTimer?.cancel();
    _linkSubscription?.cancel();
    _linkSubscription = null;
    _context = null;
    _isProcessing = false;
  }

  // Handle base64 encoded response data from PHP backend
  Future<void> _handleBase64EncodedResponse(
      String encodedData, Map<String, dynamic> queryParams) async {
    try {
      // Decode base64
      final decodedBytes = base64Decode(encodedData);
      final decodedString = utf8.decode(decodedBytes);

      // Parse JSON
      final responseData = json.decode(decodedString);

      if (responseData['user'] != null) {}

      if (responseData['token'] != null) {}

      // Extract token and user data
      final token = responseData['token'];
      final userData = responseData['user'];

      if (token != null && token.toString().isNotEmpty) {
        // Handle successful authentication with the decoded data
        await _handleSuccessfulAuthFromResponse(
            token.toString(), userData ?? {});
      } else {
        throw Exception('No valid token found in decoded response');
      }
    } catch (e) {
      _showErrorMessage(_context!,
          'Failed to process authentication response: ${e.toString()}');
      _cleanup();
    }
  }

  // Handle successful auth when we already have user data from backend
  Future<void> _handleSuccessfulAuthFromResponse(
      String token, Map<String, dynamic> userData) async {
    try {
      _showLoadingMessage(_context!, 'Completing login...');

      // Store authentication data directly (no need to verify since it came from backend)
      await _storeAuthData(token, userData);

      // Send FCM token if context is still valid
      if (_context != null && _context!.mounted) {
        try {
          BlocProvider.of<SendFcmTokenCubit>(_context!).sendToken();
        } catch (e) {}
      }

      // Navigate to home screen
      if (_context != null && _context!.mounted) {
        Navigator.pushAndRemoveUntil(
          _context!,
          MaterialPageRoute(builder: (context) => const NavView()),
          (route) => false,
        );

        final userName = userData['first_name'] ?? userData['name'] ?? 'User';
        _showSuccessMessage(
            _context!, 'Login successful! Welcome back, $userName.');
      }
    } catch (e) {
      _showErrorMessage(_context!, 'Authentication failed: ${e.toString()}');
    } finally {
      _cleanup();
    }
  }

  void _showErrorMessage(BuildContext context, String message) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
      ),
    );
  }

  void _showSuccessMessage(BuildContext context, String message) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showLoadingMessage(BuildContext context, String message) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.blue,
        content: Row(
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(child: Text(message)),
          ],
        ),
        duration: const Duration(seconds: 8),
      ),
    );
  }

  // Clean up resources
  void dispose() {
    _cleanup();
  }
}
