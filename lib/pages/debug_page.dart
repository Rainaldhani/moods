import 'package:flutter/material.dart';

import 'package:moodku/services/auth/auth_service.dart';
import 'package:moodku/services/auth/get_data_from_database.dart';

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
            Image.asset(moodImg),
          ],
        ),
      ),
    );
  }
}
