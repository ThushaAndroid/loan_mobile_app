import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OldPayment extends StatefulWidget {

 late String name;
 late String nic;
 late String lNo;

  OldPayment(String name, String nic, String lNo){

 this.name=name;
 this.nic=nic;
 this.lNo=lNo;

  }

  @override
  State<OldPayment> createState() => _OldPaymentState();
}

class _OldPaymentState extends State<OldPayment> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
           body: Stack(
          children: [       
            
            //Grey and White Box Backgroud
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blueGrey,Colors.white],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft)
                ),
                child: Column(
                
                  children: [
                                    Padding(
                                        padding: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                                                     
                                      Text('Coustomer id - '+widget.nic,style: TextStyle(
                                                fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)),
                                      Text('Coustomer name - '+widget.name,style: TextStyle(
                                                fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)),
                                      Text('Loan no - '+widget.lNo,style: TextStyle(
                                                fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)),
                                      // Text('Duration - '+widget.dur,style: TextStyle(
                                      //           fontSize: 12,
                                      //             fontWeight: FontWeight.bold,
                                      //             color: Colors.black)),
                                      // Text('Total - '+widget.tot.toString(),style: TextStyle(
                                      //           fontSize: 12,
                                      //             fontWeight: FontWeight.bold,
                                      //             color: Colors.black)),
                                      // Text('Balance - '+balance.toString(),style: TextStyle(
                                      //           fontSize: 12,
                                      //             fontWeight: FontWeight.bold,
                                      //             color: Colors.black)),
                                        ],
                                      ),
                                    ),
                
                        SizedBox(height: 10,),
      
                     Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                          Text('Payment type',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10)),
                                                          SizedBox(width: 10,),
                                                          Text('Date',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10)),
                                                          SizedBox(width: 10,),
                                                          Text('Recept no',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10)),
                                                          SizedBox(width: 10,),
                                                          Text('Loan amount',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10)),
                                                          
                                                        ],
                                                      ),
      
                      Divider(
            //height: 50,
            color: Colors.black,
            //thickness: 3,
            
          ),
              
                    //List view cre_loan from firebase
                     Expanded(
                                          child: StreamBuilder<QuerySnapshot>(
                                            stream:FirebaseFirestore.instance
                                            .collection('coustermer_loan').doc(widget.nic).collection('loan_no').doc(widget.lNo).collection('time')
                                            .snapshots(),
                                            builder:(context,snapshot){
                        
                                              if(snapshot.hasError){
                                                return Text('Connection error');
                                              }
                                              if(snapshot.connectionState==ConnectionState.waiting){
                                                return Text('Loding...');
                                              }
                        
                                              var docs=snapshot.data!.docs;
                                              return ListView.builder(
                                                itemCount: docs.length,
                                                itemBuilder: (context,index){
                                                  return ListTile(
                                                         title:Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                            children: [
                                                              Column(
                                                                children: [
                                                                   Text(docs[index]['payment type'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10)),
                                                                   //Text(docs[index]['check no'].toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10)),
                                                                ],
                                                              ),
                                                               SizedBox(width: 30,),
                                                              Text(docs[index]['time'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10)),
                                                               SizedBox(width: 30,),
                                                              Text(docs[index]['recept no'].toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10)),
                                                               SizedBox(width: 30,),
                                                              Text('Rs.'+docs[index]['amount'].toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10)),
                                                             
                                                            ],
                                                          ),
                                                            
                                                        );
                                                  
                                                
                                                },
                                              );
                                            } ,)
                                            ),
             
      
                 SizedBox(height: 10,),
              
                  //Pay button function
                 
                  ],
                ),
              ),
      
              
      
              
          ],
         ),
        ),);
  }
}