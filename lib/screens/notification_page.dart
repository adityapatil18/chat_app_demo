import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // get the notification message and display on the screen
 late   final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [Text(message.notification!.title.toString()),
          Text(message.notification!.body.toString()),
          Text(message.data.toString())],
        ),
      ),
    );
  }
}
