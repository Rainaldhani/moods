import 'package:flutter/material.dart';
import 'package:moodku/pages/login_page.dart';
import 'package:moodku/pages/register_page.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool isLogin = true;

  void togglePages() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLogin) {
      return LoginPage(
        switchPage: togglePages,
      );
    } else {
      return RegisterPage(
        switchPage: togglePages,
      );
    }
  }
}
