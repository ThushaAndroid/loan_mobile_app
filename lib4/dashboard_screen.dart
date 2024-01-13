import 'package:credit_app/navigationbar_screen.dart';
import 'package:credit_app/search_customer_sreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Dashboard extends StatefulWidget {

  Dashboard();

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

   final user = FirebaseAuth.instance.currentUser;
  

   
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
    return SafeArea(
      //Exit fuction in back button
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
        
          
          //Navigation bar
          drawer: NavBAR(),
          appBar: AppBar(
          title:Text('Dash Board'),
         
        ),
          body: Stack(
              children: [
      
                //Grey and Blue Box Backgroud
                Container(
              height: double.infinity,
              width:double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueGrey,Colors.blue],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft)
              ),
              
                child: Padding(
                  padding: EdgeInsets.only(top: 20.0),
                    child: Align(
                    alignment:Alignment.topCenter,
                      child: Text('Credit App',
                      style: TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.bold),),
                    ),
                
                ),
             
            ),
      
             //White Box Backgroud
            Padding(
              padding: EdgeInsets.only(top:250),
              child: Container(
                 decoration: BoxDecoration(
                              borderRadius:BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40)
                            ),
                            color: Colors.white,
                            ),
                             height: double.infinity,
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsets.only(top:30.0,left: 10.0,right: 10.0),
                            
                                child: Column(
                                  children: [
                                   
      
                                     SizedBox(
                          height: 10,
                        ),
      
                          //Invoice Button
                        GestureDetector(
                          onTap: ()async{
      
                             showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        });
                                           await Future.delayed(Duration(seconds: 1),(){
                                      Navigator.pop(context);
                                    });
      
                             Navigator.of(context).push(MaterialPageRoute(
                                        builder: (_) => SearchCoustomer()
                             ));
                           
                          },
                          child: Container(
                            height: 50,
                            width: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: LinearGradient(
                                colors: [Colors.blueGrey,Colors.blue],
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Payment',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),

                          SizedBox(
                          height: 10,
                        ),
      
                          //Invoice Button
                        GestureDetector(
                          onTap: ()async{
      
                             showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        });
                                           await Future.delayed(Duration(seconds: 1),(){
                                      Navigator.pop(context);
                                    });
      
                            //  Navigator.of(context).push(MaterialPageRoute(
                            //             builder: (_) => Invoice('',maxValue,date),
                            //  ));
                           
                          },
                          child: Container(
                            height: 50,
                            width: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: LinearGradient(
                                colors: [Colors.blueGrey,Colors.blue],
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Instance Loan',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                                  ]
                                )
                              
              )
              ),
            ),
            
      
              ]
          ),
          ),
      )
    );
  }
}