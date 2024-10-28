import 'package:flutter/material.dart';
import 'package:moodku/pages/home_page.dart';
import 'package:moodku/services/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  final void Function()? switchPage;
  const LoginPage({super.key, required this.switchPage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String errorMsg = "";
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void login(BuildContext context) async {
    // get firebase auth service
    final authService = AuthService();

    // try login
    try {
      await authService.signInWithEmailPassword(
          usernameController.text, passwordController.text);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                errorMsg,
                style: const TextStyle(
                  color: Colors.red,
                  fontFamily: 'Lexend',
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 255, 166, 33),
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 231, 180, 103),
                    ),
                  ),
                  labelText: "Username",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 255, 166, 33),
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 231, 180, 103),
                    ),
                  ),
                  labelText: "Password",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text("Login"),
                ),
                onTap: () {
                  login(context);
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      fontSize: 16,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.switchPage,
                    child: Text(
                      "\tRegister now",
                      style: TextStyle(fontFamily: 'Lexend', fontSize: 16),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
