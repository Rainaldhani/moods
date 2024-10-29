import 'package:flutter/material.dart';

import 'package:moodku/pages/showdialog.dart';
import 'package:moodku/services/auth/auth_service.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  void unpairing() {
    final auth = AuthService();
    auth.unpair(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.amberAccent,
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialogPairing(context);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 50),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 240, 181, 3),
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.people),
                          SizedBox(
                            width: 30,
                          ),
                          Text(
                            "Pair",
                            style: TextStyle(
                              fontFamily: "Ubuntu",
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  GestureDetector(
                    onTap: () async {
                      showDialogConfirmation(
                          context, "Sure Wannar Unpair?", unpairing);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 50),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 240, 181, 3),
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.no_accounts),
                          SizedBox(
                            width: 30,
                          ),
                          Text(
                            "Unpair",
                            style: TextStyle(
                              fontFamily: "Ubuntu",
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
