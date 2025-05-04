import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationServices {
  static String? myToken = "";
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize push notification services
  static Future init() async {
    // Request notification permissions
    await messaging.requestPermission();

    // Get FCM token
    String? token = await messaging.getToken();
    myToken = token;
    log("FCM Token: ${token ?? "null"}");

    // Initialize local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("Foreground message received: ${message.notification?.title}");
      showNotification(message);
    });

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(handelBackGroudMessage);
  }

  // Show local notification
  static Future<void> showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id', // Channel ID
      'your_channel_name', // Channel name
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      message.notification?.title, // Title
      message.notification?.body, // Body
      platformChannelSpecifics,
    );
  }

  // Handle background messages
  static Future<void> handelBackGroudMessage(RemoteMessage message) async {
    await Firebase.initializeApp();
    log("Background message received - Title: ${message.notification?.title ?? "Null"}");
  }
}
