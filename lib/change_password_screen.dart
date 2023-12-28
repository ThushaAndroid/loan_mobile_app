import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {

   final _emailController = TextEditingController();

   @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  //PasswordReset Button
  Future passwordResest() async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Password reset link sent! Check your email',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
              actions: [
                 Center(
                   child: TextButton(onPressed: (){
                                                  Navigator.pop(context);
                                              }, child: Text('Ok'),
                                              style: TextButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              elevation: 2,
                                              backgroundColor: Colors.blue),
                                              ),
                 ),
              ],
            );
          });
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
       child: Scaffold(
          appBar: AppBar(
            title: Text('Change Password'),
          ),
          body: Stack(children: [
    
    
            //Purple and Blue Box Backgroud
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.grey, Colors.blue],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft)),
              child: Padding(
                padding: EdgeInsets.only(top: 60.0),
                child: Align(
                  alignment:Alignment.topCenter,
                  child: Text(
                    'Credit App',
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
    
            //White Box Backgroud
            Padding(
                padding: EdgeInsets.only(top: 250),
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40)),
                      color: Colors.white,
                    ),
                    height: double.infinity,
                    width: double.infinity,
                    child: Padding(
                      padding:
                          EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
                      child: SingleChildScrollView(
                          child: Column(children: [
                        SizedBox(
                          height: 20,
                        ),
    
                        //Text
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Text(
                            'Enter your Email and we will sent you a password reset link',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
    
                        //Email TextField
                        TextField(
                          cursorColor: Colors.blue,
                          controller: _emailController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            hintText: 'Email',
                            fillColor: Colors.blueGrey,
                            filled: true,
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
    
                          //ChangePassword Button
                        GestureDetector(
                          onTap: () {
                            passwordResest();
                          },
                          child: Container(
                            height: 50,
                            width: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: LinearGradient(
                                colors: [Colors.grey, Colors.blue],
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Change Password',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ])),
                    ))),
          ])),
    );
  }
}