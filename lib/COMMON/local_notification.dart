import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Local Notification Handle
class LocalNotification {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // LocalNotification Show

  static Future<String?> getFCMToken() async {
    try {
      FirebaseMessaging instance = FirebaseMessaging.instance;
      String? token = await instance.getToken();
      print('Vijay Token==${token}');
      return token;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<void> showNotification(
      RemoteMessage message, String? title, String? body,
      {bool isType = false}) async {
    if (Platform.isAndroid) {
      flutterLocalNotificationsPlugin.cancelAll();
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('ic_launcher');
    const DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    InitializationSettings initializationSettings =
    const InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    AndroidNotificationDetails androidNotificationDetails =
    const AndroidNotificationDetails(
        'high_importance_channel', 'High Importance Notifications',
        channelDescription:
        'This channel is used for important notifications.',
        importance: Importance.high,
        timeoutAfter: 1500,
        ticker: 'ticker');

    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
    NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        0, title, body, notificationDetails,
        payload: jsonEncode(message.data));
  }
}