import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../image.dart';
import '../Categories/categoryModel.dart';

class addSubCaregory extends StatefulWidget {
  const addSubCaregory({Key? key}) : super(key: key);

  @override
  State<addSubCaregory> createState() => _addSubCaregoryState();
}

class _addSubCaregoryState extends State<addSubCaregory> {

  TextEditingController category_name = TextEditingController();
  TextEditingController subcategory_name =TextEditingController();
  String? selectedCategory;

  String uniquefilename =DateTime.now().millisecondsSinceEpoch.toString();
  String imageUrl = "";
  File? selectedImage;
  bool isLoading = false;

  Future<bool> doesSubCategoryExist(String subCategoryName) async
  {
    final querySnapshot = await FirebaseFirestore.instance.collection("SubCategories").where("SubCategory", isEqualTo: subCategoryName).get();
    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> addSubCategoryToFirestore() async{
    final category =selectedCategory;
    final subcategory = subcategory_name.text.trim();

    if(subcategory.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter your SubCategory Name")));
      return;
    }
    final doesExist = doesSubCategoryExist(subcategory);

    if(await doesExist){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("SubCategory already Exist")));
    }
    else {
      setState(() {
        isLoading = true;
      });

      if(selectedImage != null){
        Reference referenceRoot = FirebaseStorage.instance.ref();
        Reference referenceDirImage = referenceRoot.child("subCategory_Image");
        Reference referenceImageToUpload = referenceDirImage.child(uniquefilename);

        try{
          await referenceImageToUpload.putFile(selectedImage!);
          imageUrl = await referenceImageToUpload.getDownloadURL();
          print("Image URL : $imageUrl");

          FirebaseFirestore.instance.collection("SubCategories").add({
            'Category': category,
            "subCategory" : subcategory_name.text,
            "image" :imageUrl,
          }).then((value) => subcategory_name.clear());
          selectedImage = null;
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("SubCategory Added Successfully")),
          );
        }
        catch(error){
          print("Error Uploading Image : $error");
        }
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Select an Image")),);
        setState(() {
          isLoading = false;
        });
      }

    }}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add SubCategory",style: TextStyle(fontWeight: FontWeight.bold),),
      centerTitle: true,),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [



              CategoryDropdownn(
                selectedCategory: selectedCategory,
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
              ),

              SizedBox(height: 20,) ,
              TextFormField(
                controller: subcategory_name,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)
                  ),
                  hintText: "SubCategory Name",


                ),
              ),

              SizedBox(height: 20,),

              selectedImage != null
                  ?Center(child: Image.file(selectedImage!, width: 200,height: 200,))
                  :Center(child: Image.asset(img,width: 200,height: 200)),

              SizedBox(height: 20,),
              Container(width: double.infinity,
                child: ElevatedButton(onPressed: () async {
                  ImagePicker imagePicker = ImagePicker();
                  XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

                  if(file == null)
                    return;

                  selectedImage = File(file.path);
                  setState(() { });

                },style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                    child: Text("Select Image",style: TextStyle(color: Colors.white),)),
              ),

              SizedBox(height: 20,),

              Container(width: double.infinity,
                child: ElevatedButton(onPressed: (){
                  addSubCategoryToFirestore();
                },style: ElevatedButton.styleFrom(backgroundColor: Colors.green,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                    child: isLoading
                      ? CircularProgressIndicator(color: Colors.white,)
                      :Text("Add SubCategory",style: TextStyle(color: Colors.white),

                    )),
              )



            ],
          ),
        ),
      ),
    );
  }
}


class CategoryDropdownn extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String?> onChanged; // Corrected typo

  const CategoryDropdownn({
    required this.selectedCategory,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("Categories").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        final categoryDocs = snapshot.data!.docs;
        List<categoryModel> categories = [];

        for (var doc in categoryDocs) {
          final category = categoryModel.fromSnapshot(doc);
          categories.add(category);
        }
        return DropdownButtonFormField<String>(
          value: selectedCategory,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: "Select Category",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          items: categories.map((categoryModel categories) {
            return DropdownMenuItem<String>(
              value: categories.category,
              child: Text(
                categories.category,
                style: TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please Select Category';
            }
            return null;
          },
        );
      },
    );
  }
}

