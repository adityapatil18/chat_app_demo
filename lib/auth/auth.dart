import 'package:chat_app2/screens/users_page.dart';
import 'package:chat_app2/screens/login_page.dart';
import 'package:chat_app2/screens/threads_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth extends StatelessWidget {
  const Auth({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ThreadPage();
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }
}
