import 'package:cloud_firestore/cloud_firestore.dart';

class categoryModel{
final String id;
final String image;
final String category;

categoryModel(
{
  required this.id,
  required this.image,
  required this.category
}
);


factory categoryModel.fromSnapshot(DocumentSnapshot snapshot){
  return categoryModel(id: snapshot.id, image: snapshot['image'], category: snapshot['Category']);
}
}