import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FBMessaging {
  FBMessaging._();
  static FBMessaging _instance = FBMessaging._();
  static FBMessaging get instance => _instance;
  String _token;

  Future<void> init() async {
//    await checkPushPermission();
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      String token = await messaging.getToken();
      _token = token;
      print("tokenFirebase  $_token");
      _listener();
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  _listener(){
    FirebaseMessaging.onMessage.listen((message) {

      String title = message.notification.title;
      String body = message.notification.body;
      print("receive message title:::::::: $title");
      print("receive message body:::::::: $body");
      Get.defaultDialog(title: title, content: Text(body));
    });
  }

//  checkPushPermission() async {
//    var pushPermission = await html.window.navigator.permissions.query({"name": "push"});
//    print('push permission: ${pushPermission.state}');
//  }
}