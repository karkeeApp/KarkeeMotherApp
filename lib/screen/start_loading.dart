import 'dart:async';
import 'dart:io';

import 'package:carkee/components/network_api.dart';
import 'package:carkee/config/app_configs.dart';
import 'package:carkee/config/config_setting.dart';
import 'package:carkee/config/singleton.dart';
import 'package:carkee/config/strings.dart';
import 'package:carkee/models/ModelEndpoint.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:logger/logger.dart';

// import 'package:overlay_support/overlay_support.dart';

// var appVersion = "1.0.0";//always QA!
//1.0.3 start phase 2


//init data for push noti
PushNotification _notificationInfo;//model noti
int _totalNotifications;


/// Define a top-level named handler which background/terminated messages will
/// call.
///
/// To verify things are working, check out the native platform logs.
Future<void> _firebaseMessagingBackgroundHandler(Map<String, dynamic> message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message}');
}
//
//
// //this for android
// Future<dynamic> _firebaseMessagingBackgroundHandler(
//     Map<String, dynamic> message,
//     ) async {
//   // Initialize the Firebase app
//   // await Firebase.initializeApp();
//   print('onBackgroundMessage received: $message');
//   // if (message.containsKey('data')) {
//   //   // Handle data message
//   //   final dynamic data = message['data'];
//   //   print(data);
//   // }
//   // if (message.containsKey('aps')) {
//   //   // Handle data message
//   //   final dynamic data = message['aps'];
//   //   print(data['alert'].title);
//   // }
//   //
//   // if (message.containsKey('notification')) {
//   //   // Handle notification message
//   //   final dynamic notification = message['notification'];
//   // }
// }


var logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    printTime: true,
  ),
);
// final FirebaseMessaging firebaseMessaging = FirebaseMessaging();//flutter v1
// //FirebaseMessaging.instance
final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
class StartLoading extends StatefulWidget {

  static AssetImage getAssetImage() => AssetImage("assets/images/launch_image.png");
  static Future<void> preload() async {
    final ImageStream imageStream =
    getAssetImage().resolve(ImageConfiguration.empty);
    final Completer completer = Completer();
    final ImageStreamListener listener = ImageStreamListener(
          (ImageInfo imageInfo, bool synchronousCall) => completer.complete(),
      onError: (e, stackTrace) => completer.completeError(e, stackTrace),
    );
    imageStream.addListener(listener);
    return completer.future
        .whenComplete(() => imageStream.removeListener(listener));
  }

  @override
  _StartLoadingState createState() => _StartLoadingState();
}

class _StartLoadingState extends State<StartLoading> {


  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    callAPIGetEndpoint();
    registerNotification();//ask permission for notification
    if(kReleaseMode){ // is Release Mode ??
      print('🍎 release mode');
    } else {
      print('🍏 debug mode');
    }
  }
  //flutter 2 config
  void registerNotification() async {
    // Initialize the Firebase app
    await Firebase.initializeApp();

    // On iOS, this helps to take the user permissions
    //https://firebase.flutter.dev/docs/messaging/permissions
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
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
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    // For handling the received notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        Session.shared.showAlertPopupOneButtonNoCallBack(title: notification.title, content: notification.body);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      Session.shared.showAlertPopupOneButtonNoCallBack(title: message.notification.title ?? "", content: message.notification.body ?? "");
    });
    // Used to get the current FCM token
    FirebaseMessaging.instance.getToken().then((token) {
      print('Token: $token');
      Session.shared.box.write('firebaseToken', token);
    }).catchError((e) {
      print(e);
    });
  }

  //flutter v1
  // void registerNotification() async {
  //   // Initialize the Firebase app
  //   await Firebase.initializeApp();
  //
  //   // On iOS, this helps to take the user permissions
  //   await firebaseMessaging.requestNotificationPermissions(
  //     IosNotificationSettings(
  //       alert: true,
  //       badge: true,
  //       provisional: false,
  //       sound: true,
  //     ),
  //   );
  //
  //   // For handling the received notifications
  //   firebaseMessaging.configure(
  //     onMessage: (message) async {
  //       print('onMessage received : $message');//for
  //       final dynamic data = message['notification'] ?? message;
  //       final String title = data['title'] ?? "";
  //       final String body = data['body'] ?? "";
  //
  //       /*
  //       * {notification: {title: Lexus Singapore Unveils LS Luxury Sedan and High-Performance LC Convertible Flagships Edited, body: Singapore - Testing only }, data: {body: Singapore - Testing only , title: Lexus Singapore Unveils LS Luxury Sedan and High-Performance LC Convertible Flagships Edited}}
  //       * */
  //       // print("onMessage: $message");
  //       // _showItemDialog(message);
  //       // PushNotification notification = PushNotification.fromJson(message);
  //       // setState(() {
  //       //   _notificationInfo = notification;
  //       // });
  //       // For displaying the notification as an overlay
  //       // showSimpleNotification(
  //       //   Text(_notificationInfo.title),
  //       //   leading: NotificationBadge(totalNotifications: _totalNotifications),
  //       //   subtitle: Text(_notificationInfo.body),
  //       //   background: Colors.cyan[700],
  //       //   duration: Duration(seconds: 2),
  //       // );
  //       //
  //       Session.shared.showAlertPopupOneButtonNoCallBack(title: title, content: body);
  //     },
  //     onBackgroundMessage: Platform.isAndroid ? _firebaseMessagingBackgroundHandler : null,
  //     // onBackgroundMessage: _firebaseMessagingBackgroundHandler,
  //     onLaunch: (message) async {
  //       print('onLaunch: $message');
  //       PushNotification notification = PushNotification.fromJson(message);
  //       setState(() {
  //         _notificationInfo = notification;
  //         _totalNotifications++;
  //       });
  //     },
  //     onResume: (message) async {
  //       print('onResume: $message');
  //
  //       PushNotification notification = PushNotification.fromJson(message);
  //
  //       setState(() {
  //         _notificationInfo = notification;
  //         _totalNotifications++;
  //       });
  //     },
  //   );
  //
  //   // Used to get the current FCM token
  //   firebaseMessaging.getToken().then((token) {
  //     print('Token: $token');
  //     Session.shared.box.write('firebaseToken', token);
  //   }).catchError((e) {
  //     print(e);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
      image: DecorationImage(
          image: StartLoading.getAssetImage(),
          fit: BoxFit.cover),
    )
    );

  }

  callAPIGetEndpoint() async {
    print("start callAPIGetEndpoint");
    var network = NetworkAPI(
        endpoint: url_getsetting, jsonQuery: {
          "v": ConfigSetting.appVersion,
          "e": "ios",
          // "c": ConfigSetting.clubName
        }
        );
    var jsonBody = await network.callAPIGetSetting();
    if (jsonBody["code"] == 100) {
      Session.shared.saveModelEnpoint(ModelEndpoint.fromJson(jsonBody));
      handleGoNextScreenV2();//movsau khi get api setting e xuống
    } else {
      print("❌❌❌❌ ${jsonBody["message"]}");

      Session.shared.showAlertPopupOneButtonWithCallback(
          content: jsonBody["message"] ?? "", callback: callAPIGetEndpoint);
    }
  }

  handleGoNextScreenV2() async {
    //check have token -> go dashboard, if not token -> go guestView
    var tokenCheck = await Session.shared.getToken();
    if (tokenCheck != null && tokenCheck.length > 4) {
      Session.shared.isLoged = true;
      var isHaveRememberMe = Session.shared.box.read(Strings.rememberme);
      if (isHaveRememberMe != null && isHaveRememberMe == true) {
        Session.shared.changeRootViewAfterLogin();
      } else {
        Session.shared.changeRootViewAfterLogin();
      }
    } else {
      print("no token go GuestScreen");
      // Session.shared.changeRootViewToLogin();
      // Session.shared.changeRootViewToGuest();
      Session.shared.changeRootViewToDashBoard();//GUEST go direct
    }
    // if (Session.shared.isLogedin()) {
    //   print("have token go LoginScreen");
    //
    //   //if
    //   var isHaveRememberMe = Session.shared.box.read(Strings.rememberme);
    //   if (isHaveRememberMe != null && isHaveRememberMe == true) {
    //     Session.shared.changeRootViewAfterLogin();
    //   } else {
    //     Session.shared.changeRootViewAfterLogin();
    //   }
    // } else {
    //   print("no token go GuestScreen");
    //   // Session.shared.changeRootViewToLogin();
    //   // Session.shared.changeRootViewToGuest();
    //   Session.shared.changeRootViewToDashBoard();//GUEST go direct
    // }

  }
  checkToken() async {
    var tokenSaved = await Session.shared.getToken();
    print("tokenSaved $tokenSaved");
  }
}


//model for push noti
class PushNotification {
  PushNotification({
    this.title,
    this.body,
    this.dataTitle,
    this.dataBody,
  });

  String title;
  String body;
  String dataTitle;
  String dataBody;

  factory PushNotification.fromJson(Map<String, dynamic> json) {
    return PushNotification(
      title: json["notification"]["title"],
      body: json["notification"]["body"],
      dataTitle: json["data"]["title"],
      dataBody: json["data"]["body"],
    );
  }
}
class NotificationBadge extends StatelessWidget {
  final int totalNotifications;

  const NotificationBadge({@required this.totalNotifications});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: new BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '$totalNotifications',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}