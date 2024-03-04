import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:admin/image.dart';


class addCategoryScreen extends StatefulWidget {
  const addCategoryScreen({super.key});

  @override
  State<addCategoryScreen> createState() => _addCategoryScreenState();
}

class _addCategoryScreenState extends State<addCategoryScreen> {

  TextEditingController category_name = TextEditingController();
  String uniquefilename =DateTime.now().millisecondsSinceEpoch.toString();
  String imageUrl ="";
  File? selectedImage;
  bool isLoading = false;

  Future<bool> doesCategoryExist(String categoryName) async
  {
    final querySnapshot = await FirebaseFirestore.instance
        .collection("Categories")
        .where("Category", isEqualTo: categoryName)
        .get();

    return querySnapshot.docs.isNotEmpty;

  }
Future<void> addCategoryToFirestore()  async {
  final category = category_name.text.trim();

  if (category.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter your category name")));
    return;
  }
  final doesExist = await doesCategoryExist(category);

  if(doesExist){
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Category already Esist ")));
  }
  else{
    setState(() {
      isLoading = true;
    });

    if(selectedImage != null){
      Reference referenceRoot =FirebaseStorage.instance.ref();
      Reference referenceDirImage = referenceRoot.child("category_Images");
      Reference referenceImageUpload = referenceDirImage.child(uniquefilename);

      try{
        await referenceImageUpload.putFile(selectedImage!);
        imageUrl = await referenceImageUpload.getDownloadURL();
        print("Image URL $imageUrl");

        FirebaseFirestore.instance.collection("Categories").add({
         'Category' : category_name.text,
          'image': imageUrl,
        }).then((value) => category_name.clear());
        selectedImage = null;
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Category added successfully")));
      }
      catch(error){
        print("Error uploading Image $error");
      }
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pleace select an Image")));
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
        title: Text("Add Category",style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding( padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: category_name,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)
                    ),
                    hintText: "Category Name",
                  

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
                  addCategoryToFirestore();
                },style: ElevatedButton.styleFrom(backgroundColor: Colors.green,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                    child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white,)
                  : const  Text("Add Category",style: TextStyle(color: Colors.white),

                )),
              )

            ],
          ),

        ),
      ),
    );
  }
}
