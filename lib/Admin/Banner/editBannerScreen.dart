import 'dart:io';

import 'package:admin/Admin/Banner/bannerModel.dart';
import 'package:admin/image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class editBannerScreen extends StatefulWidget {
  final bannerModel banner;
  final image;

  const editBannerScreen({Key? key, required this.banner, required this.image})
      : super(key: key);

  @override
  State<editBannerScreen> createState() => _editBannerScreenState();
}

class _editBannerScreenState extends State<editBannerScreen> {
  File? selectedImage;
  TextEditingController bannerController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    bannerController.text = widget.banner.banner;
  }

  Future<void> updateBanner() async {
    setState(() {
      isLoading = true;
    });

    DocumentReference bannerRef =
    FirebaseFirestore.instance.collection("Banners").doc(widget.banner.id);

    Map<String, dynamic> updateData = {
      'Banner': bannerController.text,
    };

    if (selectedImage != null)
    {
      String imageUrl = await uploadImageToStorage(selectedImage!);
      updateData['image'] = imageUrl;
    }

    try {
      await bannerRef.update(updateData);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Banner Updated Successfully'),
        backgroundColor: Colors.green,
      ));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to Update Banner'),
        backgroundColor: Colors.green,
      ));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<String> uploadImageToStorage(File imageFile) async {
    Reference storageRef =
    FirebaseStorage.instance.ref().child('banner_Image/${widget.banner.id}');
    await storageRef.putFile(imageFile);
    return await storageRef.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Banner",
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
              TextFormField(
                controller: bannerController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green)),
                  hintText: "Banner Name",
                ),
              ),
              SizedBox(
                height: 20,
                width: double.infinity,
              ),
              Center(
                child:
                Image.network(
                  widget.image,
                  width: 200,
                  height: 200,
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                    ImagePicker imagePicker = ImagePicker();
                    XFile? file =
                    await imagePicker.pickImage(source: ImageSource.gallery);
                    if (file != null) {
                      selectedImage = File(file.path);
                      setState(() {});
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4))),
                  child: Text(
                    "Edit Image",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await updateBanner();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4))),
                  child: isLoading
                  ? CircularProgressIndicator(color: Colors.white,)
                  :Text(
                    "Edit Banner",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
