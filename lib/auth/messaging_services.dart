// import 'package:chat_app2/main.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// class FirebaseMessging {
//   // instance
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

//   // functions to intialize notifications
//   Future<void> initNotifications() async {
//     // request permission from user
//     await _firebaseMessaging.requestPermission();

//     //Fetch the fcm token
//     final fcmToken = await _firebaseMessaging.getToken();

//     // print token
//     print('Token: $fcmToken');

//     initPushNotifications();
//   }

//   // function to handel recived message
//   void handelMessges(RemoteMessage? message) {
//     // if message is null do nothing
//     if (message == null) return;
//     // navigate to new screens when message is recived and uses tap notifications
//     navigatorKey.currentState
//         ?.pushNamed('/notification_screen', arguments: message);
//   }

//   // functions to handel background settings
//   Future initPushNotifications() async {
//     // handel notifications if the app was terminated and now open

//     FirebaseMessaging.instance.getInitialMessage().then(handelMessges);

//     // attach event listners for when a notifications opens the app
//     FirebaseMessaging.onMessageOpenedApp.listen(handelMessges);
//   }
// }

/////////////////////////////////////////
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class NotificationService {
//   static const Key =
//       'AAAAumu0igQ:APA91bF3b1ona0wdAUyzyz4n3Q2pRBOwVJh3TkF7k6L4riNj4S4SMiQnkpNI4eQJXW0GPRSImRYjdVbcnOXFP_P1L_HdtGMEQzN4zv9v3lzi2FAcDI51qu3LkSQyxRDzT4eOnAR8Kw0j';

//   final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   void initLocalNotification() {
//     const androidSettings =
//         AndroidInitializationSettings('"@mipmap/ic_launcher');
//     const initializationSettings =
//         InitializationSettings(android: androidSettings);
//     flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: (details) {
//         debugPrint(details.payload.toString());
//       },
//     );
//   }

//   Future<void> _showLocalNotifications(RemoteMessage message) async {
//     final androidDetals = AndroidNotificationDetails(
//         'mychannelid', 'com.example.chat_app2.urgent',
//         importance: Importance.max,
//         styleInformation: styleInformation,
//         priority: Priority.max);
//     final notificationDetails = NotificationDetails();
//     await flutterLocalNotificationsPlugin.show(
//         0, message.notification!.body, message.notification!.title);
//   }
// }
