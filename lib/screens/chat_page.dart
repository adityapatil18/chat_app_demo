import 'dart:async';
import 'dart:io';

import 'package:chat_app2/auth/chat_services.dart';
import 'package:chat_app2/auth/thread_services.dart';
import 'package:chat_app2/screens/chat_ui.dart';
import 'package:chat_app2/screens/threads_page.dart';
import 'package:chat_app2/widgets/custom_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(
      {super.key, required this.reciverUserID, required this.threadname});
  final String threadname;
  final String reciverUserID;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  File? imageFile;
  String imageUrl = '';
  bool _isLoading = false;

  final TextEditingController _messageController = TextEditingController();
  final ChatServices _chatServices = ChatServices();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  var streamController = StreamController.broadcast();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      List<String> ids = [widget.reciverUserID, _firebaseAuth.currentUser!.uid];
      ids.sort();
      String chatRoomId = ids.join('_');
      _chatServices.getMessages(widget.reciverUserID, streamController);
    });
    super.initState();
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    final pickedFile;
    pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      if (imageFile != null) {
        setState(() {
          _isLoading = true;
        });
        uploadImageFile();
      }
    }
  }

  void uploadImageFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    UploadTask uploadTask = _chatServices.uploadImageFile(
      imageFile!,
    );
    try {
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        _isLoading = false;
        sendMessage(imageUrl, MessageType.image);
      });
    } on FirebaseException catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  void sendMessage(String content, int type) async {
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
        title: Text(widget.threadname),
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ThreadPage()));
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Column(
        children: [
          // messages
          Expanded(
            child: _buildMessageList(),
          ),

          // user input
          _buildMessageInput(),

          SizedBox(
            height: 25,
          ),
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
          crossAxisAlignment:
              (data['senderId'] == _firebaseAuth.currentUser!.uid)
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
          children: [
            // Text(data['senderEmail']),
            ChatUi(message: data['message']),
          ],
        ),
      ),
    );
  }

  //build message input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          //image Button
          IconButton(
            onPressed: getImage,
            icon: Icon(
              Icons.camera_enhance_sharp,
              size: 30,
            ),
          ),
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
              sendMessage(_messageController.text, MessageType.image);
            },
            icon: Icon(
              Icons.send,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
