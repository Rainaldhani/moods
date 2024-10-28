import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moodku/pages/home_page.dart';
import 'package:moodku/services/auth/get_data_from_database.dart';

class AuthService {
  // instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // sign in
  Future<UserCredential> signInWithEmailPassword(String email, password) async {
    // create user
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // register

  Future<UserCredential?> registerWithEmailandPassword(
      String email, password, BuildContext context) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // save user info in seperate doc
      _firestore.collection("users").doc(userCredential.user!.uid).set(
        {
          "uid": userCredential.user!.uid,
          "email": email,
          "moods": "hug",
        },
      );
      return userCredential;
    } on FirebaseException catch (e) {
      _showError(context, e.code); // Show error message to the user
      return null; // Return null to indicate failure
    } catch (e) {
      _showError(context, "An unknown error occurred."); // Show generic error
      return null; // Return null to indicate failure
    }
  }

  // log out
  Future<void> signOut() async {
    return await _auth.signOut();
  }

  // check if the user has been connected
  Future<bool> checkIfConnected() async {
    QuerySnapshot connectionQuery = await FirebaseFirestore.instance
        .collection('couples')
        .where('user1', isEqualTo: _auth.currentUser?.uid)
        .get();
    if (connectionQuery.docs.isEmpty) {
      connectionQuery = await FirebaseFirestore.instance
          .collection('couples')
          .where('user2', isEqualTo: _auth.currentUser?.uid)
          .get();
    }

    return connectionQuery.docs.isNotEmpty;
  }

  // Unpairing
  Future<void> unpair(context) async {
    // find docId for now couple

    Future<String?> getCurrentDocId() async {
      QuerySnapshot user1Query = await FirebaseFirestore.instance
          .collection('couples')
          .where('user1', isEqualTo: currentUserUid)
          .get();

      if (user1Query.docs.isNotEmpty) {
        return user1Query.docs.first.id;
      }

      // Query where currentUserUid is in the 'user2' field
      QuerySnapshot user2Query = await FirebaseFirestore.instance
          .collection('couples')
          .where('user2', isEqualTo: currentUserUid)
          .get();

      if (user2Query.docs.isNotEmpty) {
        return user2Query.docs.first.id;
      }

      // No matching document found
      return null;
    }

    final currentDocId = await getCurrentDocId();
    await FirebaseFirestore.instance
        .collection('couples') // Replace with your collection name
        .doc(currentDocId)
        .delete();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  // errors

  void _showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message),
          actions: [
            TextButton(
              onPressed: () {
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
