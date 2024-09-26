import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class FCMNotificationHelper {
  FCMNotificationHelper._();
  static final FCMNotificationHelper fCMNotificationHelper =
      FCMNotificationHelper._();

  static final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future<String?> fetchFMCToken() async {
    String? token = await firebaseMessaging.getToken();
    return token;
  }

  Future<String> getAccessToken() async {
    final accountCredentials = ServiceAccountCredentials.fromJson(
      await rootBundle.loadString(
          'assets/fir-chat-app-9303e-firebase-adminsdk-4c3xw-64922fb1dd.json'),
    );
    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
    final authClient =
        await clientViaServiceAccount(accountCredentials, scopes);
    return authClient.credentials.accessToken.data;
  }

  Future<void> sendFCM(
      {required String title,
      required String body,
      required String tokan}) async {
    // String? token = await fetchFMCToken();
    final String accessToken = await getAccessToken();
    final String fcmUrl =
        'https://fcm.googleapis.com/v1/projects/fir-chat-app-9303e/messages:send';
    final Map<String, dynamic> myBody = {
      'message': {
        'token': tokan,
        'notification': {
          'title': title,
          'body': body,
        },
      },
    };
    final response = await http.post(
      Uri.parse(fcmUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode(myBody),
    );
    if (response.statusCode == 200) {
      print('-------------------');
      print('Notification sent successfully');
      print('-------------------');
    } else {
      print('-------------------');
      print('Failed to send notification: ${response.body}');
      print('-------------------');
    }
  }
}
