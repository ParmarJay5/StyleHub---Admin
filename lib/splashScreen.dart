import 'dart:async';

import 'package:flutter/material.dart';
import 'package:admin/image.dart';
import 'package:admin/loginScreen.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {

  @override
  void initState(){
    super.initState();
    Timer(Duration(seconds: 3), ()=> Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => loginScreen())) );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: SingleChildScrollView(
      child: Column(
        children: [
          // Container(
          //   height: MediaQuery.of(context).size.height,
          //   width: MediaQuery.of(context).size.width,
          //   decoration: BoxDecoration(
          //     color: Colors.black,
          //     image: DecorationImage(image: AssetImage(splash),
          //     fit: BoxFit.cover,
          //     opacity: 0.4),
          //   ),
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 60,vertical: 300),
          //     child: Column(
          //       children: [
          //         Icon(Icons.shopping_cart,
          //           size: 230,
          //           color: Color.fromARGB(255, 238, 80, 80),
          //         ),
          //         Text("Style Hub", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 37,fontStyle: FontStyle.italic),)
          //       ],
          //     ),
          //   )
          // )

          Padding(
            padding: const EdgeInsets.only(top: 300),
            child: Center(
              child: Image.asset(
                b, // Replace 'logo.png' with your logo asset path
                width: 150,
                height: 150,
              ),
            ),

          ),
          SizedBox(height: 10,),
          Text(
            'Style Hub', // Your app name
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Customize text color as per your design
            ),
          ),
          SizedBox(height: 20),
          CircularProgressIndicator(color: Colors.black,),

        ],
      ),
    ),
    );
  }
}
