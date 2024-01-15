import 'package:credit_app/change_password_screen.dart';
import 'package:credit_app/dashboard_screen.dart';
import 'package:credit_app/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class LginScreen extends StatefulWidget {
  const LginScreen({super.key});

  @override
  State<LginScreen> createState() => _LginScreenState();
}

class _LginScreenState extends State<LginScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  final _email = TextEditingController();
  final _password = TextEditingController();

  final user = FirebaseAuth.instance.currentUser;

   bool isSecurePassword=true;
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: ()async{
          final value=await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('You want to exit...',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
              actions: [
                 TextButton(onPressed: (){
                                                Navigator.pop(context);
                                            }, child: Text('No'),
                                            style: TextButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            elevation: 2,
                                            backgroundColor: Colors.blue),
                                            ),
                                             SizedBox(
                                              width: 40,
                                            ),
                 TextButton(onPressed: ()async{

                  Navigator.pop(context);
                 SystemNavigator.pop();
                  
                 },
                 child: Text('Yes'), 
                                             style: TextButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            elevation: 2,
                                            backgroundColor: Colors.blue),
                                            
                 
                 ),
                  SizedBox(
                  width: 20,
                  ),
              ],
            );
          });
          if(value!=null){
            return Future.value(value);
          }else{
            return Future.value(false);
          }
        },
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
                                    // if(text.length<6){
                                    //   return 'Password must not be less than 6 characters';
                                    // }
                                    return null;
                                  },
                                  ),
                              SizedBox(
                                height: 20,
                              ),
          
                              //Forgot Password Text
                              Row(
                                children: [
                                   Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(MaterialPageRoute(
                                            builder: (_) => Register(),
                                          ));
                                        },
                                        child: Text(
                                          'Sign Up',
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.lightBlue),
                                        )),
                                  ),
                                   SizedBox(
                                width: 130,
                              ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(MaterialPageRoute(
                                            builder: (_) => ChangePassword(),
                                          ));
                                        },
                                        child: Text(
                                          'Forgot Password ?',
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.lightBlue),
                                        )),
                                  ),
                                ],
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
                                        .signInWithEmailAndPassword(
                                            email: _email.text,
                                            password: _password.text)
                                        .then((value) {
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
                                          
                                              child: Text('Login Successfull:')),
                                          
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

                                          if(e.code=='invalid-email'){
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
                                                 'Invalid email')),
                                          //child: Text('Error ${error.toString()}'),
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                      ));
                                          }
                                          else if(e.code=='invalid-credential'){
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
                                                 'Invalid password')),
                                         
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                      ));
                                          }else{
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
                                      'Sign In',
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
      ),
    );
  }
}