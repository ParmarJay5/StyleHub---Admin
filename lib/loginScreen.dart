
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:admin/homeScreen.dart';
import 'package:admin/signupScreen.dart';

import 'image.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var password = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(height: 80,),
            Padding(padding: EdgeInsets.all(30),
                child: Text("Login To Your\nAccount",style: TextStyle(fontSize: 30,color: Colors.black,fontWeight: FontWeight.bold),)),

            SizedBox(height: 20,),
            Center(child: Image.asset(a,width: 100,height: 100,)),

            SizedBox(height: 40,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      hintText: "abc@gmail.com",
                      prefixIcon: Icon(Icons.email),

                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: password,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      hintText: "Password",
                      prefixIcon: Icon(Icons.password),
                      suffixIcon: IconButton(
                        onPressed: (){
                          setState(() {
                            password = !password;
                          });

                        }, icon: password
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off)
                      )
                    ),
                  ),
                ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            //   child: Row(mainAxisAlignment: MainAxisAlignment.end,
            //     children: [
            //       TextButton(onPressed: (){}, child: Text("Forget Password?", style: TextStyle(color: Colors.grey),)),
            //     ],
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
            //   child: SizedBox(width: double.infinity,
            //
            //     child: ElevatedButton(onPressed: (){
            //       Navigator.push(context, MaterialPageRoute(builder: (context) => homeScreen() ));
            //     },
            //         style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue,shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(10)
            //         )),
            //         child: Text("Login",style: TextStyle(color: Colors.white),)),
            //   ),
            // ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      final UserCredential userCredential =
                      await _auth.signInWithEmailAndPassword(
                        email: _emailController.text.trim(),
                        password: _passwordController.text,
                      );
                      // Navigate to home screen if login successful
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => homeScreen()),
                      );
                    } catch (e) {
                      // Show error message if login fails
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Failed to sign in"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?",style: TextStyle(color: Colors.grey),),
                TextButton(onPressed: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => signupScreen()));
                }, child: Text("Signup",style: TextStyle(color: Colors.black),))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
