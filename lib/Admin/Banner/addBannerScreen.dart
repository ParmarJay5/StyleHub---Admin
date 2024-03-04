import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../image.dart';

class addBannerScreen extends StatefulWidget {
  const addBannerScreen({super.key});

  @override
  State<addBannerScreen> createState() => _addBannerScreenState();
}

class _addBannerScreenState extends State<addBannerScreen> {

  TextEditingController banner_name = TextEditingController();
  String uniquefilename = DateTime.now().millisecondsSinceEpoch.toString();
  String imageUrl = "";
  File? selectedImage;
  bool isLoading = false;

  Future<bool> doesBannerExist(String bannerName) async
  {
    final querySnapshot = await FirebaseFirestore.instance
        .collection("Banners")
        .where("Banner", isEqualTo: bannerName)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }
  Future<void> addBannerToFirestore() async{
    final banner = banner_name.text.trim();

    if(banner.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter Banner Name")));
      return;
    }
    final doesExist = await doesBannerExist(banner);

    if(doesExist){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Banner already Exist")));
    }
    else{
      setState(() {
        isLoading = true;
      });

      if(selectedImage!= null){
        Reference referenceRoot= FirebaseStorage.instance.ref();
        Reference referenceDirImage = referenceRoot.child("banner_Image");
        Reference referenceImageUpload = referenceDirImage.child(uniquefilename);
        
        try{
          await referenceImageUpload.putFile(selectedImage!);
          imageUrl = await referenceImageUpload.getDownloadURL();
          print("Image Url $imageUrl");
          
          FirebaseFirestore.instance.collection("Banners").add({
            'Banner': banner_name.text,
            'image': imageUrl,
          }).then((value) => banner_name.clear());
          selectedImage = null;
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Banner Added Successfully")));
        }
        catch(error){
          print("Error uploading Image $error");
        }
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select an Image")));
        setState(() {
          isLoading = false;
        });
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Banner",style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
        child: Column(
          children: [

            TextFormField(
              controller: banner_name,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green)
                ),
                hintText: "Banner Name",


              ),
            ),
            SizedBox(height: 20,),
            selectedImage != null
                ?Center(child: Image.file(selectedImage!,width: 150,height: 150,))
                :Center(child: Image.asset(img,width: 200,height: 200)),
            // Center(child: Image.asset(img,width: 200,height: 200)),

            SizedBox(height: 20,),
            Container(width: double.infinity,
              child: ElevatedButton(onPressed: () async {
                ImagePicker imagePicker = ImagePicker();
                XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

                if(file == null)
                  return;

                selectedImage = File(file.path);
                setState(() {});

              },style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                  child: Text("Select Image",style: TextStyle(color: Colors.white),)),
            ),

            SizedBox(height: 20,),

            Container(width: double.infinity,
              child: ElevatedButton(onPressed: () async
              {
                addBannerToFirestore();
              },style: ElevatedButton.styleFrom(backgroundColor: Colors.green,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white,)
                      : const  Text("Add Banner",style: TextStyle(color: Colors.white),

                  )),
            )

          ],
        ),
      ),
    ),

    );
  }
}
