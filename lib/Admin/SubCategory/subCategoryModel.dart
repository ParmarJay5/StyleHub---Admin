// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class subCategoryModel{
//   final String id;
//   final String image;
//   final String subCategory;
//
//   subCategoryModel(
//       {
//         required this.id,
//         required this.image,
//         required this.subCategory
//       }
//       )
// factory subCategoryModel.fromSnapshot(DocumentSnapshot snapshot) {
//   return subCategoryModel
//     (
//       id: snapshot.id,
//       image: snapshot ['images'],
//       subCategory: snapshot['subCategory'],
//   );}
// }


import 'package:cloud_firestore/cloud_firestore.dart';

class subCategoryModel
{
  final String id;
  final String image;
  final String subCategory;
  final String category;

  subCategoryModel
  ({
  required this.id,
    required this.subCategory,
     required this.image,
    required this.category
  });

  factory subCategoryModel.fromSnapshot(DocumentSnapshot snapshot)
  {
    return subCategoryModel(
        id: snapshot.id,
        subCategory: snapshot['subCategory'],
        image: snapshot["image"],
        category: snapshot ['Category'],

    );

  }

}