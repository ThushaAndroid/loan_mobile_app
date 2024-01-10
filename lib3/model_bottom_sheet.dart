import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credit_app/listmodel.dart';
import 'package:credit_app/loan_payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class BottomSheets extends StatefulWidget {

  late String name;
  late String nic;
  late String type;
  late String dur;
  late int tot;
  late int maxValue;
  late String date;
  late List model;
  //late var balance;

   BottomSheets(String name,String nic,String type,String dur,int tot, int maxValue, String date,List model){
     
    this.name=name;
    this.nic=nic;
    this.type=type;
    this.dur=dur;
    this.tot=tot;
    this.maxValue=maxValue;
    this.date=date;
    this.model=model;
    //this.balance=balance;
   }

  @override
  State<BottomSheets> createState() => _BottomSheetsState();
}

class _BottomSheetsState extends State<BottomSheets> {

   late var balance;
    List<ListModel> model=[];
    String currentDate=DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    final GlobalKey<FormState> _formKeyAmount = GlobalKey<FormState>();
    double rate =10;
    late TextEditingController amount=TextEditingController();
    int cAmount=0;

//Upload max value into px bill heder collection in firestore
  uploadMaxValue()async{
    int maxNo=widget.maxValue;
    String maxId=widget.maxValue.toString();
    String date=widget.date;
    //String nowDate=widget.date;
   if(maxId.isNotEmpty){
    final newDocument = FirebaseFirestore.instance.collection('cre_recept_number').doc(date+'  '+maxId);
    final newReceptNumber={'recept_number':maxNo};

    await newDocument.set(newReceptNumber);
   }else {
    
    Center(child: Text('Something went wrong'));
  }
  }

 

   getBalance()async{
     setState(() {
    DocumentReference documentRef = FirebaseFirestore.instance.collection('cre_loan').doc(widget.nic).collection('loan_type').doc(widget.type);
    documentRef.get().then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    balance = data['balance'];
  } else {
    balance=0;
    print('Document does not exist');
  }
}).catchError((error) {
  balance=0;
  print('Error getting document: $error');
});
    });
  }

  @override
  void initState() {
    super.initState();
    getBalance();
  }

  @override
  Widget build(BuildContext context) {
    String nic=widget.nic;
    String type=widget.type;
    int tot=widget.tot;
    //int balance=widget.bal;
    String date=widget.date;
    int maxValue=widget.maxValue;

    //Model Bottom Sheet
    return Padding(
      padding: EdgeInsets.only(bottom:MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          width: double.infinity,
          height:300,
          padding: EdgeInsets.all(20),
          child: Column(
            children: [

              Text('Total - '+tot.toString(),style: TextStyle(
                                              fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black)),
              // Text('Balance - ${balance+cAmount}',style: TextStyle(
              //                                 fontSize: 12,
              //                                   fontWeight: FontWeight.bold,
              //                                   color: Colors.black)),

              Text('Date  $currentDate',
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
              Form(
                  key: _formKeyAmount,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller:amount,
                  decoration: InputDecoration(labelText: 'Amount',),

                   validator: (text) {
                                      if (text!.isEmpty) {
                                        return 'This field can not be empty';
                                      }
                                      return null;
                                    },                                              
                                    ),
                ),
                
              

               SizedBox(height: 10,),
       
              //Pay button

              TextButton(
                                            onPressed: ()async{ 
                                              uploadMaxValue();
                                              setState(() {

                                                if(_formKeyAmount.currentState!.validate()){
                                                    cAmount=int.parse(amount.text);
                                                     model.add(ListModel(amount:int.parse(amount.text), rate:rate , time:currentDate));
                                                    //balance+=double.parse(amount.text);
                                                }
                                                
                                                //amount.clear();
                                              
                                              
                                              });   
 
                                              if(amount.text.isNotEmpty && rate!=0 && currentDate.isNotEmpty){
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
                                                    'time':currentDate,
                                                    };

                                            // insert loan details into cre_loan collection
                                            try{
                                            final newDocument=FirebaseFirestore.instance.collection('cre_loan').doc(nic).collection('loan_type').doc(type).collection('recept_number').doc(currentDate+'  '+maxValue.toString());
                                                    await newDocument.set(dataToSave);

                                            final newDocument2=FirebaseFirestore.instance.collection('cre_recept').doc(date+'  '+maxValue.toString()).collection('time').doc(currentDate+'  '+maxValue.toString());
                                                    await newDocument2.set(dataToSave);

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
                                             Navigator.of(context).pushReplacement(MaterialPageRoute(
                                                                        builder: (_) => LoanPayment(widget.name,widget.nic,widget.type,widget.dur,widget.tot,widget.maxValue,widget.date,model),
                                                             ));
                                            // Navigator.pop(context);
                                            }
                                    //            await Future.delayed(Duration(seconds: 1),(){
                                     
                                    //   setState(() {
                                    //     amount.clear();
                                    //      //balance+=cAmount;
                                    //   });
                                    // });
                                    
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
