import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class BottomSheets extends StatefulWidget {

  late String nic;
  late String type;
  late String tot;
  late var balance;

   BottomSheets(String nic,String type,String tot,var balance){
     
     this.nic=nic;
     this.type=type;
     this.tot=tot;
     this.balance=balance;
   }

  @override
  State<BottomSheets> createState() => _BottomSheetsState();
}

class _BottomSheetsState extends State<BottomSheets> {

    String date=DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    double rate =10;
    late TextEditingController amount=TextEditingController();
    double cAmount=0;

  @override
  Widget build(BuildContext context) {
    String nic=widget.nic;
    String type=widget.type;
    String tot=widget.tot;
    var balance=widget.balance;

    //Model Bottom Sheet
    return Padding(
      padding: EdgeInsets.only(bottom:MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          width: double.infinity,
          height: 400,
          padding: EdgeInsets.all(20),
          child: Column(
            children: [

              Text('Total - '+tot,style: TextStyle(
                                              fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black)),
              Text('Balance - $balance',style: TextStyle(
                                              fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black)),

              Text('Date  $date',
                                              style: TextStyle(
                                              fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                //color: Colors.blueAccent
                                                )),
              Text('Rate  $rate %',
                                              style: TextStyle(
                                              fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                //color: Colors.blueAccent
                                                )),
              TextField(
                keyboardType: TextInputType.number,
                controller:amount,
                decoration: InputDecoration(labelText: 'Amount',),
              ),

               SizedBox(height: 10,),
       
              //Pay button

              TextButton(
                                            onPressed: ()async{ 

                                              setState(() {
                                                cAmount=double.parse(amount.text);
                                              });   
 

                                               showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                    return Center(
                                                      child: CircularProgressIndicator(),
                                                      );
                                                      });

                                            Map<String,dynamic> dataToSave={
                                                    'amount':cAmount,
                                                    'rate':rate,
                                                    'time':date,
                                                    };

                                            // insert loan details into cre_loan collection
                                            try{
                                            final newDocument=FirebaseFirestore.instance.collection('cre_loan').doc(nic).collection('loan_type').doc(type).collection('loan_payment').doc(date);
                                                    await newDocument.set(dataToSave);

                                            // update balance into cre_loan collection
                                            final upadatBalance=FirebaseFirestore.instance.collection('cre_loan').doc(nic).collection('loan_type').doc(type);
                                                    await upadatBalance.update({'balance':balance+cAmount});

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
                                          
                                              child: Text('Payment is Successfull:')),
                                          
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                      ));
                                            }on FirebaseFirestore catch (e){
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
                                                 e.toString())),
                                        ),
                                         behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                          )
                                          );
                                            }
                                               await Future.delayed(Duration(seconds: 1),(){
                                     
                                      setState(() {
                                        amount.clear();
                                         //balance+=cAmount;
                                      });
                                    });
                                     Navigator.pop(context);
                                            }, 

                                         
                                            child: Text('Pay',style: TextStyle(fontSize: 18),), 
                                                         style: TextButton.styleFrom(
                                                        foregroundColor: Colors.white,
                                                        elevation: 2,
                                                        backgroundColor: Colors.blue),),
            ]
            ),
        ),
    );
  }
}
