import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credit_app/dashboard_screen.dart';
import 'package:credit_app/listmodel.dart';
import 'package:credit_app/loan_history_screen.dart';
import 'package:credit_app/search_customer_sreen.dart';
import 'package:flutter/material.dart';
import 'package:credit_app/model_bottom_sheet.dart';
import 'package:intl/intl.dart';


class LoanPayment extends StatefulWidget {

  late String name;
  late String nic;
  late String type;
  late String dur;
  late int tot;
  late int maxValue;
  late String date;
  late List model;

  LoanPayment(String name,String nic,String type,String dur,int tot,int maxValue, String date, List model){
    
    this.name=name;
    this.nic=nic;
    this.type=type;
    this.dur=dur;
    this.tot=tot;
    this.maxValue=maxValue;
    this.date=date;
    this.model=model;
  }

  @override
  State<LoanPayment> createState() => _LoanPaymentState();
}


class _LoanPaymentState extends State<LoanPayment> {

  List<ListModel> model=[];
  final GlobalKey<FormState> _formKeyAmount = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyCheck = GlobalKey<FormState>();
  double rate =10;
  late TextEditingController amount;
  late TextEditingController checkNo;
  int cAmount=0;
  int cNumber=0;
  //List<ListModel> model=[];
  late var balance;

   @override
  void initState() {
    super.initState();
    getBalance();
    amount=TextEditingController();
    checkNo=TextEditingController();
    //model.add(widget.model);
  } 

   @override
  void dispose(){
   super.dispose();
   amount.dispose();
   checkNo.dispose();
  }

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


    //Upload max value into px bill heder collection in firestore
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

updateBalance(int removebalance)async{
final upadatBalance=FirebaseFirestore.instance.collection('cre_loan').doc(widget.nic).collection('loan_type').doc(widget.type);
await upadatBalance.update({'balance':removebalance});
}
delete(String productId)async{
    await FirebaseFirestore.instance.collection('cre_loan').doc(widget.nic).collection('loan_type').doc(widget.type).collection('recept_number').doc(productId).delete();
    await FirebaseFirestore.instance.collection('cre_recept').doc(widget.date+'  '+widget.maxValue.toString()).collection('time').doc(productId).delete();
    await FirebaseFirestore.instance.collection('cre_all_payment').doc(productId).delete();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You have successfully deleted a product')));
                                    
}

    // void bottomSheet(BuildContext ctx){
    //    showModalBottomSheet(isScrollControlled: true,context: ctx, builder: (_){
    //       return BottomSheets(widget.name,widget.nic,widget.type,widget.dur,widget.tot,widget.maxValue,widget.date,widget.model); 
    //    },);
    // } 
  @override
  Widget build(BuildContext context) {
    String name=widget.name;
    String nic=widget.nic;
    String type=widget.type;
    int maxValue=widget.maxValue;
    //String date=widget.date;
   
    //String receptNo=widget.date+'  '+widget.maxValue.toString();
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
                                      Text('Loan type - '+widget.type,style: TextStyle(
                                                fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)),
                                      Text('Duration - '+widget.dur,style: TextStyle(
                                                fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)),
                                      Text('Total - '+widget.tot.toString(),style: TextStyle(
                                                fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black)),
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
                                                          Text('Rate',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10)),
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
                                            .collection('cre_loan').doc(nic).collection('loan_type').doc(type).collection('recept_number')
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
                                                  return  Card(
                                                    child: ListTile(
                                                         title:Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                            children: [
                                                              Text(docs[index]['payment type'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10)),
                                                                   //Text(docs[index]['check no'].toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10)),
                                                               SizedBox(width: 30,),
                                                              Text(docs[index]['time'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10)),
                                                               SizedBox(width: 30,),
                                                              Text(docs[index]['rate'].toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10)),
                                                               SizedBox(width: 30,),
                                                              Text('Rs.'+docs[index]['amount'].toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10)),
                                                             
                                                            ],
                                                          ),
                                                            trailing: SizedBox(
                                                              width: 20,
                                                              child:InkWell(
                                                                onTap: (){

                                                                    showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('You want to delete this product',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
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
                                              width: 20,
                                            ),
                 TextButton(onPressed: ()async{

                  Navigator.pop(context);
                
                  setState(() {
                                                                    balance-=docs[index]['amount'];
                                                                    //model.removeAt(index);
                                                                   
                                                                  });
                                                                    updateBalance(balance);
                                                                    delete(docs[index].id); 
                                                  
                  
                 },
                 child: Text('Yes'), 
                                             style: TextButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            elevation: 2,
                                            backgroundColor: Colors.blue),
                                            
                 
                 ),
                  SizedBox(
                  width: 30,
                  ),
              ],
            );
          }
                                                    );
                                                  




                                                                //  setState(() {
                                                                //     balance-=docs[index]['amount'];
                                                                //     model.removeAt(index);
                                                                   
                                                                //   });
                                                                //     updateBalance(balance);
                                                                //     delete(docs[index].id); 
                                                    
                                                                },
                                                                 child: Icon(Icons.delete,color: Colors.red)
                                                              ) ),
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
      
              Padding(
                padding:EdgeInsets.only(top:500),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                     height: 50,
                      width: 80,
                    child:TextButton(
                                          onPressed: ()async{ 
                                           

                                            showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('select one payment option',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
              actions: [
                
                   
                     TextButton(onPressed: (){
                                                    Navigator.pop(context);
                                                    openDiglog('Add new cash payment', 'Cash','',true); 


                                                }, child: Text('Cash payment'),
                                                style: TextButton.styleFrom(
                                                foregroundColor: Colors.white,
                                                elevation: 2,
                                                backgroundColor: Colors.blue),
                                                ),
                   
                 
                                            //  SizedBox(
                                            //   width: 20,
                                            // ),
                 TextButton(onPressed: ()async{

                  Navigator.pop(context);
                  openDiglog('Add new check payment', 'Check','Enter a check number',false); 
               
                                                  
                  
                 },
                 child: Text('Ckeck payment'), 
                                             style: TextButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            elevation: 2,
                                            backgroundColor: Colors.blue),
                                            
                 
                 ),
              
            
                  // SizedBox(
                  // width: 30,
                  // ),
              ],
            );
          }
                                                    );
                                                  


                                            // final pay=await openDiglog();
                                            // if(pay==null||pay.isEmpty)return;
                                            //     setState(() {
                                            //       this.cAmount=int.parse(pay);
                                            //     });
                                          //bottomSheet(context);

                                         
                                          }, 
                                          child: Text('Pay',style: TextStyle(fontSize: 18),), 
                                                       style: TextButton.styleFrom(
                                                      foregroundColor: Colors.white,
                                                      elevation: 2,
                                                      backgroundColor: Colors.blue),
                                                      ),
                  ),
                ),
              ),
      
                Padding(
                padding:EdgeInsets.only(top:700),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                     height: 50,
                      width: 100,
                    child:TextButton(
                                          onPressed: ()async{                                       
                                           Navigator.of(context).pushReplacement(MaterialPageRoute(
                                                                          builder: (_) => LoanHistory(name,nic,maxValue,widget.date,'',model),
                                                               ));
                                          }, 
                                          child: Text('Another loan',style: TextStyle(fontSize: 18),), 
                                                       style: TextButton.styleFrom(
                                                      foregroundColor: Colors.white,
                                                      elevation: 2,
                                                      backgroundColor: Colors.blue),
                                                      ),
                  ),
                ),
              )
                         
          ],
         ),
        ),
      ),
    );
  }

  Future<String?> openDiglog(String title, String paymentType,String hint,bool check)=>
    showDialog<String>(context: context, 
    builder:(context)=>
      AlertDialog(
      title: Text(title),
      content: Column(
          children: [
            Form(
              key: _formKeyAmount,
              child: TextFormField(
                autofocus: true,
                decoration: InputDecoration(hintText: 'Enter a payment'),
                controller: amount,
                keyboardType: TextInputType.number,
      
                validator: (text) {
                                            if (text!.isEmpty) {
                                              return 'This field can not be empty';
                                            }
                                            return null;
                                          },    
              ),
            ),
            Form(
              key: _formKeyCheck,
              child: TextFormField(
                readOnly: check,
                autofocus: true,
                decoration: InputDecoration(hintText:hint),
                controller: checkNo,
                keyboardType: TextInputType.number,
      
                validator: (text) {
                                            if (text!.isEmpty) {
                                              return 'This field can not be empty';
                                            }
                                            return null;
                                          },    
              ),
            ),
          ],
        ),
      
      actions: [
         Align(
          alignment: Alignment.center,
           child: TextButton(onPressed: ()async{
            uploadMaxValue();
            String currentDate=DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
            
            if(paymentType=='Cash'){
             if(_formKeyAmount.currentState!.validate()){
         
                                                  setState(() {
                                                    cAmount=int.parse(amount.text);
                                                    balance+=int.parse(amount.text);
                                                    //model.add(ListModel(amount:int.parse(amount.text), rate:rate , time:currentDate));
                                                  });   
                                                  
                                                 
         
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                      return Center(
                                                        child: CircularProgressIndicator(),
                                                        );
                                                        });
         
                                              Map<String,dynamic> dataToSave={
                                                      'time':currentDate,
                                                      'payment type':paymentType,
                                                      'rate':rate,
                                                      'amount':cAmount,
                                                      'loan type':widget.type
                                                      };
         
                                              // insert loan details into cre_loan collection
                                              try{
                                              final newDocument=FirebaseFirestore.instance.collection('cre_loan').doc(widget.nic).collection('loan_type').doc(widget.type).collection('recept_number').doc(currentDate+'  '+widget.maxValue.toString());
                                                      await newDocument.set(dataToSave);
         
                                              final newDocument2=FirebaseFirestore.instance.collection('cre_recept').doc(widget.date+'  '+widget.maxValue.toString()).collection('time').doc(currentDate+'  '+widget.maxValue.toString());
                                                      await newDocument2.set(dataToSave);

                                              final newDocument3=FirebaseFirestore.instance.collection('cre_all_payment').doc(widget.nic).collection('time').doc(currentDate+'  '+widget.maxValue.toString());
                                                      await newDocument3.set(dataToSave);
         
                                              // update balance into cre_loan collection
                                              final upadatBalance=FirebaseFirestore.instance.collection('cre_loan').doc(widget.nic).collection('loan_type').doc(widget.type);
                                                      await upadatBalance.update({'balance':balance});
         
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
                                               Navigator.pop(context);
         
                                                  amount.clear();
             }
           }
         
           if(paymentType=='Check'){
           
           if(_formKeyAmount.currentState!.validate()&&_formKeyCheck.currentState!.validate()){
         
                                                  setState(() {
                                                    cAmount=int.parse(amount.text);
                                                    cNumber=int.parse(checkNo.text);
                                                    balance+=int.parse(amount.text);
                                                    //model.add(ListModel(amount:int.parse(amount.text), rate:rate , time:currentDate));
                                                  });   
                                                  
                                                 
         
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                      return Center(
                                                        child: CircularProgressIndicator(),
                                                        );
                                                        });
         
                                              Map<String,dynamic> dataToSave={
                                                      'time':currentDate,
                                                      'payment type':paymentType,
                                                      'rate':rate,
                                                      'amount':cAmount,
                                                      'loan type':widget.type
                                                      };
         
                                              // insert loan details into cre_loan collection
                                              try{
                                              final newDocument=FirebaseFirestore.instance.collection('cre_loan').doc(widget.nic).collection('loan_type').doc(widget.type).collection('recept_number').doc(currentDate+'  '+widget.maxValue.toString());
                                                      await newDocument.set(dataToSave);
         
                                              final newDocument2=FirebaseFirestore.instance.collection('cre_recept').doc(widget.date+'  '+widget.maxValue.toString()).collection('time').doc(currentDate+'  '+widget.maxValue.toString());
                                                      await newDocument2.set(dataToSave);

                                              final newDocument3=FirebaseFirestore.instance.collection('cre_all_payment').doc(widget.nic).collection('time').doc(currentDate+'  '+widget.maxValue.toString());
                                                      await newDocument3.set(dataToSave);
         
                                              // update balance into cre_loan collection
                                              final upadatBalance=FirebaseFirestore.instance.collection('cre_loan').doc(widget.nic).collection('loan_type').doc(widget.type);
                                                      await upadatBalance.update({'balance':balance});
         
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
                                               Navigator.pop(context);
         
                                                  amount.clear();
                                                  checkNo.clear();
             }
         
           }
                                              }, child: Text('Pay'),
                                              style: TextButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              elevation: 2,
                                              backgroundColor: Colors.blue),
                                              ),
         ),
      ],
      )
    );
  }



  // showDialog(
  //         context: context,
  //         builder: (context) {
  //           return AlertDialog(
  //             content: Text('You want to delete this product',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
  //             actions: [
  //                TextButton(onPressed: (){
  //                                               Navigator.pop(context);
  //                                           }, child: Text('No'),
  //                                           style: TextButton.styleFrom(
  //                                           foregroundColor: Colors.white,
  //                                           elevation: 2,
  //                                           backgroundColor: Colors.blue),
  //                                           ),
  //                                            SizedBox(
  //                                             width: 20,
  //                                           ),
  //                TextButton(onPressed: ()async{

  //                 Navigator.pop(context);
                
  //                 setState(() {
                                                                   
  //                                                                   widget.model.removeAt(index);
                                                                   
  //                                                                 });
  //                                                                   updateBalance(docs[index]['amount']);
  //                                                                   delete(docs[index].id); 
                                                  
                                                  
                  
  //                },
  //                child: Text('Yes'), 
  //                                            style: TextButton.styleFrom(
  //                                           foregroundColor: Colors.white,
  //                                           elevation: 2,
  //                                           backgroundColor: Colors.blue),
                                            
                 
  //                ),
  //                 SizedBox(
  //                 width: 30,
  //                 ),
  //             ],
  //           );
  //         }
  //                                                   );
                                                  