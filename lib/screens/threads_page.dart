import 'package:chat_app2/screens/chat_page.dart';
import 'package:chat_app2/screens/users_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ThreadPage extends StatefulWidget {
  const ThreadPage({super.key});

  @override
  State<ThreadPage> createState() => _ThreadPageState();
}

class _ThreadPageState extends State<ThreadPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Threads Page'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => UsersPage()));
        },
        child: Icon(Icons.add),
      ),
      // body: StreamBuilder<QuerySnapshot>(
      //   stream:
      //       FirebaseFirestore.instance.collection('chat_threads').snapshots(),
      //   builder: (context, snapshot) {
      //     if (!snapshot.hasData) {
      //       return CircularProgressIndicator();
      //     }
      //     // Process and display chat threads here
      //     // Use ListView.builder to display the list of threads
      //     return ListView.builder(
      //       itemCount: snapshot.data!.docs.length,
      //       itemBuilder: (context, index) {
      //         // Extract data from snapshot and display each chat thread
      //         var threadData =
      //             snapshot.data!.docs[index].data() as Map<String, dynamic>;
      //         // Build UI for each chat thread
      //         return ListTile(
      //           title: Text('Chat with User X'), // Display user names here
      //           // Handle tap on the thread to open the chat screen
      //           onTap: () {
      //             // Navigate to the chat screen for this thread
      //             Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                 builder: (context) => ChatPage(
      //                   reciverUserEmail: snapshot.data!.docs[index].id,
      //                   reciverUserID: snapshot.data!.docs[index].id,
      //                 ),
      //               ),
      //             );
      //           },
      //         );
      //       },
      //     );
      //   },
      // ),
      body: threadList(),
    );
  }

  Widget threadList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('threads').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('errror');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Waiting');
        }

        if (!snapshot.hasData) {
          return Container(
            child: Text("No data found"),
          );
        }

        // return ListView(
        //   children : snapshot.data!.docs
        //     .map<Widget>((doc) => SingleThread(doc))
        //     .toList()
        // );

        return ListView(
            children: snapshot.data!.docs
                .map<Widget>((doc) => singleThread(doc))
                .toList());

        // return SingleChildScrollView(
        //   child: Container(
        //     height: MediaQuery.of(context).size.height * (0.8),
        //     width: MediaQuery.of(context).size.width,
        //     color: Colors.transparent,
        //     child: snapshot.data!.docs.isNotEmpty
        //         ? ListView(
        //             children: List.generate(snapshot.data!.docs.length,
        //                     (index) => SingleThread(snapshot.data!.docs[index]))
        //                 .toList(),
        //           )
        //         : const Center(
        //             child: Text('No message'),
        //           ),
        //   ),
        // );
      },
    );
  }

  Widget singleThread(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    if (_auth.currentUser!.uid == data['currentUserId'] ||
        _auth.currentUser!.uid == data['recieverId']) {
      return ListTile(
        title: Text(data['threadName']),
        onTap: () {
          print(data['threadId']);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  reciverUserID: data['threadId'],
                  threadname: data['threadName'],
                ),
              ));
        },
      );
    } else {
      return Container();
    }
  }
  //   return ListTile(
  //     title: Text(data['uid']),
  //   );
  // }
}
