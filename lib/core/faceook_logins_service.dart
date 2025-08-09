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

class FaceBookAuthService {
  static const String baseUrl = 'https://api.sehtnaa.com/api';
  AppLinks? _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  BuildContext? _context;
  Timer? _timeoutTimer;
  bool _isProcessing = false;

  FaceBookAuthService() {
    _initializeAppLinks();
  }

  void _initializeAppLinks() {
    try {
      _appLinks = AppLinks();
      print('AppLinks initialized successfully');
    } catch (e) {
      print('Error initializing AppLinks: $e');
      _appLinks = null;
    }
  }

  Future<void> initiateFacebookLogin(BuildContext context) async {
    if (_isProcessing) {
      print('Facebook login already in progress, ignoring request');
      return;
    }

    try {
      _isProcessing = true;
      _context = context;

      print('Starting Facebook login process...');

      // Start listening for deep links BEFORE launching the URL
      _startListeningForDeepLinks();

      // Set up timeout
      _setupTimeout();

      // 1. Get the Facebook auth URL from your backend
      final response = await http.get(
        Uri.parse('$baseUrl/auth/social/facebook/url'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      print('=== GET AUTH URL RESPONSE ===');
      print('Status Code: ${response.statusCode}');
      print('Headers: ${response.headers}');
      print('Body: ${response.body}');
      print('=== END AUTH URL RESPONSE ===');

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to get Facebook auth URL: ${response.statusCode}');
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

      print('Auth URL received: $authUrl');

      // Show loading message
      _showLoadingMessage(context, 'Opening Facebook for authentication...');

      // 2. Launch the URL - try Facebook app first, then fallback to browser
      final uri = Uri.parse(authUrl);

      // First try to open with Facebook app by using the facebook:// scheme if possible
      // Facebook URLs can be opened directly with the Facebook app
      bool launched = false;

      // Try to launch with external application mode first (will prefer Facebook app)
      if (await canLaunchUrl(uri)) {
        launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );

        if (launched) {
          print('Successfully launched Facebook auth URL');
          _showLoadingMessage(
              context, 'Please complete authentication in Facebook...');
        } else {
          throw Exception('Failed to launch Facebook auth URL');
        }
      } else {
        throw Exception('Could not launch $authUrl');
      }
    } catch (e) {
      print('Error in initiateFacebookLogin: $e');
      _showErrorMessage(context, 'Facebook login failed: ${e.toString()}');
      _cleanup();
    }
  }

  void _setupTimeout() {
    // Set up a timeout to stop listening after 5 minutes
    _timeoutTimer = Timer(const Duration(minutes: 5), () {
      print('Authentication timeout reached');
      if (_context != null) {
        _showErrorMessage(
            _context!, 'Authentication timed out. Please try again.');
      }
      _cleanup();
    });
  }

  void _startListeningForDeepLinks() {
    print('Starting to listen for deep links...');
    _linkSubscription?.cancel(); // Cancel any existing subscription

    if (_appLinks == null) {
      print('AppLinks not initialized, cannot listen for deep links');
      _showErrorMessage(_context!, 'Deep link functionality not available');
      _cleanup();
      return;
    }

    _linkSubscription = _appLinks!.uriLinkStream.listen(
      (uri) {
        print('Deep link received: $uri');
        _handleDeepLink(uri);
      },
      onError: (err) {
        print('Deep link error: $err');
        if (_context != null) {
          _showErrorMessage(_context!, 'Deep link error: $err');
        }
        _cleanup();
      },
    );
  }

  Future<void> _handleDeepLink(Uri uri) async {
    if (!_isProcessing) {
      print('Not processing auth, ignoring deep link');
      return;
    }

    print('=== DEEP LINK RECEIVED ===');
    print('Full URI: $uri');
    print('Scheme: ${uri.scheme}');
    print('Host: ${uri.host}');
    print('Path: ${uri.path}');
    print('Fragment: ${uri.fragment}');
    print('Query: ${uri.query}');
    print('Query Parameters: ${uri.queryParameters}');
    print('=== END DEEP LINK INFO ===');

    if (_context == null) {
      print('Context is null, cannot handle deep link');
      return;
    }

    // Check if it's an auth callback
    if (uri.scheme == 'sehetna' && uri.host == 'auth') {
      _timeoutTimer?.cancel(); // Cancel timeout since we got a response

      final queryParams = uri.queryParameters;
      print('Auth callback parameters: $queryParams');

      if (queryParams.containsKey('error')) {
        // Handle authentication error
        final error = queryParams['error'] ?? 'Unknown error';
        final errorDescription = queryParams['error_description'] ?? '';
        print('Error in auth callback: $error - $errorDescription');

        String userMessage = 'Authentication failed';
        if (error == 'access_denied') {
          userMessage = 'Login was cancelled by user';
        } else if (error == 'user_denied') {
          userMessage = 'Facebook login was cancelled';
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
          print('=== BASE64 ENCODED DATA RECEIVED ===');
          print('Encoded Data: $encodedData');
          print('=== END ENCODED DATA ===');

          await _handleBase64EncodedResponse(encodedData, queryParams);
        } else {
          print('Success response but no data found');
          _showErrorMessage(_context!, 'Authentication response missing data');
          _cleanup();
        }
      } else if (queryParams.containsKey('token')) {
        // Direct token in deep link (legacy format)
        final token = queryParams['token']!;
        print('Token found in deep link: $token');
        await _handleSuccessfulAuth(token, queryParams);
      } else if (queryParams.containsKey('code')) {
        // OAuth authorization code - need to exchange for token
        final code = queryParams['code']!;
        print('Authorization code found: $code');
        await _exchangeCodeForToken(code);
      } else {
        print('No token, code, or success data found in auth callback');
        _showErrorMessage(_context!,
            'Invalid authentication response - no token or code received');
        _cleanup();
      }
    } else {
      print('Deep link is not an auth callback: ${uri.scheme}://${uri.host}');
    }
  }

  Future<void> _exchangeCodeForToken(String code) async {
    try {
      print('Exchanging authorization code for token...');
      _showLoadingMessage(_context!, 'Processing authentication...');

      print('=== TOKEN EXCHANGE REQUEST ===');
      print('URL: $baseUrl/auth/social/facebook/callback');
      print('Headers: ${{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      }}');
      print('Body: ${json.encode({'code': code})}');
      print('=== END REQUEST ===');

      final response = await http.post(
        Uri.parse('$baseUrl/auth/social/facebook/callback'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'code': code,
        }),
      );

      print('=== TOKEN EXCHANGE RESPONSE ===');
      print('Status Code: ${response.statusCode}');
      print('Headers: ${response.headers}');
      print('Body: ${response.body}');
      print('=== END RESPONSE ===');

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
          print('=== TOKEN SUCCESSFULLY EXCHANGED ===');
          print('Token: ${token.substring(0, 50)}...');
          print('User Data: ${json.encode(userData)}');
          print('=== END TOKEN INFO ===');
          await _handleSuccessfulAuth(token, {'user': userData});
        } else {
          throw Exception('No valid token received from server');
        }
      } else {
        final errorBody = response.body;
        print(
            'Token exchange failed with status ${response.statusCode}: $errorBody');
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error exchanging code for token: $e');
      _showErrorMessage(
          _context!, 'Failed to complete authentication: ${e.toString()}');
      _cleanup();
    }
  }

  Future<void> _handleSuccessfulAuth(
      String token, Map<String, dynamic> extraData) async {
    try {
      print('=== HANDLING SUCCESSFUL AUTH ===');
      print('Token: ${token.substring(0, 20)}...');
      print('Extra data: $extraData');

      _showLoadingMessage(_context!, 'Completing login...');

      // Verify the token and get user data
      final userData = await _verifyAndGetUserData(token);
      print('User data from backend: $userData');

      // Store authentication data
      await _storeAuthData(token, userData ?? {});
      print('=== AUTH DATA STORAGE ===');
      print('Token stored: ${token.substring(0, 20)}...');
      print('User data stored: ${json.encode(userData ?? {})}');
      print('=== END STORAGE INFO ===');

      // Send FCM token if context is still valid
      if (_context != null && _context!.mounted) {
        try {
          BlocProvider.of<SendFcmTokenCubit>(_context!).sendToken();
          print('FCM token sent');
        } catch (e) {
          print('Error sending FCM token (non-critical): $e');
        }
      }

      // Navigate to home screen
      if (_context != null && _context!.mounted) {
        Navigator.pushAndRemoveUntil(
          _context!,
          MaterialPageRoute(builder: (context) => const NavView()),
          (route) => false,
        );
        print('Navigated to NavView');

        _showSuccessMessage(_context!, 'Login successful! Welcome back.');
      }

      print('=== AUTH SUCCESS COMPLETE ===');
    } catch (e) {
      print('Error in _handleSuccessfulAuth: $e');
      _showErrorMessage(_context!, 'Authentication failed: ${e.toString()}');
    } finally {
      _cleanup();
    }
  }

  Future<Map<String, dynamic>?> _verifyAndGetUserData(String token) async {
    try {
      print('Verifying token with backend...');

      print('=== PROFILE VERIFICATION REQUEST ===');
      print('URL: $baseUrl/user/profile');
      print('Headers: ${{
        'Authorization': 'Bearer ${token.substring(0, 20)}...',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      }}');
      print('=== END REQUEST ===');

      final response = await http.get(
        Uri.parse('$baseUrl/user/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      print('=== PROFILE VERIFICATION RESPONSE ===');
      print('Status Code: ${response.statusCode}');
      print('Headers: ${response.headers}');
      print('Body: ${response.body}');
      print('=== END RESPONSE ===');

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
        print('Failed to verify token, but proceeding anyway');
        return {}; // Return empty map if profile fetch fails
      }
    } catch (e) {
      print('Error verifying token: $e');
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
      await prefs.setString('firstName',
          userData['first_name'] ?? userData['name']?.split(' ')[0] ?? '');
      await prefs.setString(
          'lastName',
          userData['last_name'] ??
              (userData['name']?.split(' ').length > 1
                  ? userData['name'].split(' ').sublist(1).join(' ')
                  : ''));
      await prefs.setString('gender', userData['gender'] ?? '');
      await prefs.setString('phone', userData['phone'] ?? '');
      await prefs.setString('address', userData['address'] ?? '');
      await prefs.setString('image',
          userData['profile_image'] ?? userData['picture']?.toString() ?? '');
      await prefs.setString('token', token);
      await prefs.setBool('isFirstTime', false);

      // Also store the complete user data as JSON for backward compatibility
      await prefs.setString('user_data', json.encode(userData));
      await prefs.setBool('is_logged_in', true);

      print('=== STORED USER DATA ===');
      print('ID: ${userData['id']?.toString() ?? ''}');
      print('Email: ${userData['email'] ?? ''}');
      print(
          'First Name: ${userData['first_name'] ?? userData['name']?.split(' ')[0] ?? ''}');
      print(
          'Last Name: ${userData['last_name'] ?? (userData['name']?.split(' ').length > 1 ? userData['name'].split(' ').sublist(1).join(' ') : '')}');
      print('Gender: ${userData['gender'] ?? ''}');
      print('Phone: ${userData['phone'] ?? ''}');
      print('Address: ${userData['address'] ?? ''}');
      print(
          'Profile Image: ${userData['profile_image'] ?? userData['picture']?.toString() ?? ''}');
      print('Token: ${token.substring(0, 20)}...');
      print('Is First Time: false');
      print('Is Logged In: true');
      print('=== END STORED DATA ===');
    } catch (e) {
      print('Error storing auth data: $e');
      rethrow;
    }
  }

  // Check for initial deep link when app starts
  Future<void> checkInitialLink(BuildContext context) async {
    try {
      print('Checking for initial deep link...');

      if (_appLinks == null) {
        print('AppLinks not initialized, cannot check initial link');
        return;
      }

      final uri = await _appLinks!.getInitialLink();
      if (uri != null) {
        print('Initial deep link found: $uri');
        _context = context;
        _isProcessing = true;
        await _handleDeepLink(uri);
      } else {
        print('No initial deep link found');
      }
    } catch (e) {
      print('Error checking initial link: $e');
    }
  }

  void _cleanup() {
    print('Cleaning up FaceBookAuthService...');
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
      print('=== DECODING BASE64 RESPONSE ===');
      print('Encoded Data: $encodedData');

      // Decode base64
      final decodedBytes = base64Decode(encodedData);
      final decodedString = utf8.decode(decodedBytes);

      print('Decoded String: $decodedString');

      // Parse JSON
      final responseData = json.decode(decodedString);

      print('=== DECODED RESPONSE DATA ===');
      print('Full Response: ${json.encode(responseData)}');
      print('Has User: ${responseData.containsKey('user')}');
      print('Has Token: ${responseData.containsKey('token')}');
      print('Has Message: ${responseData.containsKey('message')}');

      if (responseData['user'] != null) {
        print('User Data: ${json.encode(responseData['user'])}');
      }

      if (responseData['token'] != null) {
        print('Token: ${responseData['token'].toString().substring(0, 50)}...');
      }

      print('Provider: ${queryParams['provider'] ?? 'facebook'}');
      print('=== END DECODED DATA ===');

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
      print('Error decoding base64 response: $e');
      _showErrorMessage(_context!,
          'Failed to process authentication response: ${e.toString()}');
      _cleanup();
    }
  }

  // Handle successful auth when we already have user data from backend
  Future<void> _handleSuccessfulAuthFromResponse(
      String token, Map<String, dynamic> userData) async {
    try {
      print('=== HANDLING AUTH FROM DECODED RESPONSE ===');
      print('Token: ${token.substring(0, 20)}...');
      print('User Data: ${json.encode(userData)}');

      _showLoadingMessage(_context!, 'Completing login...');

      // Store authentication data directly (no need to verify since it came from backend)
      await _storeAuthData(token, userData);
      print('=== AUTH DATA STORAGE FROM RESPONSE ===');
      print('Token stored: ${token.substring(0, 20)}...');
      print('User data stored: ${json.encode(userData)}');
      print('=== END STORAGE INFO ===');

      // Send FCM token if context is still valid
      if (_context != null && _context!.mounted) {
        try {
          BlocProvider.of<SendFcmTokenCubit>(_context!).sendToken();
          print('FCM token sent');
        } catch (e) {
          print('Error sending FCM token (non-critical): $e');
        }
      }

      // Navigate to home screen
      if (_context != null && _context!.mounted) {
        Navigator.pushAndRemoveUntil(
          _context!,
          MaterialPageRoute(builder: (context) => const NavView()),
          (route) => false,
        );
        print('Navigated to NavView');

        final userName =
            userData['first_name'] ?? userData['name']?.split(' ')[0] ?? 'User';
        _showSuccessMessage(
            _context!, 'Login successful! Welcome back, $userName.');
      }

      print('=== AUTH FROM RESPONSE SUCCESS COMPLETE ===');
    } catch (e) {
      print('Error in _handleSuccessfulAuthFromResponse: $e');
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
    print('Disposing FaceBookAuthService...');
    _cleanup();
  }
}
