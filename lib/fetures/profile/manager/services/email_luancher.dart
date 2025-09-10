import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

// Global navigator key for accessing context
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Reusable email launcher function that can be called from any button
class EmailLauncher {
  // Make it a singleton for easy access
  static final EmailLauncher _instance = EmailLauncher._internal();
  factory EmailLauncher() => _instance;
  EmailLauncher._internal();

  // Main function to launch email that can be called from any button
  Future<void> launchEmail({
    required String email,
    String subject = '',
    String body = '',
    BuildContext? context,
  }) async {

    // First try direct Gmail app launch (for Android)
    if (await _launchGmailApp(email, subject, body)) return;

    // Then try standard mailto: URI
    if (await _launchMailTo(email, subject, body)) return;

    // Then try Gmail web interface
    if (await _launchGmailWeb(email, subject, body)) return;

    // Finally show fallback dialog
    _showFallbackDialog(context ?? navigatorKey.currentContext, email);
  }

  Future<bool> _launchGmailApp(
      String email, String subject, String body) async {
    try {
      // Android-specific Gmail intent
      final gmailUri = Uri(
        scheme: 'googlegmail',
        host: 'co',
        path: '',
        queryParameters: {
          'to': email,
          'subject': subject,
          'body': body,
        },
      );

      if (await canLaunchUrl(gmailUri)) {
        return await launchUrl(gmailUri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
    }
    return false;
  }

  Future<bool> _launchMailTo(String email, String subject, String body) async {
    try {
      final uri = Uri(
        scheme: 'mailto',
        path: email,
        queryParameters: {
          'subject': subject,
          'body': body,
        },
      );

      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
    }
    return false;
  }

  Future<bool> _launchGmailWeb(
      String email, String subject, String body) async {
    try {
      final uri = Uri.https(
        'mail.google.com',
        '/mail',
        {
          'view': 'cm',
          'to': email,
          'su': subject,
          'body': body,
        },
      );

      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
    }
    return false;
  }

  void _showFallbackDialog(BuildContext? context, String email) {
    if (context == null || !context.mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Email App Not Found'),
        content: Text('Please install an email app or contact us at $email'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: email));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Email copied to clipboard')),
              );
              Navigator.pop(context);
            },
            child: const Text('Copy Email'),
          ),
        ],
      ),
    );
  }
}
