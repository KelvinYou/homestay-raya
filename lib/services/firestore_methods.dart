import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:homestay_raya/models/homestay.dart';
import 'package:homestay_raya/services/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> addHomestay(String uid, String title, String description,
      Uint8List? image, double pricePerDay, double latitude,
      double longitude) async {
    String res = "Some error occurred";
    String homestayId = const Uuid().v1();

    try {
      if (image != null) {
        String photoUrl = await StorageMethods().uploadImageToStorageList(
            'HomeStayPics', homestayId, image, false);
        // String photoUrl = await
        Homestay homestay = Homestay(
          homestayId: homestayId,
          ownerId: uid,
          title: title,
          description: description,
          photoUrl: photoUrl,
          pricePerDay: pricePerDay,
          latitude: latitude,
          longitude: longitude,
          modifiedDate: DateTime.now(),
        );
        _firestore.collection('homestays').doc(homestayId).set(homestay.toJson());
        res = "success";
      } else {
        res = "Please select an image";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> deleteHomeStay(String homestayId) async {
    String res = "Some error occurred";
    try {
      _firestore.collection('homestays').doc(homestayId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> updateHomestay(String homestayId, String title, String description,
      Uint8List? image, double pricePerDay, double latitude,
      double longitude) async {
    String res = "Some error occurred";

    try {
      if (image != null) {
        String photoUrl = await StorageMethods().uploadImageToStorageList(
            'HomeStayPics', homestayId, image, false);
        _firestore.collection('homestays').doc(homestayId).update(
          {
            "title": title,
            "description": description,
            "photoUrl": photoUrl,
            "pricePerDay": pricePerDay,
            "latitude": latitude,
            "longitude": longitude,
            "modifiedDate": DateTime.now(),
          }
        );
        res = "success";
      } else {
        _firestore.collection('homestays').doc(homestayId).update(
            {
              "title": title,
              "description": description,
              "pricePerDay": pricePerDay,
              "latitude": latitude,
              "longitude": longitude,
              "modifiedDate": DateTime.now(),
            }
        );
        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> changeProfile(String uid, Uint8List? file) async {
    String res = "Some error occurred";

    try {
      if (file != null) {
        String photoUrl = await StorageMethods().uploadImageToStorage('UserPics', file, false);
        _firestore.collection('users').doc(uid).update(
          {"photoUrl": photoUrl},
        );
        res = "success";
      } else {
        res = "Please select an image";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> updatePersonalDetail(String uid, String username, String phoneNumber) async {
    String res = "Some error occurred";

    try {
      _firestore.collection('users').doc(uid).update({
        "username": username,
        "phoneNumber": phoneNumber,
      },);
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> updateUsername(String uid, String username) async {
    String res = "Some error occurred";

    try {
      _firestore.collection('users').doc(uid).update({
        "username": username,
      },);
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
