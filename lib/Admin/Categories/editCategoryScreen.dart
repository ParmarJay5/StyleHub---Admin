import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:admin/Admin/Categories/categoryModel.dart';

import '../../image.dart';

class editCategoryScreen extends StatefulWidget {
  final categoryModel category;
  final image;

  editCategoryScreen({Key? key, required this.category, required this.image})
  :super(key: key);

  @override
  State<editCategoryScreen> createState() => _editCategoryScreenState();
}

class _editCategoryScreenState extends State<editCategoryScreen> {
  File? selectedImage;
  TextEditingController categoryController= TextEditingController();
  bool isLoading = false;

  @override
  void initState(){
    super.initState();
    categoryController.text = widget.category.category;
  }

  Future<void> updateCategory() async {
    setState(() {
      isLoading = true;
    });

    DocumentReference categoryRef = FirebaseFirestore.instance.collection("Categories").doc(widget.category.id);

    Map<String, dynamic> updateData = {
      'Category' :categoryController.text,
    };

    if(selectedImage != null){
      String imageUrl = await uploadImageToStorage(selectedImage!);
      updateData['image'] = imageUrl;
    }

    try{
      await categoryRef.update(updateData);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Category Updated Successfully"),
      backgroundColor: Colors.green,));
    }
    catch(error){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to Update Category"),
      backgroundColor: Colors.red,));
    }
    finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<String> uploadImageToStorage(File imageFile) async {
    Reference storageRef = FirebaseStorage.instance.ref().child('category_Images/${widget.category.id}');
    await storageRef.putFile(imageFile);
    return await storageRef.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Category",style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding( padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: categoryController,
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

              SizedBox(width: double.infinity,
              ),
              Center(
                child: selectedImage != null
                ? Image.asset(img,width: 200,height: 200)
                : Image.network(widget.image,
                width: 200,
                height: 200,),
              ),
              SizedBox(width: double.infinity,

                child: ElevatedButton(
                    onPressed: isLoading
                    ? null
                    : () async
                    {
                      ImagePicker imagePicker  =  ImagePicker();
                      XFile? file= await imagePicker.pickImage(source: ImageSource.gallery);
                      if(file != null){
                        selectedImage = File(file.path);
                        setState(() {
                        });
                      }

                    },style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                    child: Text("Edit Image",style: TextStyle(color: Colors.white),)),
              ),

              SizedBox(height: 20,),

              SizedBox(width: double.infinity,
                child: ElevatedButton(onPressed: () async
                {
                  await updateCategory();
                },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                    child: isLoading
                  ? CircularProgressIndicator(color: Colors.white,)
                  : Text("Edit Category",style: TextStyle(color: Colors.white),)),
              )

            ],
          ),

        ),
      ),


    );
  }
}
