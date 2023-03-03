import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homestay_raya/models/user.dart' as model;
import 'package:homestay_raya/services/firestore_methods.dart';
import 'package:homestay_raya/services/storage_methods.dart';

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user details
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
    await _firestore.collection('tourGuides').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

  // Signing Up User

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String phone,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty) {
        // registering user in auth with email and password
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        //
        model.User _user = model.User(
          uid: cred.user!.uid,
          username: username,
          phoneNumber: phone,
          email: email,
          // photoUrl: "https://firebasestorage.googleapis.com/v0/b/fyp-travel-guide-6b527.appspot.com/o/default-avatar.jpg?alt=media",
          photoUrl: "",
        );

        // // adding user in our database
        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(_user.toJson());
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      String errorMsg = err.toString();
      res = capitalize(
          errorMsg.substring(errorMsg.indexOf('/'),
              errorMsg.indexOf(']')).replaceAll(RegExp(r'/'), '').replaceAll(RegExp(r'-'), ' ')
      );
    }
    return res;
  }

  String capitalize(String string) {
    return "${string[0].toUpperCase()}${string.substring(1).toLowerCase()}";
  }

  // logging in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      String errorMsg = err.toString();
      res = capitalize(
          errorMsg.substring(errorMsg.indexOf('/'),
              errorMsg.indexOf(']')).replaceAll(RegExp(r'/'), '').replaceAll(RegExp(r'-'), ' ')
      );
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String> changePassword(String currentPassword, String newPassword) async {
    String res = "Some error Occurred";
    User user = _auth.currentUser!;

    final cred = EmailAuthProvider.credential(email: user.email ?? "", password: currentPassword);

    await user.reauthenticateWithCredential(cred).then((value) async {
      await user.updatePassword(newPassword).then((_) {
        res = "success";
      }).catchError((error) {
        res = "Some error Occurred";
      });
    }).catchError((err) {
      print(err.toString());
      res = "Wrong old password";
    });

    return res;
  }

  Future<String> changeEmail(String currentEmail, String password, String newEmail) async {
    String res = "Some error Occurred";
    User user = _auth.currentUser!;

    final cred = EmailAuthProvider.credential(email: currentEmail, password: password);

    await user.reauthenticateWithCredential(cred).then((value) async {
      await user.updateEmail(newEmail).then((_) {
        try {
          _firestore.collection('tourGuides').doc(FirebaseAuth.instance.currentUser!.uid).update({
            "email": newEmail,
          },);
          res = "success";
        } catch (err) {
          res = err.toString();
        }
        return res;
      }).catchError((error) {
        res = "Some error Occurred";
      });
    }).catchError((err) {
      res = "Wrong old email or password";
    });

    return res;
  }
}
