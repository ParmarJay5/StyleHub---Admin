import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../image.dart';
import '../Categories/categoryModel.dart';


class addProductScreen extends StatefulWidget {
  const addProductScreen({super.key});

  @override
  State<addProductScreen> createState() => _addProductScreenState();
}

class _addProductScreenState extends State<addProductScreen> {
  TextEditingController subcategory_name = TextEditingController();

  String? selectedSubCategory;
  String? selectedCategory;

  String uniquefilename =DateTime.now().millisecondsSinceEpoch.toString();
  String imageUrl = "";
  List<File> selectedImage = [];
  bool isLoading = false;

  TextEditingController product_name = TextEditingController();
  TextEditingController product_price = TextEditingController();
  TextEditingController discount = TextEditingController();
  TextEditingController product_newprice = TextEditingController();
  TextEditingController product_color = TextEditingController();
  TextEditingController product_title1 = TextEditingController();
  TextEditingController product_detail1 = TextEditingController();
  TextEditingController product_title2 = TextEditingController();
  TextEditingController product_detail2 = TextEditingController();
  TextEditingController product_title3 = TextEditingController();
  TextEditingController product_detail3 = TextEditingController();
  TextEditingController product_title4 = TextEditingController();
  TextEditingController product_detail4 = TextEditingController();
  TextEditingController all_details = TextEditingController();
  TextEditingController product_Description = TextEditingController();


  Future<bool> doesProductExist(String productName) async{
    final querySnapshot = await FirebaseFirestore.instance.collection("products").where("product", isEqualTo: productName).get();
    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> addProductsToFireStore() async{
    final category = selectedCategory;
    final subcategory = selectedSubCategory;
    final productName = product_name.text.trim();
    final productPrice = product_price.text.trim();
    final productDiscount = discount.text.trim();
    final productNewPrice = product_newprice.text.trim();
    final color = product_color.text.trim();
    final productTitle1 = product_title1.text.trim();
    final productTitle2 = product_title2.text.trim();
    final productTitle3 = product_title3.text.trim();
    final productTitle4 = product_title4.text.trim();
    final productDetail1 = product_detail1.text.trim();
    final productDetail2 = product_detail2.text.trim();
    final productDetail3 = product_detail3.text.trim();
    final productDetail4 = product_detail4.text.trim();
    final allProduct = all_details.text.trim();
    final description = product_Description.text.trim();

    if(category == null || category.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Select Category")),
      );
      return;
    }
    if(subcategory == null || subcategory.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Select SubCategory")),
      );
      return;
    }
    if(productName.isEmpty ||
    productPrice.isEmpty ||
    productDiscount.isEmpty ||
    productNewPrice.isEmpty ||
    color.isEmpty ||
    productTitle1.isEmpty ||
    productTitle2.isEmpty ||
    productTitle3.isEmpty ||
    productTitle4.isEmpty ||
    productDetail1.isEmpty ||
    productDetail2.isEmpty ||
    productDetail3.isEmpty ||
    productDetail4.isEmpty ||
    allProduct.isEmpty ||
    description.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Enter Field")),);
      return;
    }
    final doesExsit = doesProductExist(productName);

    if(await doesExsit){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Enter Product Name")),);
    }
    else{
      setState(() {
        isLoading = true;
      });
      if(selectedImage.isNotEmpty){
        Reference referenceRoot = FirebaseStorage.instance.ref();
        Reference referenceDirImage = referenceRoot.child("product_Image");
        Reference referenceImageToUpload = referenceDirImage.child(uniquefilename);

        try{
          for( var image in selectedImage){
            await referenceImageToUpload.putFile(image);
          }
          final List<String> imageUrl = await Future.wait(selectedImage.map((image) async => await referenceImageToUpload.getDownloadURL(), ));
          print("Image URL: ");
          for(var url in imageUrl){
            print(url);
          }
          FirebaseFirestore.instance.collection("products").add({
            'category': category,
            'subCategory': subcategory,
            'productName': productName,
            'productPrice': productPrice,
            'productColor': color,
            'productDescription': description,
            'productTitle1': productTitle1,
            'productTitle2': productTitle2,
            'productTitle3': productTitle3,
            'productTitle4': productTitle4,
            'productDetail1': productDetail1,
            'productDetail2': productDetail2,
            'productDetail3': productDetail3,
            'productDetail4': productDetail4,
            'ProductDiscount': productDiscount,
            'productNewPrice': productNewPrice,
            'allProduct': allProduct,
            'image': imageUrl,
          }).then((value){
            selectedImage.clear();
            setState(() {
              isLoading = false;
            });

            product_name.clear();
            product_price.clear();
            discount.clear();
            product_newprice.clear();
            product_color.clear();
            product_title1.clear();
            product_title2.clear();
            product_title3.clear();
            product_title4.clear();
            product_detail1.clear();
            product_detail2.clear();
            product_detail3.clear();
            product_detail4.clear();
            all_details.clear();
            product_Description.clear();
            selectedCategory = null;
            selectedSubCategory = null;

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product Added Successfully")),);
          });
        }
        catch(error){
          print("Error Uploading Image $error");
        };
      }
      else
        {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please Select Images")),);
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
        title: Text("Add Products",style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 30),
          child: Column(
            children: [

              SizedBox(
                height: 180,
                width: 300,
                child: selectedImage.isNotEmpty
                    ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: selectedImage.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.file(
                        selectedImage[index],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                )
                    : Image.asset(img,
                  width: 300,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
          // Image.asset(img,height: 200,width: 200,),

              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    ImagePicker imagePicker = ImagePicker();
                    List<XFile>? files = await imagePicker.pickMultiImage();
                    if (files == null) return;

                    selectedImage = files.map((file) => File(file.path)).toList();
                    setState(() {});
                  },style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                    child: Text("Select Image",style: TextStyle(color: Colors.white),)),
                ),

            SizedBox(height: 20,),
//
//               CategoryDropdownn(
//                 selectedCategory: selectedCategory,
//                 onChanged: (value) {
//                   setState(() {
//                     selectedCategory = value;
//                   });
//                 },
//               ),
//
// SizedBox(height: 20,),
//
//               SubCategoryDropdownn(
//                 selectedCategory: selectedCategory,
//                 selectedSubCategory: selectedSubCategory,
//                 onChanged: (value) {
//                   setState(() {
//                     selectedSubCategory = value;
//                   });
//                 },
//               ),

              CategoryDropdown(
                selectedCategory: selectedCategory,
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                    selectedSubCategory = null; // Reset subcategory when category changes
                  });
                },
              ),
              SizedBox(height: 20),
              SubCategoryDropdown(
                selectedCategory: selectedCategory,
                selectedSubCategory: selectedSubCategory,
                onChanged: (value) {
                  setState(() {
                    selectedSubCategory = value;
                  });
                },
              ),
              SizedBox(height: 20),

            TextFormField(
              controller: product_name,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green)
              ),
              hintText: "Product Name",


            ),
          ),
          SizedBox(height: 20,),
              TextFormField(
                controller: product_price,
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)
                  ),
                  hintText: "Product Price",


                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: discount,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)
                  ),
                  hintText: "Discount",


                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: product_newprice,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)
                  ),
                  hintText: "Product New Price",


                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: product_color,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)
                  ),
                  hintText: "Product Color",


                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: product_title1,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)
                  ),
                  hintText: "Product Title 1",


                ),
              ),
              SizedBox(height: 20,),
              TextFormField(controller: product_detail1,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)
                  ),
                  hintText: "Product Detail",


                ),
              ),
              SizedBox(height: 20,),TextFormField(
                controller: product_title2,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)
                  ),
                  hintText: "Product Title 2",


                ),
              ),
              SizedBox(height: 20,),TextFormField(
                controller: product_detail2,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)
                  ),
                  hintText: "Product Detail",


                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: product_title3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)
                  ),
                  hintText: "Product Title 3",


                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: product_detail3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)
                  ),
                  hintText: "Product Detail",


                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: product_title4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)
                  ),
                  hintText: "Product Title 4",


                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: product_detail4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)
                  ),
                  hintText: "Product Detail",


                ),
              ),

              SizedBox(height: 20,),

              TextFormField(
                controller: product_Description,
                // controller: productDescriptionController,
                maxLines: 3, // Adjust the number of lines according to your design
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                  hintText: "Product Description",
                ),
              ),


              SizedBox(height: 20,),
              TextFormField(
                controller: all_details,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)
                  ),
                  hintText: "All Detail",


                ),
              ),

          SizedBox(height: 20,),

          Container(width: double.infinity,
            child: ElevatedButton(onPressed: (){
              addProductsToFireStore();
            },style: ElevatedButton.styleFrom(backgroundColor: Colors.green,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
                child:  isLoading
                    ? CircularProgressIndicator()
                    :Text("Add Product",style: TextStyle(color: Colors.white),

                )),
          )],
          ),
        ),
      ),
    );
  }
}


//
// class CategoryDropdown extends StatelessWidget {
// final String? selectedCategory;
// final ValueChanged<String?> onChanged;
//
// const CategoryDropdown({
// required this.selectedCategory,
// required this.onChanged,
// Key? key,
// }) : super(key: key);
//
// @override
// Widget build(BuildContext context) {
// return StreamBuilder(
//   stream: FirebaseFirestore.instance.collection("Categories").snapshots(),
//   builder: (context, snapshot) {
//     if (!snapshot.hasData) {
//       return CircularProgressIndicator();
//     }
//     final categoryDocs = snapshot.data!.docs;
//     List<String> categories = [];
//
//     for (var doc in categoryDocs) {
//       final category = productModel.fromSnapshot(doc);
//       categories.add(category as String);
//     }
// return DropdownButtonFormField<String>(
// value: selectedCategory,
// onChanged: onChanged,
// decoration: InputDecoration(
// hintText: "Select Category",
// border: OutlineInputBorder(
// borderRadius: BorderRadius.circular(3),
// ),
// ),
// items: categories.map((ca) {
// return DropdownMenuItem<String>(
// value: category,
// child: Text(
// category,
// style: TextStyle(color: Colors.black),
// ),
// );
// }).toList(),
// validator: (value) {
// if (value == null || value.isEmpty) {
// return 'Please Select Category';
// }
// return null;
// },
// );
// },
// );
// }
// }
//
//
//
//
//
//
// //
// //
// // class CategoryDropdownn extends StatelessWidget {
// //   final String? selectedCategory;
// //   final ValueChanged<String?> onChanged; // Corrected typo
// //
// //   const CategoryDropdownn({
// //     required this.selectedCategory,
// //     required this.onChanged,
// //     Key? key,
// //   }) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return StreamBuilder(
// //       stream: FirebaseFirestore.instance.collection("Categories").snapshots(),
// //       builder: (context, snapshot) {
// //         if (!snapshot.hasData) {
// //           return CircularProgressIndicator();
// //         }
// //         final categoryDocs = snapshot.data!.docs;
// //         List<productModel> categories = [];
// //
// //         for (var doc in categoryDocs) {
// //           final category = productModel.fromSnapshot(doc);
// //           categories.add(category);
// //         }
// //         return DropdownButtonFormField<String>(
// //           value: selectedCategory,
// //           onChanged: onChanged,
// //           decoration: InputDecoration(
// //             hintText: "Select Category",
// //             border: OutlineInputBorder(
// //               borderRadius: BorderRadius.circular(3),
// //             ),
// //           ),
// //           items: categories.map((productModel categories) {
// //             return DropdownMenuItem<String>(
// //               value: categories.category,
// //               child: Text(
// //                 categories.category,
// //                 style: TextStyle(color: Colors.black),
// //               ),
// //             );
// //           }).toList(),
// //           validator: (value) {
// //             if (value == null || value.isEmpty) {
// //               return 'Please Select Category';
// //             }
// //             return null;
// //           },
// //         );
// //       },
// //     );
// //   }
// // }
//
//
// class SubCategoryDropdownn extends StatelessWidget {
//   final String? selectedSubCategory;
//   final String? selectedCategory;
//   final ValueChanged<String?> onChanged; // Corrected typo
//
//   const SubCategoryDropdownn({
//     required this.selectedSubCategory,
//     required this.selectedCategory,
//     required this.onChanged,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: FirebaseFirestore.instance.collection("SubCategories").snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return CircularProgressIndicator();
//         }
//         final subCategoryDocs = snapshot.data!.docs;
//         List<subCategoryModel> subCategories = [];
//
//         for (var doc in subCategoryDocs) {
//           final subCategory = subCategoryModel.fromSnapshot(doc);
//           subCategories.add(subCategory);
//         }
//         return DropdownButtonFormField<String>(
//           value: selectedSubCategory,
//           onChanged: onChanged,
//           decoration: InputDecoration(
//             hintText: "Select SubCategory",
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(3),
//             ),
//           ),
//           items: subCategories.map((subCategoryModel SubCategories) {
//             return DropdownMenuItem<String>(
//               value: SubCategories.subCategory,
//               child: Text(
//                 SubCategories.subCategory,
//                 style: TextStyle(color: Colors.black),
//               ),
//             );
//           }).toList(),
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Please Select SubCategory';
//             }
//             return null;
//           },
//         );
//       },
//     );
//   }
// }

class CategoryDropdown extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String?> onChanged;

  const CategoryDropdown({
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


class SubCategoryDropdown extends StatelessWidget {
  final String? selectedCategory;
  final String? selectedSubCategory;
  final ValueChanged<String?> onChanged;

  const SubCategoryDropdown({
    required this.selectedCategory,
    required this.selectedSubCategory,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check if a category is selected
    if (selectedCategory == null || selectedCategory!.isEmpty) {
      // If no category is selected, disable the subcategory dropdown
      return DropdownButtonFormField<String>(
        value: null,
        onChanged: null,
        decoration: InputDecoration(
          hintText: "Select Category First",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        items: [], // No items to display
      );
    }

    // If a category is selected, fetch subcategories and display the dropdown
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("SubCategories")
          .where("category", isEqualTo: selectedCategory)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return CircularProgressIndicator(); // Show loading indicator if data is not available yet
        }

        final subcategoryDocs = snapshot.data!.docs;
        List<String> subcategories = [];

        for (var doc in subcategoryDocs) {
          final subcategory = doc['subCategory'] as String;
          subcategories.add(subcategory);
        }
        return DropdownButtonFormField<String>(
          value: selectedSubCategory,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: "Select SubCategory",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          items: subcategories.map((subcategory) {
            return DropdownMenuItem<String>(
              value: subcategory,
              child: Text(
                subcategory,
                style: TextStyle(color: Colors.black),
              ),
            );
          }).toList(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please Select SubCategory';
            }
            return null;
          },
        );
      },
    );
  }
}




//
// class SubCategoryDropdown extends StatelessWidget {
//   final String? selectedCategory;
//   final String? selectedSubCategory;
//   final ValueChanged<String?> onChanged;
//
//   const SubCategoryDropdown({
//     required this.selectedCategory,
//     required this.selectedSubCategory,
//     required this.onChanged,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: FirebaseFirestore.instance
//           .collection("SubCategories")
//           .where("category", isEqualTo: selectedCategory)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData || selectedCategory == null) {
//         }
//         final subcategoryDocs = snapshot.data!.docs;
//         List<String> subcategories = [];
//
//         for (var doc in subcategoryDocs) {
//           final subcategory = doc['subCategory'] as String;
//           subcategories.add(subcategory);
//         }
//         return DropdownButtonFormField<String>(
//           value: selectedSubCategory,
//           onChanged: onChanged,
//           decoration: InputDecoration(
//             hintText: "Select SubCategory",
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(3),
//             ),
//           ),
//           items: subcategories.map((subcategory) {
//             return DropdownMenuItem<String>(
//               value: subcategory,
//               child: Text(
//                 subcategory,
//                 style: TextStyle(color: Colors.black),
//               ),
//             );
//           }).toList(),
//           validator: (value) {
//             if (value == null || value.isEmpty) {
//               return 'Please Select SubCategory';
//             }
//             return null;
//           },
//         );
//       },
//     );
//   }
// }
