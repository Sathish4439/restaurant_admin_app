import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class PushService {
  static final _fcm = FirebaseMessaging.instance;

  static Future<void> init() async {
    // Request runtime notification permission
    await _requestNotificationPermission();

    // Initialize local notifications
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        log('Notification tapped with payload: ${response.payload}');
      },
    );

    // Set Android foreground presentation
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Print FCM token
    final token = await _fcm.getToken();
    log('FCM Token: $token');

    // Listen for token refresh
    _fcm.onTokenRefresh.listen((newToken) {
      log('FCM Token refreshed: $newToken');
    });

    // Foreground message handler
    FirebaseMessaging.onMessage.listen((message) async {
      log('Foreground message: ${message.notification?.title}');
      final notification = message.notification;
      if (notification != null) {
        await _showLocalNotification(notification.title, notification.body);
      }
    });

    // Notification tapped when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      log('Notification clicked (background): ${message.data}');
    });

    // Background handler (optional, if needed)
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
  }

  static Future<void> _showLocalNotification(String? title, String? body) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'General',
      channelDescription: 'General Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();
    const notificationDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      title ?? 'Notification',
      body ?? '',
      notificationDetails,
    );
  }

  static Future<void> _requestNotificationPermission() async {
    if (Platform.isAndroid) {
      final sdkInt = await _getAndroidSdkInt();
      if (sdkInt >= 33) {
        var status = await Permission.notification.status;
        if (status.isDenied) {
          final result = await Permission.notification.request();
          if (result.isPermanentlyDenied) {
            await openAppSettings();
          }
        }
      }
    } else if (Platform.isIOS) {
      await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  static Future<int> _getAndroidSdkInt() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    return androidInfo.version.sdkInt;
  }
}

Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  log('Background message: ${message.messageId}');
}
