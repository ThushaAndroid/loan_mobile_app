import 'package:credit_app/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NavBAR extends StatefulWidget {

  NavBAR();

  @override
  State<NavBAR> createState() => _NavBARState();

}


class _NavBARState extends State<NavBAR> {

   final user = FirebaseAuth.instance.currentUser;
    GlobalKey<ScaffoldState> _backKey = new GlobalKey<ScaffoldState>();
    
  

  @override
  Widget build(BuildContext context) {
    //String userName=widget.userName;
    return WillPopScope(
      //Exit fuction in back button
      onWillPop: ()async{
         if(_backKey.currentState!.isDrawerOpen){
          Navigator.of(context).pop();
          return false;
         }
         return true;
        },
      child: Drawer(
        //Navigation list
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user!.email.toString().substring(0,user!.email.toString().length-10)),
             accountEmail: Text(user!.email.toString()),
             currentAccountPicture: CircleAvatar(
              child:ClipOval(
              child: Image.asset('assets/images/user.png',
              width: 90,
              height: 90,
              fit: BoxFit.cover,),
              ),
             ),
             decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(image:AssetImage('assets/images/header_menu.jpg'),
              fit: BoxFit.cover,)
             ),
             ),
           
            
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: ()=>null,
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifications'),
              onTap: ()=>null,
            ),
            ListTile(
              leading: Icon(Icons.policy),
              title: Text('Policies'),
              onTap: ()=>null,
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text('Share'),
              onTap: ()=>null,
            ),
            Divider(),
    
            //Exit button
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Exit'),
              onTap: (){
                 showDialog(
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
              
              },
              
              ),
    
              //Signout button
              ListTile(
              leading: Icon(Icons.logout_outlined),
              title: Text('Sign Out'),
              onTap: (){
             
            showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('You want to sign out...',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
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
                    await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                                      builder: (_) => LginScreen(),
                                    ));
                    
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
              },
              
              )
              
            
          ],
        ),
      ),
    );
  }
}