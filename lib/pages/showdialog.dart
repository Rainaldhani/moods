import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

TextEditingController pairedUid = TextEditingController();

Future<void> pairing(context) async {
  final user = FirebaseAuth.instance.currentUser;

  // Cari pengguna berdasarkan email pasangan
  final partnerQuery = await FirebaseFirestore.instance
      .collection('users')
      .where('uid', isEqualTo: pairedUid.text)
      .get();

  if (partnerQuery.docs.isNotEmpty) {
    final partnerData = partnerQuery.docs.first;
    final partnerUID = partnerData.id;

    // Cek apakah pasangan sudah ada dalam koleksi couples
    final coupleQuery = await FirebaseFirestore.instance
        .collection('couples')
        .where('user1', isEqualTo: partnerUID)
        .get();

    final reverseCoupleQuery = await FirebaseFirestore.instance
        .collection('couples')
        .where('user2', isEqualTo: partnerUID)
        .get();

    if (coupleQuery.docs.isNotEmpty || reverseCoupleQuery.docs.isNotEmpty) {
      // Jika pasangan sudah ada di koleksi couples
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("ID tersebut sudah berada dalam pasangan lain."),
            actions: [
              TextButton(
                onPressed: () {
                  pairedUid.clear();
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      // Jika pasangan belum ada di koleksi couples,
      // cek apakah isi UIDnya adalah UID user sendiri
      if (pairedUid.text == user?.uid) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Really? u wanna have sex with urself?"),
              actions: [
                TextButton(
                  onPressed: () {
                    pairedUid.clear();
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      } else {
        // jika UID valid dan bukan UID user sendiri, tambahkan ke couple
        await FirebaseFirestore.instance.collection('couples').add({
          'user1': user?.uid,
          'user2': partnerUID,
          'time': DateTime.now(),
        });
      }
    }
  } else {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Pasangan tidak ditemukan"),
          actions: [
            TextButton(
              onPressed: () {
                pairedUid.clear();
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}

Future<void> showDialogPairing(BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Your Love Email"),
        content: TextField(
          controller: pairedUid,
          decoration: InputDecoration(hintText: "ID of your Love"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              pairing(context); // Call pairing function
            },
            child: Text("Enter"),
          ),
        ],
      );
    },
  );
}

showDialogConfirmation(BuildContext context, textContent, tapContent) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              textContent,
              style: TextStyle(color: Colors.black87, fontSize: 20),
            ),
          ),
          titlePadding: EdgeInsets.symmetric(horizontal: 50, vertical: 35),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    tapContent();
                  },
                  child: Text(
                    "OK",
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text(
                    "NO",
                    style: TextStyle(color: Colors.black),
                  ),
                  style:
                      TextButton.styleFrom(backgroundColor: Colors.deepOrange),
                ),
              ],
            )
          ],
        );
      });
}
