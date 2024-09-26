import 'dart:developer';

import 'package:chat_app/utils/helper/local_notification_helper.dart';
import 'package:chat_app/views/screens/chat_page.dart';
import 'package:chat_app/views/screens/homepage.dart';
import 'package:chat_app/views/screens/loginpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> onbackground(RemoteMessage remotemessage) async {
  log("=====BACKGROUND NOTIFICATION=======");
  log("Title: ${remotemessage.notification!.title}");
  log("Body: ${remotemessage.notification!.body}");
  log("Custom Data: ${remotemessage.data}");
  log("===================");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onMessage.listen((RemoteMessage remotemessage) {
    log("=====FOREGROUND NOTIFICATION=======");
    log("Title: ${remotemessage.notification!.title}");
    log("Body: ${remotemessage.notification!.body}");
    log("Custom Data: ${remotemessage.data}");
    log("===================");
    LocalNotificationHelper.localNotificationHelper.showSimpleNotification(
        id: remotemessage.notification!.title!,
        name: remotemessage.notification!.body!);
  });
  FirebaseMessaging.onBackgroundMessage(onbackground);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: "login",
    routes: {
      '/': (context) => Homepage(),
      'login': (context) => Loginpage(),
      'chat_page': (context) => ChatPage(),
    },
  ));
}
