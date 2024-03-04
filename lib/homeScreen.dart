import 'package:admin/loginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:admin/Admin/Banner/bannerScreen.dart';
import 'package:admin/Admin/Categories/categoryScreen.dart';
import 'package:admin/Admin/orderScreen.dart';
import 'package:admin/Admin/Products/productScreen.dart';
import 'package:admin/Admin/SubCategory/subcategoryScreen.dart';
import 'package:admin/Admin/Users/userScreen.dart';

import 'image.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    )) ??
        false;
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child:Scaffold(
        key: _scaffoldKey,

        appBar: AppBar(title: Text("Style Hub",style: TextStyle(fontWeight: FontWeight.bold),),

        // leading: IconButton(icon: Icon(Icons.menu), onPressed: () {

    ),

            drawer: Drawer(
              child: ListView(
                children: [
                  DrawerHeader(
  decoration:  BoxDecoration(
    color: Colors.white,
    image: DecorationImage(
      image: AssetImage(admin,), // Replace "path/to/your/image.jpg" with the actual path to your image asset
      fit: BoxFit.cover,
    ),
  ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 47),
      child: Text("Admin",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 30),),
    ),
  ),
  ListTile(leading: Icon(Icons.dashboard),
  title: Text("Dashboard",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
  onTap: () => Navigator.of(context).pop(false),
  ),
  // ListTile(
  //   leading: Icon(Icons.add_box),
  // title: Text("Orders",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
  // // onTap: ,
  // ),
  // ListTile(
  //   leading: Icon(Icons.notification_add),
  // title: Text("Notification",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
  // // onTap: ,
  // ),
  ListTile(leading: Icon(Icons.logout),

    onTap:()
  {
    FirebaseAuth.instance.signOut();
    {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => loginScreen()), (route) => false);
    }
  },
  title: Text("Logout",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
  // onTap: ,
  ),
                  ListTile(
                    leading: Icon(Icons.share),
                    title: Text("share",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    // onTap: ,
                  ),
                  ListTile(
                    leading: Icon(Icons.rate_review),
                    title: Text("Rate Us",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    // onTap: ,
                  ),
  ],
  )
  ),

    body: 
    Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20,),
           // Center(
             // child: Text(
             //  'Style Hub Admin', style: TextStyle(fontStyle: FontStyle.italic,
             //    fontSize: 30,
             //    fontWeight: FontWeight.bold,
             //    color: Colors.blueAccent),),
           // ),
          Center(child: Image.asset(admin,height: 90,width: 90,)),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Center(child: Text("Admin",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.lightBlue),)),
          ),
          SizedBox(height: 10,),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              shrinkWrap: true,
              // physics: const NeverScrollableScrollPhysics(),
              // Prevent GridView from scrolling
              children: List.generate(6, (index) {
                // Define a list of card data with images and onTap handlers
                List<Map<String, dynamic>> cardData = [
                  {
                    "image": "assets/Icons/category.png",
                    "text": "Category",
                    "onTap": _openCategoryScreen
                  },
                  {
                    "image": "assets/Icons/subcategory.png",
                    "text": "SubCategory",
                    "onTap": _openSubCategoryScreen
                  },
                  {
                    "image": "assets/Icons/product.png",
                    "text": "Products",
                    "onTap": _openProductsScreen
                  },
                  {
                    "image": "assets/Icons/banner.png",
                    "text": "All Banners",
                    "onTap": _openSliderBannerScreen
                  },
                  {
                    "image": "assets/Icons/user.png",
                    "text": "All Users",
                    "onTap": _openUserScreen
                  },
                  {
                    "image": "assets/Icons/user.png",
                    "text": "All Sellers",
                    "onTap": _openSellerScreen
                  },
                ];
                return GestureDetector(
                  onTap: cardData[index]["onTap"],
                  child: Card(
                    color: CupertinoColors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          cardData[index]["image"],
                          width: 48.0,
                          height: 48.0,
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          cardData[index]["text"],
                          style: const TextStyle(fontSize: 17.0),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),


        ],
      ),
    )
        )
    );
  }



  void _openCategoryScreen() {
    // Navigate to the CategoryScreen
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const categoryScreen(),
    ));
  }

  void _openSubCategoryScreen() {
    // Navigate to the SubCategoryScreen
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const subcategoryScreen(),
    ));
  }

  void _openProductsScreen() {
    // Navigate to the ProductsScreen
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const ProductScreen(),
    ));
  }

  void _openSellerScreen() {
    // Navigate to the UsersScreen
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const SellerScreen(),
    ));
  }

  void _openSliderBannerScreen() {
    // Navigate to the SliderBannerScreen
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const bannerScreen(),
    ));
  }

  void _openUserScreen() {
    // Navigate to the OrdersScreen
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const UserScreen(),
    ));
  }
}


