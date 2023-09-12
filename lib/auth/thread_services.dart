import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ThreadServices extends ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

// Firestore collection for users
//   Future<void> addUser(String userId, String name, String email) async {
//     await _firebaseFirestore.collection('users').doc(userId).set({
//       'name': name,
//       'email': email,
//       // Add other user-related fields here
//     });
//   }

// // Function to add a chat thread document to Firestore
//   Future<void> addChatThread(
//       List<String> participants, String lastMessage) async {
//     await _firebaseFirestore.collection('chat_threads').add({
//       'participants': participants,
//       'lastMessage': lastMessage,
//       'timestamp': FieldValue.serverTimestamp(),
//       // Add other thread-related fields here
//     });
//   }

  Future save(String currentUserId, String reciverId, String threadName) async {
    List<String> uids = [currentUserId, reciverId];
    uids.sort();
    String threadId = uids.join('_');

    await _firebaseFirestore.collection('threads').doc(threadId).set(
      {
        'threadId': threadId,
        'currentUserId': currentUserId,
        'recieverId': reciverId,
        'threadName': threadName
      },
    );
  }

  // Future getThread(String currentUserId,String recieverId,String threadName) async {
  //    List<String> uids = [currentUserId, recieverId, threadName];
  //   uids.sort();
  //   String threadId = uids.join('_');

  //   firebaseFirestore.collection('threads').doc(threadId).get();
  // }

  Stream<QuerySnapshot> getThread(
      String currentUserId, String reciverId, String threadName) {
    List<String> uids = [currentUserId, reciverId];
    uids.sort();
    String chatRoomId = uids.join('_');
    return _firebaseFirestore
        .collection('threads')
        .doc(chatRoomId)
        .collection('threadNames')
        .orderBy('timeStamp', descending: false)
        .snapshots();
  }
}
