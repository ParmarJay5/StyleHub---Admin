import 'package:admin/Admin/SubCategory/editSubCategoryScreen.dart';
import 'package:admin/Admin/SubCategory/subCategoryModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:admin/Admin/SubCategory/addSubCategoryScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class subcategoryScreen extends StatefulWidget {
  const subcategoryScreen({super.key});

  @override
  State<subcategoryScreen> createState() => _subcategoryScreenState();
}

class _subcategoryScreenState extends State<subcategoryScreen> {
  late TextEditingController searchController;
  late String searchQuery;

  @override
  void initState(){
    super.initState();
    searchController = TextEditingController();
    searchQuery = "";
  }

  void deleteSubCategory(String subCategoryID){
    FirebaseFirestore.instance.collection("SubCategories").doc(subCategoryID).delete().then((value) {
      Fluttertoast.showToast(msg: "SubCategory Deleted Successfully",toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM,backgroundColor: Colors.green,textColor: Colors.white);
    }).catchError((error){
      Fluttertoast.showToast(msg: "Failed to Deleted SubCategory",toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM,backgroundColor: Colors.green,textColor: Colors.white);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SubCategory",style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => addSubCaregory()));
              },style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))) ,
                  child: Text("Add SubCategory",style: TextStyle(color: Colors.white),)),

              SizedBox(height: 10,),

              Container(height: 45,
                width: double.infinity,
                child: TextFormField(
                  controller: searchController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)
                      ),
                      hintText: "Search SubCategory...",
                      prefixIcon: Icon(Icons.search)

                  ),
                ),
              ),
              SizedBox(height: 5,),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Sr.No",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                  Text("SubCategory Name",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                  Text("SubCategory Image",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),

                ],
              ),
              subCategoryList(deleteSubCategory: deleteSubCategory, searchQuery: searchQuery)
            ],
          ),
        ),
      ),
    );
  }
}

class subCategoryList extends StatelessWidget {
  final Function(String) deleteSubCategory;
  final String searchQuery;

  const subCategoryList({Key? key, required this.deleteSubCategory, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("SubCategories").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final SubCategoryDocs = snapshot.data!.docs;
        List<subCategoryModel> subCategories = [];

        for (var doc in SubCategoryDocs) {
          final subCategory = subCategoryModel.fromSnapshot(doc);
          subCategories.add(subCategory);
        }
        List<subCategoryModel> filteredSubCategories = subCategories.where((subCategory) =>
            subCategory.subCategory.toLowerCase().contains(searchQuery.toLowerCase())).toList();
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: filteredSubCategories.length,
          itemBuilder: (context, index) {
            final subCategory = filteredSubCategories[index];
            return Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Text(
                          (index + 1).toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Text(
                          subCategory.subCategory,
                          style: TextStyle(fontSize: 17),
                        ),
                        Spacer(),
                        Image.network(
                          subCategory.image,
                          width: 120,
                          height: 50,
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 35,
                          width: 60,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => editSubCategoryScreen(subcategory: subCategory, image: subCategory.image)),
                              );
                            },
                            child: Text(
                              "Edit",
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          width: 60,
                          height: 35,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Confirm Deletion"),
                                    content: Text("Are you sure you want to delete this SubCategory?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          deleteSubCategory(subCategory.id);
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("Yes"),
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text(
                              "Delete",
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
