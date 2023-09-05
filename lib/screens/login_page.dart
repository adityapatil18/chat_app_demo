
import 'package:chat_app2/auth/auth_services.dart';
import 'package:chat_app2/widgets/custom_button.dart';
import 'package:chat_app2/widgets/custom_textfield.dart';
import 'package:chat_app2/screens/register_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.onTap});
  final void Function()? onTap;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void signIn() async {
    final authServices = Provider.of<AuthServices>(context, listen: false);
    try {
      await authServices.signInWithEmailAndPassword(
          emailController.text, passwordController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo

                Icon(
                  Icons.wechat,
                  size: 100,
                  color: Colors.grey,
                ),
                // text
                SizedBox(
                  height: 25,
                ),
                Text(
                  'Chat App',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                SizedBox(
                  height: 50,
                ),
                // email textfield

                CustomTextFiled(
                    controller: emailController,
                    hintText: 'enter email',
                    obsecureText: false),
                SizedBox(
                  height: 10,
                ),
                CustomTextFiled(
                    controller: passwordController,
                    hintText: 'enter password',
                    obsecureText: true),

                SizedBox(
                  height: 50,
                ),
                CustomButton(
                  text: 'Sign in',
                  onTap: () {
                    signIn();
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    GestureDetector(
                      child: Text(
                        'Register',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RegisterPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
