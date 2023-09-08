import 'dart:async';
import 'dart:io';

import 'package:chat_app2/modal/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ChatServices extends ChangeNotifier {
  //instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //instance of storage
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  

// send message
  Future<void> sendMessage(
    String recieverId,
    String message,
  ) async {
// get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timeStamp = Timestamp.now();

    // create a  new message
    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      recieverId: recieverId,
      message: message,
      timeStamp: timeStamp,
    );

    //create chat room id from current user id and reciver id (sorted to ensure uniqueness)
    List<String> ids = [currentUserId, recieverId];
    ids.sort(); // sort the ids which insures that the chat  room is always same for any pair of any two people
    String chatRoomId = ids
        .join('_'); // combine the ids into single string to use as a chatroom

    //add new  message to database
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  // get messages
  void getMessages(String chatThreadId, StreamController controller) {
    _firestore
        .collection('chat_rooms')
        .doc(chatThreadId)
        .collection('messages')
        .orderBy('timeStamp', descending: false)
        .snapshots()
        .listen((event) {
      controller.sink.add(event);
    });
  }

//images to upload in storage

  UploadTask uploadImageFile(File image) {
    Reference reference = _firebaseStorage.ref().child('aditya');
    UploadTask uploadTask = reference.putFile(image);
    return uploadTask;
  }
}

class MessageType {
  static const image = 1;
}
