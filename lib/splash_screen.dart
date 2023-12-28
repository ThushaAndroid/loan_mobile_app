import 'package:credit_app/dashboard_screen.dart';
import 'package:credit_app/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

final user = FirebaseAuth.instance.currentUser;
 late String userName;


@override
  void initState() {
    super.initState();
    // currentUser();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

     Future.delayed(Duration(seconds: 7),(){
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder:(_){
          if(user==null){
            return LginScreen();
         }      
          else{
            return Dashboard();
          }
        }
         )
        );
    });
  }

 @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,overlays: SystemUiOverlay.values);
    super.dispose();
  }

//   currentUser(){
//      setState(() {
//     DocumentReference documentRef = FirebaseFirestore.instance.collection('user').doc(user.toString());
//     documentRef.get().then((DocumentSnapshot documentSnapshot) {
//     if (documentSnapshot.exists) {
//     Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
//     userName = data['name'];
   
//   } else {
//     userName='';
//     print('Document does not exist');
//   }
// }).catchError((error) {
//   userName='';
//   print('Error getting document: $error');
// });
//     });
    
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //Greay and Blue Box Backgroud
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey,Colors.blue],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome',
            style:TextStyle(color:Colors.white,fontSize: 40),),
            SizedBox(height: 30),
            Lottie.asset('assets/animation/animation_ln79nd8f.json'),
            SizedBox(height: 20),
            Text('Credit App',
            style:TextStyle(color:Colors.white,fontSize: 30,fontWeight: FontWeight.bold),),
            SizedBox(height: 250),
            Align(
                      alignment: Alignment.bottomCenter,
                      child:Text('(C) Proxima Technologies',style: TextStyle(
                        fontWeight: FontWeight.bold,fontSize: 17,color: Colors.white,
                      ),),
                    ),
                    
          ],
        ),

      ),
    );
  }
}