
import 'package:chat_app2/auth/auth_services.dart';
import 'package:chat_app2/widgets/custom_button.dart';
import 'package:chat_app2/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, this.onTap});
  final void Function()? onTap;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void signUp() async {
    final authServices = Provider.of<AuthServices>(context, listen: false);

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password does not match'),
        ),
      );
      return;
    }

    try {
      await authServices.signUpWithEmailAndPassword(
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
                  size: 80,
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
                  height: 30,
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
                  height: 10,
                ),
                CustomTextFiled(
                    controller: confirmPasswordController,
                    hintText: 're-enter password',
                    obsecureText: true),

                SizedBox(
                  height: 50,
                ),
                CustomButton(
                  text: 'Sign Up',
                  onTap: () {
                    signUp();
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?"),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
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
