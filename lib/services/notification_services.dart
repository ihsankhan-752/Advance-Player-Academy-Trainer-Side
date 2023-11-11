import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:advance_player_academy_trainer/utils/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void getNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: true,
      carPlay: true,
      criticalAlert: true,
      announcement: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print("Request Granted");
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        if (kDebugMode) {
          print("Provisional State Granted");
        }
      } else {
        return;
      }
    }
  }

  void initLocalNotifications(BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(android: androidInitializationSettings, iOS: iosInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSetting, onDidReceiveNotificationResponse: (payload) {
      handleMessage(context, message, message.data['userId']);
    });
  }

  void initNotification(BuildContext context) async {
    //terminated State
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print("Terminated State");
    }

    //foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
      if (Platform.isAndroid) {
        initLocalNotifications(context, remoteMessage!);
        showNotification(context, remoteMessage);
        handleMessage(context, remoteMessage, remoteMessage.data['userId']);
      } else {
        showNotification(context, remoteMessage!);
        handleMessage(context, remoteMessage, remoteMessage.data['userId']);
      }
    });

    //   BackGround
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        print("Background State ");
      }
    });
  }

  void getDeviceToken() async {
    String? token = await messaging.getToken();
    await FirebaseFirestore.instance.collection("tokens").doc(FirebaseAuth.instance.currentUser!.uid).set({
      "token": token,
    });
  }

  Future<void> showNotification(BuildContext context, RemoteMessage message) async {
    initLocalNotifications(context, message);
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      "High Importance Notification",
      importance: Importance.max,
    );
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: "your channel description",
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
      presentSound: true,
      presentBadge: true,
      presentAlert: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
      );
    });
  }

  void handleMessage(BuildContext context, RemoteMessage message, String? userId) {
    if (message.data['userId'] == userId) {
    } else {
      print("Error");
    }
  }

  static sendNotificationToUser({String? title, String? body, String? userId}) async {
    DocumentSnapshot snap = await FirebaseFirestore.instance.collection("tokens").doc(userId).get();
    Map<String, String> notificationHeader = {
      "Content-Type": "application/json",
      "Authorization": messagingApiKey,
    };

    Map notificationBody = {
      "title": title,
      "body": body,
    };

    Map notificationData = {
      "status": "done",
      "userId": userId,
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
    };

    Map notificationFormat = {
      "notification": notificationBody,
      "data": notificationData,
      "to": snap['token'],
      "priority": "high",
    };

    http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: notificationHeader,
      body: jsonEncode(notificationFormat),
    );
  }
}
