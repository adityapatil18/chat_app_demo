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

