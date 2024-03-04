import 'package:admin/Admin/Banner/addBannerScreen.dart';
import 'package:admin/Admin/Banner/bannerModel.dart';
import 'package:admin/Admin/Banner/editBannerScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class bannerScreen extends StatefulWidget {
  const bannerScreen({super.key});

  @override
  State<bannerScreen> createState() => _bannerScreenState();
}

class _bannerScreenState extends State<bannerScreen> {
  late TextEditingController searchController;
  late String searchQuery;

  @override
  void initState(){
    super.initState();
    searchController = TextEditingController();
    searchQuery = "";
  }
  void deleteBanner(String bannerID){
    FirebaseFirestore.instance.collection("Banners").doc(bannerID).delete().then((value) {
      Fluttertoast.showToast(msg: "Banner Deleted Successfully",toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM,backgroundColor: Colors.green,textColor: Colors.white);
    }).catchError((error){
      Fluttertoast.showToast(msg: "Failed to delete Banner",toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM,backgroundColor: Colors.red,textColor: Colors.white);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Banner",style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => addBannerScreen()));
              },style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))) ,
                  child: Text("Add Banner",style: TextStyle(color: Colors.white),)),

              SizedBox(height: 10,),

              Container(height: 50,
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
                      hintText: "Search Banner...",
                      prefixIcon: Icon(Icons.search)

                  ),
                ),
              ),
              SizedBox(height: 5,),
              BannerList(deleteBanner: deleteBanner,searchQuery: searchQuery,)
            ],
          ),
        ),
      ),
    );
  }
}



class BannerList extends StatelessWidget {
  final Function(String) deleteBanner;
  final String searchQuery;

  const BannerList({Key? key, required this.deleteBanner, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("Banners").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final bannerDocs = snapshot.data!.docs;
        List<bannerModel> banners = [];

        for (var doc in bannerDocs) {
          final banner = bannerModel.fromSnapshot(doc);
          banners.add(banner);
        }
        List<bannerModel> filteredBanners = banners.where((banner) =>
            banner.banner.toLowerCase().contains(
                searchQuery.toLowerCase())).toList();
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredBanners.length,
          itemBuilder: (context, index) {
            final banner = filteredBanners[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(15),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    banner.image,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Text(
                  banner.banner,
                  style: TextStyle(fontSize: 17),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      color: Colors.blueAccent,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => editBannerScreen(banner: banner, image: banner.image)),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      color: Colors.red,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Confirm Deletion"),
                              content: Text("Are you sure you want to delete this banner?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    deleteBanner(banner.id);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Yes"),
                                )
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
      },
    );
  }
}
