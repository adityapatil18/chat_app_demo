import 'package:chat_app2/auth/auth_services.dart';
import 'package:chat_app2/auth/remote_config.dart';
import 'package:chat_app2/auth/thread_services.dart';
import 'package:chat_app2/screens/chat_page.dart';
import 'package:chat_app2/screens/threads_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
// instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final remoteConfig = FirebaseRemoteConfigService();
  TextEditingController _threadController = TextEditingController();
  final ThreadServices _threadServices = ThreadServices();

  @override
  Widget build(BuildContext context) {
    final authServices = Provider.of<AuthServices>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
            remoteConfig.getString(FirebaseRemoteConfigKeys.welcomeMessage)),
        actions: [
          IconButton(
            onPressed: () {
              authServices.signOut();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: _buildUserList(),
    );
  }

  //build list of user except logged user
  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Loading......');
        }

        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildUserListItem(doc))
              .toList(),
        );
      },
    );
  }

  //build indiviual user list items
  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    //display all user except current user
    if (_auth.currentUser!.email != data['email']) {
      return ListTile(
        title: Text(
          data['email'],
        ),
        onTap: () {
          // pass the clicked user's UID to the chat page

          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => ChatPage(
          //       reciverUserEmail: data['email'],
          //       reciverUserID: data['uid'],
          //     ),
          //   ),
          // );
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Enter your Thread Name'),
                content: TextField(
                  controller: _threadController,
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      save(data['uid']);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ThreadPage()));
                    },
                    child: Text("Ok"),
                  ),
                ],
              );
            },
          );
        },
      );
    } else {
      return Container();
    }
  }

  Future save(String reciverId) async {
    if (_threadController.text.isNotEmpty) {
      await _threadServices.save(
          _auth.currentUser!.uid, reciverId, _threadController.text.toString());
    }
  }
}
