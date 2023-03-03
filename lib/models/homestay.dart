import 'package:cloud_firestore/cloud_firestore.dart';

class Homestay {
  final String homestayId;
  final String ownerId;
  final String title;
  final String description;
  final String photoUrl;
  final double pricePerDay;
  final double latitude;
  final double longitude;
  final DateTime modifiedDate;

  const Homestay(
      {required this.homestayId,
        required this.ownerId,
        required this.title,
        required this.description,
        required this.photoUrl,
        required this.pricePerDay,
        required this.latitude,
        required this.longitude,
        required this.modifiedDate,
      });

  static Homestay fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Homestay(
      homestayId: snapshot["homestayId"],
      ownerId: snapshot["ownerId"],
      title: snapshot["title"],
      description: snapshot["description"],
      photoUrl: snapshot["photoUrl"],
      pricePerDay: snapshot["pricePerDay"],
      latitude: snapshot["latitude"],
      longitude: snapshot["longitude"],
      modifiedDate: snapshot["modifiedDate"],
    );
  }

  Map<String, dynamic> toJson() => {
    "homestayId": homestayId,
    "ownerId": ownerId,
    "title": title,
    "description": description,
    "photoUrl": photoUrl,
    "pricePerDay": pricePerDay,
    "latitude": latitude,
    "longitude": longitude,
    "modifiedDate": modifiedDate,
  };
}