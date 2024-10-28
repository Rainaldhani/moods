import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:moodku/services/auth/auth_service.dart';

AuthService authService = AuthService();
String currentUserUid = authService
    .getCurrentUser()!
    .uid; // Asumsikan Anda mendapatkan UID pengguna saat ini

class TableUsers {
  String email;
  String moods;
  String uid;

  TableUsers({
    required this.email,
    required this.moods,
    required this.uid,
  });

  // get table from database
  static CollectionReference tableUsers =
      FirebaseFirestore.instance.collection('users');

  // Isi dokumen dari Firestore
  factory TableUsers.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return TableUsers(
      email: data?['email'] ?? '',
      moods: data?['moods'] ?? '',
      uid: data?['uid'] ?? '',
    );
  }

  // Method untuk mengambil semua data dari koleksi 'users'
  static Future<List<TableUsers>> getAllUsers() async {
    // QuerySnapshot dengan tipe data Object?
    QuerySnapshot querySnapshot = await tableUsers.get();

    // Casting dokumen menjadi Map<String, dynamic>
    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>; // Casting
      return TableUsers(
        email: data['email'] ?? '',
        moods: data['moods'] ?? '',
        uid: data['uid'] ?? '',
      );
    }).toList();
  }

  // Method untuk mengambil satu user berdasarkan uid atau dokumen ID
  static Future<TableUsers?> getUserByUid(String uid) async {
    DocumentSnapshot doc = await tableUsers.doc(uid).get();
    if (doc.exists) {
      // Jika dokumen ditemukan, convert ke TableUsers
      return TableUsers.fromFirestore(
          doc as DocumentSnapshot<Map<String, dynamic>>);
    } else {
      // Jika tidak ditemukan, return null
      return null;
    }
  }
}

class TableMood {
  String mood;
  String moodImg;

  TableMood({
    required this.mood,
    required this.moodImg,
  });

  // get table from database
  static CollectionReference tableMood =
      FirebaseFirestore.instance.collection('users');

  // Isi dokumen dari Firestore
  factory TableMood.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return TableMood(
      mood: data?['mood'] ?? '',
      moodImg: data?['moodImg'] ?? '',
    );
  }

  // Method untuk mengambil semua data dari koleksi 'users'
  static Future<List<TableMood>> getAllMood() async {
    // QuerySnapshot dengan tipe data Object?
    QuerySnapshot querySnapshot = await tableMood.get();

    // Casting dokumen menjadi Map<String, dynamic>
    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>; // Casting
      return TableMood(
        mood: data['mood'] ?? '',
        moodImg: data['moodImg'] ?? '',
      );
    }).toList();
  }

  static Future<String?> getMoodUser(String mood) async {
    String? moodImage;
    QuerySnapshot moodSnapshot = await FirebaseFirestore.instance
        .collection('moods')
        .where('mood', isEqualTo: mood)
        .get();

    if (moodSnapshot.docs.isNotEmpty) {
      final data = moodSnapshot.docs.first.data() as Map<String, dynamic>;
      moodImage = data['moodImg'];
      return moodImage;
    }
    return null;
  }
}

class TableCouples {
  String user1;
  String user2;
  String time;

  TableCouples({
    required this.user1,
    required this.user2,
    required this.time,
  });

  // get table from database
  static CollectionReference tableCouples =
      FirebaseFirestore.instance.collection('couples');

  // Isi dokumen dari Firestore
  factory TableCouples.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return TableCouples(
      user1: data?['user1'] ?? '',
      user2: data?['user2'] ?? '',
      time: data?['time'] ?? '',
    );
  }

  // Method untuk mengambil semua data dari koleksi 'couples'
  static Future<List<TableCouples>> getAllCouples() async {
    // QuerySnapshot dengan tipe data Object?
    QuerySnapshot querySnapshot = await tableCouples.get();

    // Casting dokumen menjadi Map<String, dynamic>
    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>; // Casting
      return TableCouples(
        user1: data['user1'] ?? '',
        user2: data['user2'] ?? '',
        time: data['time'] ?? '',
      );
    }).toList();
  }

  // get couples uid
  static Future<String?> getFriendUid(String uid) async {
    // Query untuk mendapatkan pasangan dari user1
    QuerySnapshot couplesSnapshot = await FirebaseFirestore.instance
        .collection('couples')
        .where('user1', isEqualTo: uid)
        .get();
    // Jika tidak ada pasangan ditemukan, cari di user2
    if (couplesSnapshot.docs.isEmpty) {
      couplesSnapshot = await FirebaseFirestore.instance
          .collection('couples')
          .where('user2', isEqualTo: uid)
          .get();
    }

    // Jika pasangan ditemukan, bandingkan UID
    if (couplesSnapshot.docs.isNotEmpty) {
      final data = couplesSnapshot.docs.first.data() as Map<String, dynamic>;
      String user1Uid = data['user1'];
      String user2Uid = data['user2'];

      // Bandingkan UID pengguna saat ini dengan user1 dan user2
      if (uid == user1Uid) {
        return user2Uid; // Kembalikan UID user2 jika currentUserUid sama dengan user1
      } else if (uid == user2Uid) {
        return user1Uid; // Kembalikan UID user1 jika currentUserUid sama dengan user2
      }
    }

    print("Tidak ada pasangan ditemukan untuk UID: $uid");
    return null; // Jika tidak ada UID pasangan ditemukan
  }
}
