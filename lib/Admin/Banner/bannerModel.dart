import 'package:cloud_firestore/cloud_firestore.dart';

class bannerModel{
  final String id;
  final String image;
  final String banner;

  bannerModel({
    required this.id,
    required this.image,
    required this.banner});


  factory bannerModel.fromSnapshot(DocumentSnapshot snapshot){
    return bannerModel(id: snapshot.id, image: snapshot['image'], banner: snapshot['Banner']);
}

}