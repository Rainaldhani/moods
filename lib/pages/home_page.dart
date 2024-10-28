import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:moodku/pages/debug_page.dart';
import 'package:moodku/pages/mood_picker.dart';
import 'package:moodku/pages/showdialog_pairing.dart';

import 'package:moodku/services/auth/auth_service.dart';

import 'package:moodku/pages/setting_page.dart';
import 'package:moodku/services/auth/get_data_from_database.dart';
import 'package:moodku/services/auth/login_or_register.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  String? coupleDocId;
  String userEmail = "";
  String userMoods = "";
  String userUid = "";
  String friendEmail = "";
  String friendMoods = "";
  String friendUid = "";
  String currentUserMoodImg = "";
  String friendUserMoodImg = "";

  @override
  void initState() {
    super.initState();
    String currentUserUid = authService.getCurrentUser()!.uid;
    fetchAndDisplayUser(currentUserUid);
  }

  final user = FirebaseAuth.instance.currentUser;

  void fetchAndDisplayUser(String uid) async {
    setState(() {
      isLoading = true;
    });

    // Fetch the current user
    TableUsers? user = await TableUsers.getUserByUid(uid);

    // Check if user is not null
    if (user != null) {
      // Fetch the couple's UID
      String? coupleUID = await TableCouples.getFriendUid(uid);

      if (coupleUID != null) {
        // Fetch friend's details if coupleUID is available
        TableUsers? friend = await TableUsers.getUserByUid(coupleUID);

        if (friend != null) {
          // Fetch mood images for both users
          String? currentUserMoodImage =
              await TableMood.getMoodUser(user.moods) ??
                  "lib/assets/images/sad.png";
          String? friendUserMoodImage =
              await TableMood.getMoodUser(friend.moods) ??
                  "lib/assets/images/sad.png";

          // Update state with user's and friend's data
          setState(() {
            userEmail = user.email;
            userMoods = user.moods;
            userUid = user.uid;
            friendUid = coupleUID;
            friendMoods = friend.moods;
            friendEmail = friend.email;
            currentUserMoodImg = currentUserMoodImage;
            friendUserMoodImg = friendUserMoodImage;
            isLoading = false;
          });
        } else {
          // Handle the case where the friend is null
          setState(() {
            isLoading = false;
            friendEmail =
                "Friend data not found"; // Custom message or default handling
          });
        }
      } else {
        // Handle the case where coupleUID is null
        setState(() {
          isLoading = false;
          friendEmail =
              "No pairing found"; // Custom message or default handling
        });
      }
    } else {
      // Handle the case where the user is null
      setState(() {
        isLoading = false;
        userEmail = "User data not found"; // Custom message or default handling
      });
    }
  }

  void updateMood(String moodName) async {
    setState(() {
      userMoods = moodName; // Update the mood name
      isLoading = true;
    });
    String? currentUserMoodImage = await TableMood.getMoodUser(userMoods);
    setState(() {
      currentUserMoodImg = currentUserMoodImage!;
      isLoading = false;
    });
  }

  // Function logout
  void logout() {
    final auth = AuthService();
    auth.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginOrRegister()),
    );
  }

  Future<bool> checkIfConnected = AuthService().checkIfConnected();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkIfConnected,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          if (snapshot.data == true) {
            return Scaffold(
              drawer: Drawer(
                child: Column(
                  children: [
                    DrawerHeader(
                      child: Icon(Icons.abc, size: 64),
                    ),
                    Expanded(child: Container()),
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: ListTile(
                        title: Text("HOME"),
                        leading: Icon(Icons.home, size: 32),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: ListTile(
                        title: Text("SETTING"),
                        leading: Icon(Icons.settings, size: 32),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingPage()),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: ListTile(
                        title: Text("LOGOUT"),
                        leading: Icon(Icons.logout, size: 32),
                        onTap: logout,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: ListTile(
                        title: Text("DEBUG"),
                        leading: Icon(Icons.logout, size: 32),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DebugPage()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              appBar: AppBar(
                title: Text("What's your mood?"),
              ),
              body: isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.man_3, size: 42),
                                        Text(userEmail),
                                        SizedBox(height: 50),
                                        Image.asset(
                                          currentUserMoodImg,
                                          height: 70,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.man_3, size: 42),
                                        Text(friendEmail),
                                        SizedBox(height: 50),
                                        Image.asset(
                                          friendUserMoodImg,
                                          height: 70,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        MoodPicker(
                          onMoodSelected: updateMood,
                        ),
                      ],
                    ),
            );
          } else {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Your ID:  "),
                    SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: currentUserUid));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(currentUserUid),
                          SizedBox(
                            width: 20,
                          ),
                          Icon(Icons.file_copy)
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text("Pairing Needed before use."),
                    SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialogPairing(context);
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.amber,
                        ),
                        child: Text("PAIRING"),
                      ),
                    ),
                    SizedBox(height: 30),
                    GestureDetector(
                      onTap: () {
                        logout();
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color.fromARGB(255, 255, 181, 181),
                        ),
                        child: Text("LOGOUT"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        } else {
          return Center(child: Text('No connection status available.'));
        }
      },
    );
  }
}
