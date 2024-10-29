import 'package:flutter/material.dart';

import 'package:moodku/pages/showdialog.dart';

import 'package:moodku/services/auth/auth_service.dart';
import 'package:moodku/services/auth/get_data_from_database.dart';
import 'package:moodku/services/auth/login_or_register.dart';

class DebugPage extends StatefulWidget {
  const DebugPage({super.key});

  @override
  State<DebugPage> createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  String userEmail = "";
  String userMoods = "";
  String userUid = "";
  String friendEmail = "";
  String friendMoods = "";
  String friendUid = "";
  String moodImg = "";
  final authService = AuthService();

  @override
  void initState() {
    super.initState();
    String currentUserUid = authService.getCurrentUser()!.uid;
    fetchAndDisplayUser(currentUserUid);
  }

  void fetchAndDisplayUser(String uid) async {
    TableUsers? user = await TableUsers.getUserByUid(uid);
    String? coupleUID = await TableCouples.getFriendUid(uid);
    TableUsers? friend = await TableUsers.getUserByUid(coupleUID!);
    String? moodImage = await TableMood.getMoodUser(user!.moods);
    print("Email: ${user.email}, Moods: ${user.moods}, UID: ${user.uid}");

    setState(() {
      userEmail = user.email;
      userMoods = user.moods;
      userUid = user.uid;
      friendUid = coupleUID;
      friendMoods = friend!.moods;
      friendEmail = friend.email;
      moodImg = moodImage!;
    });
  }

  void logout() {
    final auth = AuthService();
    auth.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginOrRegister()),
    );
  }

  void unpair() {
    final auth = AuthService();
    auth.unpair(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text("Email: $userEmail"),
            SizedBox(height: 30),
            Text("Moods: $userMoods"),
            SizedBox(height: 30),
            Text("UID: $userUid"),
            SizedBox(height: 30),
            Text("Email: $friendEmail"),
            SizedBox(height: 30),
            Text("Moods: $friendMoods"),
            SizedBox(height: 30),
            Text("Friend UID: $friendUid"),
            SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                showDialogConfirmation(context, "Sure Wanna LOG OUT?", logout);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 242, 173, 36),
                    borderRadius: BorderRadius.circular(50)),
                child: Text(
                  "Log Out",
                  style: TextStyle(
                      color: Colors.black, fontSize: 16, fontFamily: 'Lexend'),
                ),
              ),
            ),
            SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                showDialogConfirmation(context, "Sure Wanna Unpair?", unpair);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 242, 173, 36),
                    borderRadius: BorderRadius.circular(50)),
                child: Text(
                  "Unpair",
                  style: TextStyle(
                      color: Colors.black, fontSize: 16, fontFamily: 'Lexend'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
