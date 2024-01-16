import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credit_app/listmodel.dart';
import 'package:credit_app/loan_history_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      String date=DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      List<ListModel> model=[];
       late int maxValue;
       String _value='cust_nic';
       String searchCust="Search NIC";
       

  @override
  void initState() {
    super.initState();
    lastValue();
  }


//Get last document id from bill hedder colllection in firestore
  lastValue()async{
    var collection=FirebaseFirestore.instance.collection('cre_recept_number'); 
    var allDocs=await collection.get();
    var docID=allDocs.docs.last.id;

    setState(() {
    DocumentReference documentRef = FirebaseFirestore.instance.collection('cre_recept_number').doc(docID);
    documentRef.get().then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    maxValue = ++data['recept_number'];
   // print('The specific value is: $specificValue');
  } else {
    maxValue=0;
    print('Document does not exist');
  }
}).catchError((error) {
  maxValue=0;
  print('Error getting document: $error');
});
    });
    
  }   
  
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
                     // keyboardType:TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: searchCust,
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
                                            title: Text(data[_value],
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
                                      if (data[_value]
                                          .toString().toLowerCase()
                                          .startsWith(inputText.toLowerCase())) {
                                        return ListTile(
                                            title: Text(data[_value],
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

                                       Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Radio(
                            value: "cust_nic", 
                            groupValue: _value, 
                            onChanged: (value){
                              setState(() {
                                _value=value!;
                                searchCust="Search NIC";
                              });
                            }),
                           Text('NIC'),
                           SizedBox(width: 10),

                            Radio(
                            value: "cust_tel", 
                            groupValue: _value, 
                            onChanged: (value){
                              setState(() {
                                _value=value!;
                                searchCust="Search Mobile";
                              });
                            }),
                           Text('Mobile'),
                           SizedBox(width: 10),

                            Radio(
                            value: "cust_name", 
                            groupValue: _value, 
                            onChanged: (value){
                              setState(() {
                                _value=value!;
                                searchCust="Search Name";
                              });
                            }),
                           Text('Name'),
                           SizedBox(width: 10),
                        ],
                      ),
                                        
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
                                      
                                                             Navigator.of(context).pushReplacement(MaterialPageRoute(
                                                                        builder: (_) => LoanHistory(name,nic,maxValue,date,'',model),
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
                                  'Now payment',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,      
                                      fontSize: 20,
                                      color: Colors.white),
                                                              ),
                                                            ),
                                                          ),
                                                        ),

                                   SizedBox(
                                                          height: 20,
                                                        ),


                                  //     GestureDetector(
                                  //                         onTap: ()async{
                                      
                                  //                            showDialog(
                                  //         context: context,
                                  //         builder: (context) {
                                  //           return Center(
                                  //             child: CircularProgressIndicator(),
                                  //           );
                                  //         });
                                  //            await Future.delayed(Duration(seconds: 1),(){
                                  //       Navigator.pop(context);
                                  //     });
                                      
                                  //                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                                  //                                       builder: (_) => OldPayment(name,nic,''),
                                  //                            ));
                                                           
                                  //                         },
                                  //                         child: Container(
                                  //                           height: 50,
                                  //                           width: 300,
                                  //                           decoration: BoxDecoration(
                                  //                             borderRadius: BorderRadius.circular(30),
                                  //                             gradient: LinearGradient(
                                  // colors: [Colors.blueGrey,Colors.blue],
                                  //                             ),
                                  //                           ),
                                  //                           child: Center(
                                  //                             child: Text(
                                  // 'Old payment',
                                  // style: TextStyle(
                                  //     fontWeight: FontWeight.bold,
                                  //     fontSize: 20,
                                  //     color: Colors.white),
                                  //                             ),
                                  //                           ),
                                  //                         ),
                                  //                       ),
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