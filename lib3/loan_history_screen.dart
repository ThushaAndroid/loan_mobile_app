import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credit_app/dashboard_screen.dart';
import 'package:credit_app/loan_payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LoanHistory extends StatefulWidget {
 
 late String name;
 late String nic;
 late int maxValue;
 late String date;
 late String receptNo;
 late List model;
 

LoanHistory(String name, String nic,int maxValue,String date, String receptNo, List model){
  
 this.name=name;
 this.nic=nic;
 this.maxValue=maxValue;
 this.date=date;
 this.receptNo=receptNo;
 this.model=model;
  }

  @override
  State<LoanHistory> createState() => _LoanHistoryState();
}


class _LoanHistoryState extends State<LoanHistory> {


 //String date=DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
   
//    @override
//   void initState() {
//     super.initState();
//     lastValue();
//   }


// //Get last document id from bill hedder colllection in firestore
//   lastValue()async{
//     var collection=FirebaseFirestore.instance.collection('cre_recept_number'); 
//     var allDocs=await collection.get();
//     var docID=allDocs.docs.last.id;

//     setState(() {
//     DocumentReference documentRef = FirebaseFirestore.instance.collection('cre_recept_number').doc(docID);
//     documentRef.get().then((DocumentSnapshot documentSnapshot) {
//     if (documentSnapshot.exists) {
//     Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
//     maxValue = ++data['recept_number'];
//    // print('The specific value is: $specificValue');
//   } else {
//     maxValue=0;
//     print('Document does not exist');
//   }
// }).catchError((error) {
//   maxValue=0;
//   print('Error getting document: $error');
// });
//     });
    
//   }
 
  @override
  Widget build(BuildContext context) {
    String name=widget.name;
    String nic=widget.nic;
   // int maxValue=widget.maxValue;
    return SafeArea(
      child: WillPopScope(
        onWillPop: ()async{
          final value=await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Your data wiil clear if you back....',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
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
                  Navigator.of(context).pop(MaterialPageRoute(
                                                                        builder: (_) => Dashboard(),
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
                    width: double.infinity,
                      child: Padding(
                          padding:EdgeInsets.only(top:80,left: 20.0, right: 20.0),
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                         
                           Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                            Image.asset('assets/images/user.png',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,),
                      
                            SizedBox(
                            width: 10,
                           ),
                      
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name,style: TextStyle(
                                              fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white)),
                                Text(nic,style: TextStyle(
                                              fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white))
                              ],
                            )
                            ],
                           ),
                                        
                           SizedBox(
                            height: 10,
                           ),
      
                           // List view of cre_loan in firestore
                                     
                            Expanded(
                            child: Container(
                              child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('cre_loan').doc(nic).collection('loan_type')
                                    .snapshots(),
                                builder: (context, snapshot){
                                
                                  if(snapshot.hasError){
                                    return Text('Connection error');
                                                }
                                  if(snapshot.connectionState==ConnectionState.waiting){
                                    return Text('Loding...');
                                                }
                                        var docs=snapshot.data!.docs;
                                       return ListView.builder(
                                          itemCount:snapshot.data!.docs.length,
                                          itemBuilder: (context, index){
                                           return Card(
                                            child: ListTile(
                                             title: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Loan Type = '+docs[index]['loan_type'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                                Text('Duration = '+docs[index]['loan_duration'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                                Text('Total = Rs.'+docs[index]['loan_total'].toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                                Text('Balance = Rs.'+docs[index]['balance'].toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15))
                              
                                              ],
                                             ),
                                             onTap: (){
                                              var type=docs[index]['loan_type'];
                                              var dur=docs[index]['loan_duration'];
                                              var tot=docs[index]['loan_total'];
                                              var bal=docs[index]['balance'];
      
                                                Navigator.of(context).pushReplacement(MaterialPageRoute(
                                                                          builder: (_) => LoanPayment(widget.name,widget.nic,type,dur,tot,widget.maxValue,widget.date,widget.model),
                                                               ));
                                             },       
                                            ),
                                           );
                                           
                                          
                                          },
                                         
                                        );
                                },
                                
                              ),
                            ),
                          ),
      
               
                        //Print bill Button
                                                        
                              
                        ],
                                    ),
                      ),
                    
                  ),                      
                 Padding(
                   padding:EdgeInsets.only(top:400),
                   child: Align(
                    alignment: Alignment.center,
                     child: Container(
                       height: 50,
                        width: 300,
                        // child: Padding(
                        //  padding:EdgeInsets.only(top:300,left: 20.0, right: 20.0,bottom: 20.0),
                         child:   GestureDetector(
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
                                                                  //             builder: (_) => LoanHistory(name,nic),
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
                                        'Print bill',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.white),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                        // ),
                     ),
                   ),
                 )               
      
            ],
          ),
        ),
      ),
    );
  }
}