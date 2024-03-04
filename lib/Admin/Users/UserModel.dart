// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class UserModel {
//   final String id;
//   final String username;
//   final String email;
//
//   UserModel({
//     required this.id,
//     required this.username,
//     required this.email,
//   });
//
//   factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
//     Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
//     return UserModel(
//       id: snapshot.id,
//       username: data['Username'] ?? '',
//       email: data['Email'] ?? '',
//     );
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
class SellerModel {
  final String uid;
  final String username;
  final String email;

  SellerModel({
    required this.uid,
    required this.username,
    required this.email,
  });

  factory SellerModel.fromMap(Map<String, dynamic> map) {
    return SellerModel(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
    );
  }
}
