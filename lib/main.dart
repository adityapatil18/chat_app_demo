import 'package:chat_app2/auth/auth.dart';
import 'package:chat_app2/auth/auth_services.dart';
import 'package:chat_app2/auth/messaging_services.dart';
import 'package:chat_app2/auth/remote_config.dart';
import 'package:chat_app2/screens/notification_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // FirebaseCrashlytics.instance.crash();
  FirebasePerformance _performance = FirebasePerformance.instance;
  await FirebaseRemoteConfigService().initialize();

  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthServices(),
      child: ChatApp1(),
    ),
  );
}

class ChatApp1 extends StatelessWidget {
  const ChatApp1({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Auth(),
      navigatorKey: navigatorKey,
      routes: {
        '/notification_screen': (context) => NotificationPage(),
      },
    );
  }
}
