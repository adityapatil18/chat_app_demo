import 'dart:async';

import 'package:chat_app2/auth/chat_services.dart';
import 'package:chat_app2/widgets/custom_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(
      {super.key, required this.reciverUserEmail, required this.reciverUserID});
  final String reciverUserEmail;
  final String reciverUserID;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatServices _chatServices = ChatServices();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  var streamController = StreamController.broadcast();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      List<String> ids = [widget.reciverUserID, _firebaseAuth.currentUser!.uid];
      ids.sort();
      String chatRoomId = ids.join('_');
      _chatServices.getMessages(chatRoomId, streamController);
    });
    super.initState();
  }

  void sendMessage() async {
    // only send message if there is something to send
    if (_messageController.text.isNotEmpty) {
      await _chatServices.sendMessage(
          widget.reciverUserID, _messageController.text);

      // clear the text controller after sending the message
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reciverUserEmail),
      ),
      body: Column(
        children: [
          // messages
          Expanded(
            child: _buildMessageList(),
          ),

          // user input
          _buildMessageInput(),
        ],
      ),
    );
  }

  // build message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: streamController.stream,
      builder: (context, snapshot) {
        print("This is snapshot $snapshot");
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Loading......');
        }
        // print(snapshot.data?.docs);
        // return Container();
        return snapshot.data!.docs.length > 0
            ? ListView(
                children: List.generate(
                    snapshot.data!.docs.length,
                    (index) =>
                        _buildMessageItem(snapshot.data!.docs[index])).toList(),
              )
            : const Center(
                child: Text("No Messages"),
              );
      },
    );
  }

  //build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // align messages to the right if sender is the current user,otherwise left

    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text(data['senderEmail']),
            Text(data['message']),
          ],
        ),
      ),
    );
  }

  //build message input
  Widget _buildMessageInput() {
    return Row(
      children: [
        //text field
        Expanded(
          child: CustomTextFiled(
            controller: _messageController,
            hintText: 'enter message',
            obsecureText: false,
          ),
        ),
        //sendButton
        IconButton(
          onPressed: () {
            sendMessage();
          },
          icon: Icon(
            Icons.send,
            size: 30,
          ),
        ),
      ],
    );
  }
}
