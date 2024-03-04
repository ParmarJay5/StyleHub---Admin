// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// import 'UserModel.dart';
//
// class userScreen extends StatefulWidget {
//   const userScreen({super.key});
//
//   @override
//   State<userScreen> createState() => _userScreenState();
// }
//
// class _userScreenState extends State<userScreen> {
//   late TextEditingController searchController;
//   late String searchQuery;
//
//   @override
//   void initState() {
//     super.initState();
//     searchController = TextEditingController();
//     searchQuery = "";
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Users"),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//
//
//
//             UserList(searchQuery: searchQuery),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class UserList extends StatelessWidget {
//   final String searchQuery;
//
//   const UserList({Key? key, required this.searchQuery});
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection("Users").snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }
//         if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }
//         final userDocs = snapshot.data!.docs;
//         List<UserModel> users = [];
//
//         for (var doc in userDocs) {
//           final user = UserModel.fromSnapshot(doc);
//           if (user.username.toLowerCase().contains(searchQuery.toLowerCase())) {
//             users.add(user);
//           }
//         }
//
//         return ListView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: users.length,
//           itemBuilder: (context, index) {
//             final user = users[index];
//             return Card(
//               child: ListTile(
//                 title: Text(user.username, style: TextStyle(fontSize: 20)),
//                 subtitle: Text(user.email),
//                 trailing: IconButton(
//                   icon: Icon(Icons.delete),
//                   color: Colors.red,
//                   onPressed: () {
//                     // Show confirmation dialog
//                     _showDeleteConfirmationDialog(context, user.id);
//                   },
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   void _showDeleteConfirmationDialog(BuildContext context, String userId) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Confirm Deletion"),
//           content: Text("Are you sure you want to delete this user?"),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close dialog
//               },
//               child: Text("Cancel"),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close dialog
//                 _deleteUser(userId); // Delete user
//               },
//               child: Text("Yes"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _deleteUser(String userId) {
//     FirebaseFirestore.instance.collection('Users').doc(userId).delete().then((value) {
//       print('User deleted successfully');
//     }).catchError((error) {
//       print('Failed to delete user: $error');
//     });
//   }
// }


//
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import 'UserModel.dart';
//
// class SellerProfilePage extends StatefulWidget {
//   const SellerProfilePage({Key? key}) : super(key: key);
//
//   @override
//   _SellerProfilePageState createState() => _SellerProfilePageState();
// }
//
// class _SellerProfilePageState extends State<SellerProfilePage> {
//   late final SellerData _sellerData;
//   bool _isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchSellerData();
//   }
//
//   Future<void> _fetchSellerData() async {
//     try {
//       String sellerUid = FirebaseAuth.instance.currentUser!.uid;
//       SellerDataService sellerDataService = SellerDataService();
//       SellerData? sellerData = await sellerDataService.getSellerData(sellerUid);
//       if (sellerData != null) {
//         setState(() {
//           _sellerData = sellerData;
//           _isLoading = false;
//         });
//       } else {
// // Handle case where seller data is not found
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       print('Error fetching seller data: $e');
// // Handle error
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Seller Profile'),
//       ),
//       body: _isLoading
//           ? Card(child: Center(child: CircularProgressIndicator()))
//           : _sellerData != null
//               ? Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     ListTile(
//                       title: Text('Email: ${_sellerData.email}'),
//                     ),
//                     ListTile(
//                       title: Text('Approved: ${_sellerData.approved}'),
//                     ),
//                   ],
//                 )
//               : Center(
//                   child: Text('Seller data not found'),
//                 ),
//     );
//   }
// }





//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class SellerScreen extends StatefulWidget {
//   const SellerScreen({Key? key}) : super(key: key);
//
//   @override
//   _SellerScreenState createState() => _SellerScreenState();
// }
//
// class _SellerScreenState extends State<SellerScreen> {
//   late TextEditingController searchController;
//   late String searchQuery;
//
//   @override
//   void initState() {
//     super.initState();
//     searchController = TextEditingController();
//     searchQuery = "";
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Sellers"),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//
//             SizedBox(height: 10),
//             Expanded(
//               child: StreamBuilder(
//                 stream: FirebaseFirestore.instance.collection("Sellers").snapshots(),
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData) {
//                     return Center(child: CircularProgressIndicator());
//                   }
//                   final sellerDocs = snapshot.data!.docs;
//                   List<Widget> sellerCards = [];
//
//                   for (var doc in sellerDocs) {
//                     final sellerData = doc.data() as Map<String, dynamic>;
//                     final sellerName = sellerData['username'] ?? "";
//                     final sellerEmail = sellerData['email'] ?? "";
//
//                     if (sellerName.toLowerCase().contains(searchQuery.toLowerCase())) {
//                       sellerCards.add(
//                         Card(
//                           child: ListTile(
//                             title: Text(sellerName,style: TextStyle(fontSize: 30),),
//                             subtitle: Text(sellerEmail, style: TextStyle(fontSize: 20),),
//                             // Add more fields if needed
//                           ),
//                         ),
//                       );
//                     }
//                   }
//
//                   return ListView(
//                     children: sellerCards,
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class SellerScreen extends StatefulWidget {
//   const SellerScreen({Key? key}) : super(key: key);
//
//   @override
//   _SellerScreenState createState() => _SellerScreenState();
// }
//
// class _SellerScreenState extends State<SellerScreen> {
//   late TextEditingController searchController;
//   late String searchQuery;
//
//   @override
//   void initState() {
//     super.initState();
//     searchController = TextEditingController();
//     searchQuery = "";
//   }
//   void _approveSeller(String sellerId) {
//     FirebaseFirestore.instance.collection("Sellers").doc(sellerId).update({
//       'status': 'approved',
//     }).then((value) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Seller approved successfully')),
//       );
//     }).catchError((error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to approve seller: $error')),
//       );
//     });
//   }
//
//   void _rejectSeller(String sellerId) {
//     FirebaseFirestore.instance.collection("Sellers").doc(sellerId).update({
//       'status': 'rejected',
//     }).then((value) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Seller rejected successfully')),
//       );
//     }).catchError((error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to reject seller: $error')),
//       );
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Sellers"),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//
//             SizedBox(height: 10),
//             Expanded(
//               child: StreamBuilder(
//                 stream: FirebaseFirestore.instance.collection("Sellers").snapshots(),
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData) {
//                     return Center(child: CircularProgressIndicator());
//                   }
//                   final sellerDocs = snapshot.data!.docs;
//
//                   return ListView.builder(
//                     itemCount: sellerDocs.length,
//                     itemBuilder: (context, index) {
//                       final sellerData = sellerDocs[index].data() as Map<String, dynamic>;
//                       final sellerId = sellerDocs[index].id;
//                       final sellerName = sellerData['username'] ?? "";
//                       final sellerEmail = sellerData['email'] ?? "";
//
//                       if (sellerName.toLowerCase().contains(searchQuery.toLowerCase())) {
//                         return Card(
//                           child: ListTile(
//                             title: Text(
//                               sellerName,
//                               style: TextStyle(fontSize: 30),
//                             ),
//                             subtitle: Text(
//                               sellerEmail,
//                               style: TextStyle(fontSize: 20),
//                             ),
//                             trailing: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 IconButton(
//                                   icon: Icon(Icons.thumb_up),
//                                   onPressed: () {
//                                     _approveSeller(sellerId);
//                                   },
//                                 ),
//                                 IconButton(
//                                   icon: Icon(Icons.thumb_down),
//                                   onPressed: () {
//                                     _rejectSeller(sellerId);
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       } else {
//                         return SizedBox.shrink();
//                       }
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }







import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SellerScreen extends StatefulWidget {
  const SellerScreen({Key? key}) : super(key: key);

  @override
  _SellerScreenState createState() => _SellerScreenState();
}

class _SellerScreenState extends State<SellerScreen> {
  late TextEditingController searchController;
  late String searchQuery;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    searchQuery = "";
  }

  void _approveSeller(String sellerId) {
    FirebaseFirestore.instance.collection("Sellers").doc(sellerId).update({
      'status': 'approved',
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Seller approved successfully')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to approve seller: $error')),
      );
    });
  }

  void _rejectSeller(String sellerId) {
    FirebaseFirestore.instance.collection("Sellers").doc(sellerId).update({
      'status': 'rejected',
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Seller rejected successfully')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reject seller: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sellers"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("Sellers").snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final sellerDocs = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: sellerDocs.length,
                    itemBuilder: (context, index) {
                      final sellerData = sellerDocs[index].data() as Map<String, dynamic>;
                      final sellerId = sellerDocs[index].id;
                      final sellerName = sellerData['username'] ?? "";
                      final sellerEmail = sellerData['email'] ?? "";

                      if (sellerName.toLowerCase().contains(searchQuery.toLowerCase())) {
                        return Card(
                          child: ListTile(
                            title: Text(
                              sellerName,
                              style: TextStyle(fontSize: 30),
                            ),
                            subtitle: Text(
                              sellerEmail,
                              style: TextStyle(fontSize: 20),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.thumb_up, color: sellerData['status'] == 'approved' ? Colors.green : null),
                                  onPressed: () {
                                    _approveSeller(sellerId);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.thumb_down,color: sellerData['status'] == 'rejected' ? Colors.red : null,),
                                  onPressed: () {
                                    _rejectSeller(sellerId);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

