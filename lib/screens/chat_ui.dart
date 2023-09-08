import 'package:flutter/material.dart';

class ChatUi extends StatelessWidget {
  final String message;

  const ChatUi({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.blue),
      child: Text(
        message,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
