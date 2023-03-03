import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String username;
  final String phoneNumber;
  final String email;
  final String photoUrl;

  const User(
      {required this.uid,
        required this.username,
        required this.phoneNumber,
        required this.email,
        required this.photoUrl,
      });

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      uid: snapshot["uid"],
      username: snapshot["username"],
      phoneNumber: snapshot["phoneNumber"],
      email: snapshot["email"],
      photoUrl: snapshot["photoUrl"],
    );
  }

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "username": username,
    "phoneNumber": phoneNumber,
    "email": email,
    "photoUrl": photoUrl,
  };
}