import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../image.dart';
import 'package:admin/Admin/Products/productModel.dart';

class EditProductScreen extends StatefulWidget {
  final productModel product;
  final String imageUrls;
  // final Function() onProductUpdated;


  EditProductScreen({Key? key, required this.product, required this.imageUrls,
    // required this.onProductUpdated
  })
      : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  List<File>? selectedImages;
  TextEditingController productNameController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController newPriceController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController title1Controller = TextEditingController();
  TextEditingController detail1Controller = TextEditingController();
  TextEditingController title2Controller = TextEditingController();
  TextEditingController detail2Controller = TextEditingController();
  TextEditingController title3Controller = TextEditingController();
  TextEditingController detail3Controller = TextEditingController();
  TextEditingController title4Controller = TextEditingController();
  TextEditingController detail4Controller = TextEditingController();
  TextEditingController allDetailsController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    productNameController.text = widget.product.productName;
    productPriceController.text = widget.product.productPrice;
    discountController.text = widget.product.discount;
    newPriceController.text = widget.product.productNewPrice;
    colorController.text = widget.product.productColor;
    title1Controller.text = widget.product.productTitle1;
    title2Controller.text = widget.product.productTitle2;
    title3Controller.text = widget.product.productTitle3;
    title4Controller.text = widget.product.productTitle4;
    detail1Controller.text = widget.product.productTitleDetail1;
    detail2Controller.text = widget.product.productTitleDetail2;
    detail3Controller.text = widget.product.productTitleDetail3;
    detail4Controller.text = widget.product.productTitleDetail4;
    allDetailsController.text = widget.product.allDetails;
    descriptionController.text = widget.product.productDescription;

  }

  Future<void> _updateProduct() async {
    setState(() {
      isLoading = true;
    });

    DocumentReference productRef =
    FirebaseFirestore.instance.collection("products").doc(widget.product.id);

    List<String> imageUrls = [];

    if(selectedImages != null){
      for(File imageFile in selectedImages!){
        String imageUrl = await uploadImageToStorage(imageFile);
        imageUrls.add(imageUrl);
      }
    }

    Map<String, dynamic> updatedData = {
      'productName': productNameController.text,
      'productPrice': productPriceController.text,
      'productColor': colorController.text,
      'productDescription': descriptionController.text,
      'productTitle1': title1Controller.text,
      'productTitle2': title2Controller.text,
      'productTitle3': title3Controller.text,
      'productTitle4': title4Controller.text,
      'productDetail1': detail1Controller.text,
      'productDetail2': detail2Controller.text,
      'productDetail3': detail3Controller.text,
      'productDetail4': detail4Controller.text,
      'ProductDiscount': discountController.text,
      'productNewPrice': newPriceController.text,
      'allDetails': allDetailsController.text,
      'image': imageUrls,
    };

    try {
      await productRef.update(updatedData);
      // widget.onProductUpdated();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Product Updated Successfully"),
        backgroundColor: Colors.green,
      ));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to Update Product"),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<String> uploadImageToStorage(File imageFile) async {
    Reference storageRef =
    FirebaseStorage.instance.ref().child('product_Image/${widget.product.id}');
    await storageRef.putFile(imageFile);
    return await storageRef.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Product",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),

              if(selectedImages != null)
                Center(child: Image.file(selectedImages![0],width: 200,height: 200,))
              else
                Center(child: Image.network(widget.imageUrls,height: 200,width: 200,)),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    ImagePicker imagePicker = ImagePicker();
                    List<XFile>? files = await imagePicker.pickMultiImage();
                    selectedImages =
                          files.map((file) => File(file.path)).toList();
                      setState(() {});

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Text(
                    "Edit Image",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              SizedBox(height: 20,),
              TextFormField(
                controller: productNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.black)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green)
                  ),
                  hintText: "Product Name"
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: productPriceController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.black)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)
                    ),
                    hintText: "Product Price"
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: discountController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.black)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)
                    ),
                    hintText: "Discount"
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: newPriceController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.black)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)
                    ),
                    hintText: "New Price"
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: colorController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.black)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)
                    ),
                    hintText: "Color"
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: title1Controller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.black)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)
                    ),
                    hintText: "Title 1"
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: detail1Controller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.black)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)
                    ),
                    hintText: "Detail 1"
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: title2Controller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.black)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)
                    ),
                    hintText: "Title 2"
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: detail2Controller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.black)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)
                    ),
                    hintText: "Detail 2"
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: title3Controller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.black)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)
                    ),
                    hintText: "Title 3"
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: detail3Controller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.black)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)
                    ),
                    hintText: "Detail 3"
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: title4Controller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.black)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)
                    ),
                    hintText: "Title 4"
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: detail4Controller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.black)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)
                    ),
                    hintText: "Detail 4"
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: allDetailsController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.black)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)
                    ),
                    hintText: "All Details"
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: Colors.black)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green)
                    ),
                    hintText: "Description"
                ),
              ),

              SizedBox(height: 20),

              // Button to update product
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await _updateProduct();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: isLoading
                  ? CircularProgressIndicator(color: Colors.white,)
                  : Text(
                    "Edit Product",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
