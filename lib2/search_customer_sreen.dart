import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credit_app/listmodel.dart';
import 'package:credit_app/loan_history_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchCoustomer extends StatefulWidget {
  const SearchCoustomer({super.key});

  @override
  State<SearchCoustomer> createState() => _SearchCoustomerState();
}

class _SearchCoustomerState extends State<SearchCoustomer> {

      var name='xxx';
      var nic='xxx';
      var email='xxx';
      var address='xxx';
      var tel='xxx';

      String inputText = "";
      final user = FirebaseAuth.instance.currentUser!.email;
      List<ListModel> model=[];
     
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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

              Container(
              height: double.infinity,
              width:double.infinity,
                child: Padding(
                    padding:
                                EdgeInsets.only(top: 80.0, left: 20.0, right: 20.0),
                    
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Search bill id text field
                    TextFormField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "Search bill customer...",
                         hintStyle: TextStyle(color: Colors.white),
                        suffixIcon: const Icon(Icons.search,
                         color: Colors.white,),
                       
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                             color:Colors.white
                          ),
                        ),
                        
                      ),
                       cursorColor: Colors.white,
                       style: TextStyle(color: Colors.white),
                      onChanged: (val) {
                        setState(() {
                          inputText = val;
                        });
                      },
                    ),
                     // List view of cre_customer in firestore
                      Expanded(
                      child: Container(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('cre_customer')
                              .snapshots(),
                          builder: (context, snapshots) {
                        
                            if (snapshots.hasError) {
                                return Center(
                                  child: Text("Something went wrong"),
                                );
                              }
                            return (snapshots.connectionState ==
                                    ConnectionState.waiting)
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ListView.builder(
                                    itemCount:snapshots.data!.docs.length,
                                    itemBuilder: (context, index){
                                      var data = snapshots.data!.docs[index].data()
                                          as Map<String, dynamic>;
                        
                                      if (inputText.isEmpty) {
                                          return ListTile(
                                            title: Text(data['cust_nic'],
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis),
                                            subtitle: Text(data['cust_nic']),
                                                textColor: Colors.white,
                                             onTap: (){
                                         
                                           setState(() {
                                            name= data['cust_name'];
                                            nic= data['cust_nic'];
                                            email=data['cust_email'];
                                            address=data['cust_add'];
                                            tel=data['cust_tel'];
                                           });
                        
                              //           Navigator.of(context).push(MaterialPageRoute(
                              //             builder: (_) => OldBill(name,invoiceNo,date,total,count),
                              //  ));
                                      
                                                   
                                      },
                                       );
                                        
                                      }
                                      if (data['cust_nic']
                                          .toString().toLowerCase()
                                          .startsWith(inputText.toLowerCase())) {
                                        return ListTile(
                                            title: Text(data['cust_nic'],
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis),
                                            subtitle: Text(data['cust_name']),
                                                textColor: Colors.white,
                                            onTap: (){
                                           setState(() {
                                            name= data['cust_name'];
                                            nic= data['cust_nic'];
                                            email=data['cust_email'];
                                            address=data['cust_add'];
                                            tel=data['cust_tel'];
                                           });
                    
                              //               Navigator.of(context).push(MaterialPageRoute(
                              //             builder: (_) => OldBill(name,invoiceNo,date,total,count),
                              //  ));
                                         
                                      },
                                          );
                                        
                                      }
                                      return Container();
                                    },
                                   
                                  );
                          },
                          
                        ),
                      ),
                    ),
                      
                  ],
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
                            
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                        
                                       SizedBox(
                                                          height: 10,
                                                        ),

                                      Row(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('NIC',
                                          style: TextStyle(
                                          fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueAccent)),
                                          SizedBox(
                                                          width: 10,
                                                        ),
                                          Text(nic)
                                        ],
                                      ),

                                      SizedBox(
                                                          height: 15,
                                                        ),

                                      Row(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('Name',
                                          style: TextStyle(
                                          fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueAccent)),
                                          SizedBox(
                                                          width: 10,
                                                        ),
                                          Text(name)
                                        ],
                                      ),

                                      SizedBox(
                                                          height: 15,
                                                        ),

                                      Row(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('email',
                                          style: TextStyle(
                                          fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueAccent)),
                                          SizedBox(
                                                          width: 10,
                                                        ),
                                          Text(email)
                                        ],
                                      ),

                                      SizedBox(
                                                          height: 15,
                                                        ),

                                      Row(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('Address',
                                          style: TextStyle(
                                          fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueAccent)),
                                          SizedBox(
                                                          width: 10,
                                                        ),
                                          Text(address)
                                        ],
                                      ),

                                      SizedBox(
                                                          height: 15,
                                                        ),

                                      Row(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text('Tel',
                                          style: TextStyle(
                                          fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueAccent)),
                                          SizedBox(
                                                          width: 10,
                                                        ),
                                          Text(tel)
                                        ],
                                      ),

                                       SizedBox(
                                                          height: 100,
                                                        ),

                                      
                                                          //Next Button
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
                                                                        builder: (_) => LoanHistory(name,nic,'',model),
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
                                  'Next',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                    ]
                                  ),
                                )
                              
              )
              ),
            ),


          ],
        
        ),
      ),
    );
  }
}