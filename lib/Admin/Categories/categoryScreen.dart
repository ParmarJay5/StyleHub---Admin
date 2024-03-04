import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:admin/Admin/Categories/addCategoryScreen.dart';
import 'package:admin/Admin/Categories/editCategoryScreen.dart';

import 'categoryModel.dart';

class categoryScreen extends StatefulWidget {
  const categoryScreen({super.key});

  State<categoryScreen> createState() => _categoryScreenState();
}

class _categoryScreenState extends State<categoryScreen> {
  late TextEditingController searchContrller;
  late String searchQuery;

  @override
  void initState() {
    super.initState();
    searchContrller = TextEditingController();
    searchQuery = "";
  }

  void _deleteCategory(String categoryID) {
    FirebaseFirestore.instance
        .collection("Categories")
        .doc(categoryID)
        .delete()
        .then((value) {
      Fluttertoast.showToast(
          msg: "Category Deleted Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white);
    }).catchError((error) {
      Fluttertoast.showToast(
          msg: "Failed to delete Category",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Category",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => addCategoryScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4))),
                  child: Text(
                    "Add Category",
                    style: TextStyle(color: Colors.white),
                  )),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 45,
                width: double.infinity,
                child: TextFormField(
                  controller: searchContrller,
                  onChanged: (value)
                  {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)),
                      hintText: "Search Category...",
                      prefixIcon: Icon(Icons.search)),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: [
              //     Text(
              //       "Sr.No",
              //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              //     ),
              //     Text(
              //       "Category Name",
              //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              //     ),
              //     Text(
              //       "Category Image",
              //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              //     ),
              //   ],
              // ),
              categoryList(
                  deleteCategory: _deleteCategory, searchQuery: searchQuery)
            ],
          ),
        ),
      ),
    );
  }
}

class categoryList extends StatelessWidget {
  final Function(String) deleteCategory;
  final String searchQuery;

  const categoryList(
      {Key? key, required this.deleteCategory, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Categories").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: const CircularProgressIndicator());
          }
          final categoryDocs = snapshot.data!.docs;
          List<categoryModel> categories = [];

          for (var doc in categoryDocs) {
            final category = categoryModel.fromSnapshot(doc);
            categories.add(category);
          }
          List<categoryModel> filteredCategories = categories
              .where((category) =>
              category.category
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()))
              .toList();
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filteredCategories.length,
            itemBuilder: (context, index) {
              final category = filteredCategories[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              category.category,
                              style: TextStyle(fontSize: 30),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Image.network(
                              category.image,
                              width: 220,
                              height: 200,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        icon: Icon(Icons.edit,color: Colors.blueAccent,),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  editCategoryScreen(
                                    category: category,
                                    image: category.image,
                                  ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 20,),
                      IconButton(
                        icon: Icon(Icons.delete,color: Colors.red,),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Confirm Deletion"),
                                content: Text(
                                  "Are you sure you want to delete this category? This action cannot be undone.",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      deleteCategory(category.id);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Delete"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        );

    }

  }