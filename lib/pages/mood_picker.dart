import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moodku/dummy/mood_list.dart';
import 'package:moodku/services/auth/get_data_from_database.dart';

class MoodPicker extends StatefulWidget {
  final Function(String moodName) onMoodSelected;

  const MoodPicker({required this.onMoodSelected, super.key});
  @override
  State<MoodPicker> createState() => _MoodPickerState();
}

class _MoodPickerState extends State<MoodPicker> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> updateMood(String newMood) async {
    // Update the user's mood in the Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserUid)
        .update({
      'moods': newMood,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: ListView.builder(
          itemCount: moods.length,
          itemBuilder: (BuildContext context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              child: GestureDetector(
                onTap: () async {
                  String newMood = moods[index]
                      .moodName; // Replace with the mood you want to set
                  await updateMood(newMood);
                  widget.onMoodSelected(newMood);
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 1),
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        height: 100,
                        child: Image.asset(
                          moods[index].moodImage,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Container(
                        child: Text(
                          moods[index].moodName,
                          style: TextStyle(fontFamily: 'Lexend', fontSize: 32),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
