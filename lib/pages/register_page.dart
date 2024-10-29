import 'package:flutter/material.dart';
import 'package:moodku/pages/home_page.dart';
import 'package:moodku/services/auth/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? switchPage;

  const RegisterPage({super.key, required this.switchPage});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String errorMsg = "";
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void register(BuildContext context) async {
    // get firebase auth service
    final auth = AuthService();

    //check if the password and confirmPassword is the same
    if (passwordController.text == confirmPasswordController.text) {
      // try make an account
      try {
        await auth.registerWithEmailandPassword(
            usernameController.text, passwordController.text, context);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
          (route) => false,
        );
      } catch (e) {
        // throw an error if something happened
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Password is too Weak"),
          ),
        );
      }
    } else {
      // if the password did not same
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Password is not same"),
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
                obscureText: true,
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
              TextField(
                obscureText: true,
                controller: confirmPasswordController,
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
                  labelText: "Confirm Password",
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
                  child: const Text("Register"),
                ),
                onTap: () {
                  register(context);
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(
                      fontFamily: 'Ubuntu',
                      fontSize: 16,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.switchPage,
                    child: Text(
                      "\tLogin here",
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
