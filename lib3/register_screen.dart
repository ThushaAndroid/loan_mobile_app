import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credit_app/dashboard_screen.dart';
import 'package:credit_app/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  final user = FirebaseAuth.instance.currentUser;
  bool isSecurePassword=true;
  bool isSecureConfirmPassword=true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        
        body: Stack(
          children: [
          
                //Grey and Blue Box Backgroud
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.blueGrey,Colors.blue],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft)),
                  child: Padding(
                  padding: EdgeInsets.only(top: 60.0),
                    child: Align(
                    alignment:Alignment.topCenter,
                      child: Text('Credit App',
                      style: TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.bold),),
                    ),
                ),
                ),
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.only(top: 150.0),
                      child: Align(
                      alignment:Alignment.topCenter,
                        child: Lottie.asset('assets/animation/Animation - 1700504052288.json'),
                      ),
                  ),
                ),
                
                //White Box Backgroud
                Padding(
                  padding: EdgeInsets.only(top: 300.0),
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
                      padding: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
          
                              //Name TextFormField
                              TextFormField(
                                cursorColor: Colors.blue,
                                  controller: _name,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    suffixIcon:
                                        Icon(Icons.face, color: Colors.grey),
                                    label: Text('Name',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.lightBlue)),
                                  ),
                                  validator: (text) {
                                    if (text!.isEmpty) {
                                      return 'Name can not be empty';
                                    }
                                    return null;
                                  },
                                 
          
                                            
                                  ),

                              //User Name TextFormField
                              TextFormField(
                                cursorColor: Colors.blue,
                                  controller: _email,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    suffixIcon:
                                        Icon(Icons.face, color: Colors.grey),
                                    label: Text('User Name',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.lightBlue)),
                                  ),
                                  validator: (text) {
                                    if (text!.isEmpty) {
                                      return 'User name can not be empty';
                                    }
                                    return null;
                                  },
                                 
          
                                            
                                  ),
          
                                  //Password TextFormField
                              TextFormField(
                                cursorColor: Colors.blue,
                                  controller: _password,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                        color: Colors.grey, onPressed: () { 
                                          setState(() {
                                            isSecurePassword=!isSecurePassword;
                                          });
                                         }, icon: isSecurePassword? Icon(Icons.visibility):Icon(Icons.visibility_off)),
                                    label: Text('Password',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.lightBlue)),
                                  ),
                                  obscureText: isSecurePassword,
                                  validator: (text) {
                                    if (text!.isEmpty) {
                                      return 'Password can not be empty';
                                    }
                                    if(text.length<6){
                                      return 'Password must not be less than 6 characters';
                                    }
                                    return null;
                                  },
                                  ),
                                   
                                    //Conform Password TextFormField
                                   TextFormField(
                                cursorColor: Colors.blue,
                                  controller: _confirmPassword,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                        color: Colors.grey, onPressed: () { 
                                          setState(() {
                                            isSecureConfirmPassword=!isSecureConfirmPassword;
                                          });
                                         }, icon: isSecureConfirmPassword? Icon(Icons.visibility):Icon(Icons.visibility_off)),
                                    label: Text('Conform password',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.lightBlue)),
                                  ),
                                  obscureText: isSecureConfirmPassword,
                                  validator: (text) {
                                    if (text!.isEmpty) {
                                      return 'Conform password can not be empty';
                                    }
                                    if(text.length<6){
                                      return 'Password must not be less than 6 characters';
                                    }
                                    if(text!=_password.text){
                                      return 'Password is not mached';
                                    }
                                    return null;
                                  },
                                  ),
                              SizedBox(
                                height: 20,
                              ),
          
                              //Forgot Password Text
                              Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(
                                        builder: (_) => LginScreen(),
                                      ));
                                    },
                                    child: Text(
                                      'Sign In',
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.lightBlue),
                                    )),
                              ),
                              SizedBox(
                                height: 70,
                              ),
          
                              //SignIn Button
                              GestureDetector(
                                onTap: () async {
                                  if (_formKey.currentState!.validate()) {
          
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        });
          
                                    try{await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                            email: _email.text,
                                            password: _password.text)
                                        .then((value) {
                                           final newDocument=FirebaseFirestore.instance.collection('user').doc(_email.text);
                                           newDocument.set( {'name':_name.text});
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Container(
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                          ),
                                          child: Center(
                                          
                                              child: Text('Registration Successfull:')),
                                          
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                      ));
          
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                                        builder: (_) => Dashboard(),
                                      ));
                                     } ); 
                                  
                                       }on FirebaseAuthException catch (e){

                                          Navigator.pop(context);
                                             ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        duration: Duration(seconds: 2),
                                        content: Container(
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                          ),
                                          child: Center(
                                              child: Text(
                                                 e.code)),
                                         
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                      ));
                                        
         
                                                    }
                                    
                                  }
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
                                      'Sign Up',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
        ),
      ),
    );
  }
}