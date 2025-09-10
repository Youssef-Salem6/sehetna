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
import 'dart:io';

class FaceBookAuthService {
  static const String baseUrl = 'https://api.sehtnaa.com/api';
  static const Duration _authTimeout = Duration(minutes: 3);
  static const Duration _requestTimeout = Duration(seconds: 15);

  AppLinks? _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  BuildContext? _context;
  Timer? _timeoutTimer;
  bool _isProcessing = false;

  // Singleton pattern
  static final FaceBookAuthService _instance = FaceBookAuthService._internal();
  factory FaceBookAuthService() => _instance;
  FaceBookAuthService._internal() {
    _initializeAppLinks();
  }

  Future<void> _initializeAppLinks() async {
    try {
      _appLinks = AppLinks();
      await _checkInitialLink();
    } catch (e) {
      _appLinks = null;
    }
  }

  Future<void> _checkInitialLink() async {
    try {
      if (_appLinks == null) return;

      final uri = await _appLinks!.getInitialLink();
      if (uri != null) {
        if (_isProcessing) {
          await _handleDeepLink(uri);
        }
      }
    } catch (e) {}
  }

  /// Main entry point for Facebook authentication
  Future<void> initiateFacebookLogin(BuildContext context) async {
    if (_isProcessing) {
      return;
    }

    try {
      _isProcessing = true;
      _context = context;

      // Preparation steps
      await _clearPreviousAuthState();
      await _startListeningForDeepLinks();
      _setupTimeout();

      // Get auth URL and launch
      final authUrl = await _getFacebookAuthUrl();
      if (authUrl?.isEmpty ?? true) {
        throw Exception('Invalid auth URL received from server');
      }

      _showLoadingMessage(context, 'Opening Facebook for authentication...');
      await _launchFacebookAuth(authUrl!);
    } catch (e) {
      _showErrorMessage(
          context, 'Facebook login failed: ${_getReadableErrorMessage(e)}');
      _cleanup();
    }
  }

  Future<String?> _getFacebookAuthUrl() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/auth/social/facebook/url'),
            headers: _getDefaultHeaders(),
          )
          .timeout(_requestTimeout);

      _logResponse('GET AUTH URL', response);

      if (response.statusCode != 200) {
        throw HttpException('Failed to get auth URL: ${response.statusCode}');
      }

      final responseData = json.decode(response.body);
      return _extractAuthUrl(responseData);
    } catch (e) {
      rethrow;
    }
  }

  String? _extractAuthUrl(Map<String, dynamic> responseData) {
    // Handle different response formats from backend
    if (responseData['success'] == true && responseData['data'] != null) {
      return responseData['data']['url'];
    }

    return responseData['url'] ??
        responseData['authUrl'] ??
        responseData['auth_url'];
  }

  Future<void> _launchFacebookAuth(String authUrl) async {
    final uri = Uri.parse(authUrl);
    bool launched = false;

    try {
      // Platform-specific launch strategies
      if (Platform.isIOS) {
        launched = await _launchForIOS(uri);
      } else if (Platform.isAndroid) {
        launched = await _launchForAndroid(uri);
      }

      if (!launched) {
        launched = await _fallbackLaunch(uri);
      }

      if (launched) {
        _showLoadingMessage(_context!,
            'Complete authentication in Facebook and return to the app...');
      } else {
        throw Exception('Could not launch Facebook authentication');
      }
    } catch (e) {
      throw Exception('Failed to open Facebook login: ${e.toString()}');
    }
  }

  Future<bool> _launchForIOS(Uri uri) async {
    return await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<bool> _launchForAndroid(Uri uri) async {
    // Try external non-browser first, then fallback
    bool launched = await launchUrl(
      uri,
      mode: LaunchMode.externalNonBrowserApplication,
    );

    if (!launched) {
      launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }

    return launched;
  }

  Future<bool> _fallbackLaunch(Uri uri) async {
    return await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
  }

  Future<void> _clearPreviousAuthState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('temp_auth_state');
    } catch (e) {}
  }

  void _setupTimeout() {
    _timeoutTimer?.cancel();
    _timeoutTimer = Timer(_authTimeout, () {
      if (_context?.mounted ?? false) {
        _showErrorMessage(
            _context!, 'Authentication timed out. Please try again.');
      }
      _cleanup();
    });
  }

  Future<void> _startListeningForDeepLinks() async {
    _linkSubscription?.cancel();

    if (_appLinks == null) {
      throw Exception('Deep link functionality not available');
    }

    _linkSubscription = _appLinks!.uriLinkStream.listen(
      (uri) {
        if (_isProcessing) {
          _handleDeepLink(uri);
        }
      },
      onError: (err) {
        if (_context?.mounted ?? false) {
          _showErrorMessage(_context!, 'Deep link error: $err');
        }
        _cleanup();
      },
    );
  }

  Future<void> _handleDeepLink(Uri uri) async {
    if (!_isProcessing || _context?.mounted != true) {
      return;
    }

    _logDeepLink(uri);

    if (uri.scheme == 'sehetna' && uri.host == 'auth') {
      _timeoutTimer?.cancel();
      final queryParams = uri.queryParameters;

      if (queryParams.containsKey('error')) {
        await _handleAuthError(queryParams);
      } else if (_isSuccessResponse(queryParams)) {
        await _processSuccessResponse(queryParams);
      } else {
        _showErrorMessage(_context!, 'Invalid authentication response');
        _cleanup();
      }
    }
  }

  bool _isSuccessResponse(Map<String, String> queryParams) {
    return (queryParams['success'] == 'true') ||
        queryParams.containsKey('token') ||
        queryParams.containsKey('code') ||
        queryParams.containsKey('data');
  }

  Future<void> _processSuccessResponse(Map<String, String> queryParams) async {
    if (queryParams.containsKey('data')) {
      await _handleBase64EncodedResponse(queryParams['data']!);
    } else if (queryParams.containsKey('token')) {
      await _handleDirectToken(queryParams['token']!);
    } else if (queryParams.containsKey('code')) {
      await _exchangeCodeForToken(queryParams['code']!);
    }
  }

  Future<void> _handleAuthError(Map<String, String> queryParams) async {
    final error = queryParams['error'] ?? 'Unknown error';
    final errorDescription = queryParams['error_description'] ?? '';

    final userMessage = _getUserFriendlyErrorMessage(error, errorDescription);
    _showErrorMessage(_context!, userMessage);
    _cleanup();
  }

  String _getUserFriendlyErrorMessage(String error, String errorDescription) {
    switch (error) {
      case 'access_denied':
      case 'user_denied':
        return 'Facebook login was cancelled';
      case 'temporarily_unavailable':
        return 'Facebook is temporarily unavailable. Please try again later.';
      default:
        return errorDescription.isNotEmpty
            ? errorDescription
            : 'Authentication failed';
    }
  }

  Future<void> _handleDirectToken(String token) async {
    await _handleSuccessfulAuth(token, {});
  }

  Future<void> _exchangeCodeForToken(String code) async {
    try {
      _showLoadingMessage(_context!, 'Processing authentication...');

      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/social/facebook/callback'),
            headers: _getDefaultHeaders(),
            body: json.encode({'code': code}),
          )
          .timeout(_requestTimeout);

      _logResponse('TOKEN EXCHANGE', response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        final authData = _extractTokenAndUserData(responseData);

        if (authData['token']?.isNotEmpty ?? false) {
          await _handleSuccessfulAuth(authData['token'], authData['userData']);
        } else {
          throw Exception('No valid token received from server');
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
            errorData['message'] ?? 'Server error: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorMessage(_context!,
          'Failed to complete authentication: ${_getReadableErrorMessage(e)}');
      _cleanup();
    }
  }

  Map<String, dynamic> _extractTokenAndUserData(
      Map<String, dynamic> responseData) {
    String? token;
    Map<String, dynamic> userData = {};

    if (responseData['success'] == true && responseData['data'] != null) {
      token = responseData['data']['token'];
      userData = responseData['data']['user'] ?? {};
    } else {
      token = responseData['token'] ?? responseData['access_token'];
      userData = responseData['user'] ?? {};
    }

    return {'token': token, 'userData': userData};
  }

  Future<void> _handleSuccessfulAuth(
      String token, Map<String, dynamic> extraData) async {
    try {
      _showLoadingMessage(_context!, 'Completing login...');

      final userData = await _verifyAndGetUserData(token) ?? extraData;
      await _storeAuthData(token, userData);

      await _sendFcmToken();
      await _navigateToHome(userData);
    } catch (e) {
      _showErrorMessage(
          _context!, 'Authentication failed: ${_getReadableErrorMessage(e)}');
    } finally {
      _cleanup();
    }
  }

  Future<void> _sendFcmToken() async {
    if (_context?.mounted ?? false) {
      try {
        BlocProvider.of<SendFcmTokenCubit>(_context!).sendToken();
      } catch (e) {}
    }
  }

  Future<void> _navigateToHome(Map<String, dynamic> userData) async {
    if (_context?.mounted ?? false) {
      Navigator.pushAndRemoveUntil(
        _context!,
        MaterialPageRoute(builder: (context) => const NavView()),
        (route) => false,
      );

      final userName = _extractUserName(userData);
      _showSuccessMessage(
          _context!, 'Login successful! Welcome back, $userName.');
    }
  }

  String _extractUserName(Map<String, dynamic> userData) {
    return userData['first_name'] ?? userData['name']?.split(' ')[0] ?? 'User';
  }

  Future<Map<String, dynamic>?> _verifyAndGetUserData(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user/profile'),
        headers: {
          'Authorization': 'Bearer $token',
          ..._getDefaultHeaders(),
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['success'] == true
            ? responseData['data']
            : responseData;
      } else if (response.statusCode == 401) {
        throw Exception('Invalid token received');
      }

      return {};
    } catch (e) {
      if (e.toString().contains('Invalid token')) rethrow;
      return {};
    }
  }

  Future<void> _storeAuthData(
      String token, Map<String, dynamic> userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userInfo = _mapUserData(userData);

      // Store individual fields
      await Future.wait([
        prefs.setString('id', userInfo['id']!),
        prefs.setString('email', userInfo['email']!),
        prefs.setString('firstName', userInfo['firstName']!),
        prefs.setString('lastName', userInfo['lastName']!),
        prefs.setString('gender', userInfo['gender']!),
        prefs.setString('phone', userInfo['phone']!),
        prefs.setString('address', userInfo['address']!),
        prefs.setString('image', userInfo['image']!),
        prefs.setString('token', token),
        prefs.setBool('isFirstTime', false),
        prefs.setBool('is_logged_in', true),
        prefs.setString('user_data', json.encode(userData)),
      ]);
    } catch (e) {
      rethrow;
    }
  }

  Map<String, String> _mapUserData(Map<String, dynamic> userData) {
    final name = userData['name']?.toString() ?? '';
    final nameParts = name.split(' ');

    return {
      'id': userData['id']?.toString() ?? '',
      'email': userData['email'] ?? '',
      'firstName': userData['first_name'] ??
          userData['given_name'] ??
          (nameParts.isNotEmpty ? nameParts.first : ''),
      'lastName': userData['last_name'] ??
          userData['family_name'] ??
          (nameParts.length > 1 ? nameParts.sublist(1).join(' ') : ''),
      'gender': userData['gender'] ?? '',
      'phone': userData['phone'] ?? '',
      'address': userData['address'] ?? '',
      'image': userData['profile_image'] ??
          userData['picture'] ??
          userData['avatar'] ??
          '',
    };
  }

  Future<void> _handleBase64EncodedResponse(String encodedData) async {
    try {
      final decodedBytes = base64Decode(encodedData);
      final decodedString = utf8.decode(decodedBytes);
      final responseData = json.decode(decodedString);

      final token = responseData['token'];
      final userData = responseData['user'];

      if (token?.toString().isNotEmpty ?? false) {
        await _handleSuccessfulAuth(token.toString(), userData ?? {});
      } else {
        throw Exception('No valid token found in decoded response');
      }
    } catch (e) {
      _showErrorMessage(_context!, 'Failed to process authentication response');
      _cleanup();
    }
  }

  // Utility methods
  Map<String, String> _getDefaultHeaders() {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }

  void _logResponse(String operation, http.Response response) {}

  void _logDeepLink(Uri uri) {}

  String _getReadableErrorMessage(dynamic error) {
    final errorStr = error.toString();
    if (errorStr.contains('SocketException')) {
      return 'Network connection error. Please check your internet connection.';
    } else if (errorStr.contains('TimeoutException')) {
      return 'Request timed out. Please try again.';
    } else if (errorStr.contains('FormatException')) {
      return 'Invalid response format from server.';
    }
    return errorStr.replaceAll('Exception: ', '');
  }

  void _cleanup() {
    _timeoutTimer?.cancel();
    _linkSubscription?.cancel();
    _linkSubscription = null;
    _context = null;
    _isProcessing = false;
  }

  // UI feedback methods with improved UX
  void _showErrorMessage(BuildContext context, String message) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red.shade600,
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
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
        backgroundColor: Colors.green.shade600,
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showLoadingMessage(BuildContext context, String message) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.blue.shade600,
        content: Row(
          children: [
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                message,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 10),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Public methods
  Future<void> checkInitialLink(BuildContext context) async {
    try {
      if (_appLinks == null) return;

      final uri = await _appLinks!.getInitialLink();
      if (uri != null) {
        _context = context;
        _isProcessing = true;
        await _handleDeepLink(uri);
      }
    } catch (e) {}
  }

  void dispose() {
    _cleanup();
  }
}
