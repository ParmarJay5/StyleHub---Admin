import 'dart:io';

import 'package:admin/Admin/Categories/categoryModel.dart';
import 'package:admin/Admin/SubCategory/subCategoryModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../image.dart';


class editSubCategoryScreen extends StatefulWidget {
  // String selectedCategory;
  final subCategoryModel subcategory;
  final image;

   editSubCategoryScreen({Key? key, required this.subcategory,required this.image})
   :super(key: key);

  @override
  State<editSubCategoryScreen> createState() => _editSubCategoryScreenState();
}

class _editSubCategoryScreenState extends State<editSubCategoryScreen> {
  File? selectedImage;
  TextEditingController subCategoryController = TextEditingController();
  bool isLoading = false;

  @override
  void initState(){
    super.initState();
    subCategoryController.text = widget.subcategory.subCategory;
  }

  Future<void> _updateSubCategory() async{
    setState(() {
      isLoading = true;
    });


    DocumentReference subCategoryRef = FirebaseFirestore.instance.collection("SubCategories").doc(widget.subcategory.id);

    Map<String, dynamic> updatedData = {
      'subCategory': subCategoryController.text,
    };
  if(selectedImage !=  null){
    String imageUrl = await uploadImageToStorage(selectedImage!);
    updatedData['image'] = imageUrl;
  }
  try{
    await subCategoryRef.update(updatedData);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("SubCategory Updated Successfully"),
    backgroundColor: Colors.green,));
  }
  catch(error){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to Update SubCategory"),
    backgroundColor: Colors.red,));
  }
  finally{
    setState(() {
      isLoading = false;
    });
  }
  }
  Future<String> uploadImageToStorage(File imageFile) async{
    Reference storageRef = FirebaseStorage.instance.ref().child('subCategory_Images/${widget.subcategory.id}');
    await storageRef.putFile(imageFile);
    return await storageRef.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit SubCategory",style: TextStyle(fontWeight: FontWeight.bold),),
      centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: subCategoryController,
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
              // CategoryDropdownn(
              //   selectedCategory: selectedCategory,
              //   onChanged: (value) {
              //     setState(() {
              //       selectedCategory = value;
              //     });
              //   },
              // ),

              Center(
                child: selectedImage != null
                ? Image.asset(img,width: 200,height: 200)
                : Image.network(widget.image,width: 200,height: 200,),
              ),

              SizedBox(width: double.infinity,

                child: ElevatedButton(
                    onPressed: isLoading
                      ? null
                      : () async
                    {
                      ImagePicker imagePicker = ImagePicker();
                      XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
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
                child: ElevatedButton(onPressed: () async {
                  await _updateSubCategory();
                },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                    child: isLoading
                      ? CircularProgressIndicator(color: Colors.white,)
                      : Text("Edit SubCategory",style: TextStyle(color: Colors.white),)),
              )



            ],
          ),
        ),
      ),
    );
  }
}

class CategoryDropdownn extends StatelessWidget{
  final String? selectedCategory;
  final ValueChanged<String?> onChanged;

  const CategoryDropdownn({required this.selectedCategory, required this.onChanged, Key? key}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: FirebaseFirestore.instance.collection("Categories").snapshots(), builder: (context, snapshot)
    {
      if(snapshot.hasData){
      return CircularProgressIndicator();
      }
      final categoryDocs = snapshot.data!.docs;
      List<categoryModel> categories = [];

      for(var  doc in categoryDocs){
        final category = categoryModel.fromSnapshot(doc);
        categories.add(category);
      }
      return DropdownButtonFormField<String>(
      value: selectedCategory,
      onChanged: onChanged,
      decoration: InputDecoration(
      hintText: "Select Category",
      border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(3)
    ),
      ),
    items: categories.map((categoryModel categories)
    {
      return DropdownMenuItem<String>(
      value: categories.category,
    child: Text(categories.category, style: TextStyle(color: Colors.black),
    ),
      );
    }).toList(),
    validator: (value){
        if(value == null || value.isEmpty)
          {
            return 'Please Select Category';
          }
        return null;
    },
      );
      }


    );
  }

}



class CategoryDropdown extends StatefulWidget {
  final String? selectedCategory;
  final ValueChanged<String?> onChanged; // Corrected typo

  const CategoryDropdown({
    required this.selectedCategory,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  State<CategoryDropdown> createState() => _CategoryDropdownState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('selectedCategory', selectedCategory));
  }
}


class _CategoryDropdownState extends State<CategoryDropdown> {
  @override
  Widget build(BuildContext context) => StreamBuilder(
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
          value: widget.selectedCategory,
          onChanged: widget.onChanged,
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


