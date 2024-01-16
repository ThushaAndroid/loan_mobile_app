import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credit_app/dashboard_screen.dart';
import 'package:credit_app/listmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';


class LoanPayment extends StatefulWidget {

  late String name;
  late String nic;
  // late String type;
  // late String dur;
  // late int tot;
  late int maxValue;
  late String date;
  late List model;

  LoanPayment(String name,String nic,int maxValue, String date, List model){
    
    this.name=name;
    this.nic=nic;
    // this.type=type;
    // this.dur=dur;
    // this.tot=tot;
    this.maxValue=maxValue;
    this.date=date;
    this.model=model;
  }

  @override
  State<LoanPayment> createState() => _LoanPaymentState();
}


class _LoanPaymentState extends State<LoanPayment> {

  String inputText = "";
  List<ListModel> model=[];
  final GlobalKey<FormState> _formKeyAmount = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyCheck = GlobalKey<FormState>();
  double rate =10;
  late TextEditingController amount;
  late TextEditingController checkNo;
  int cAmount=0;
  int cNumber=0;
  int loanNo=0;
  int count=0;
  
  num tAmount=0;
  late var balance;

   @override
  void initState() {
    super.initState();
    //getBalance();
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
  getBalance(int lno)async{
     setState(() {
    DocumentReference documentRef = FirebaseFirestore.instance.collection('cre_loan').doc(widget.nic).collection('loan_no').doc(lno.toString());
    documentRef.get().then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    balance = data['Balance'];
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

updateBalance(int lno,int removebalance)async{
final upadatBalance=FirebaseFirestore.instance.collection('cre_loan').doc(widget.nic).collection('loan_no').doc(lno.toString());
await upadatBalance.update({'Balance':removebalance});
}
delete(int lno,String productId)async{
    await FirebaseFirestore.instance.collection('cre_loan').doc(widget.nic).collection('loan_no').doc(lno.toString()).collection('recept_number').doc(productId).delete();
    await FirebaseFirestore.instance.collection('cre_recept').doc(widget.date+'  '+widget.maxValue.toString()).collection('time').doc(productId).delete();
    await FirebaseFirestore.instance.collection('cre_all_payment').doc(widget.nic).collection('time').doc(productId).delete();
    await FirebaseFirestore.instance.collection('coustermer_loan').doc(widget.nic).collection('loan_no').doc(lno.toString()).collection('time').doc(productId).delete();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You have successfully deleted a product')));
                                    
}

    // void bottomSheet(BuildContext ctx){
    //    showModalBottomSheet(isScrollControlled: true,context: ctx, builder: (_){
    //       return BottomSheets(widget.name,widget.nic,widget.type,widget.dur,widget.tot,widget.maxValue,widget.date,widget.model); 
    //    },);
    // } 
  @override
  Widget build(BuildContext context) {
    String nic=widget.nic;
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
          backgroundColor: Colors.white,
          appBar: AppBar(
           title:TextFormField(
                      keyboardType:TextInputType.number,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                    
                     border: InputBorder.none,
                      //filled: true,
                      hintText: 'Search loan number...',
                      hintStyle: TextStyle(color: Colors.white70)
                      ),
                       style: TextStyle(color: Colors.white),
                      onChanged: (val) {
                        setState(() {
                          inputText = val;
                        });
                      },
                    ),
          ),
           body: Stack(
          children: [ 

              Container(
                 height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blueGrey,Colors.white],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft)
                ),
              ),

               Container(
                height: double.infinity,
                width: double.infinity,
                 child: Padding(
                         padding: EdgeInsets.only(top: 10.0),
                         child: Expanded(
                                  child: Container(
                                    child: StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('cre_loan').doc(nic).collection('loan_number')
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
                                                          title: Text(data['loan_number'].toString(),
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis),
                                                          //subtitle: Text(data['loan_number'].toString()),
                                                              textColor: Colors.black,
                                                           onTap: (){
                                                                                                         
                                                         setState(() {
                                                          loanNo= data['loan_number'];
                                                         
                                                         });
                                                                                        
                                                                                              //           Navigator.of(context).push(MaterialPageRoute(
                                                                                              //             builder: (_) => OldBill(name,invoiceNo,date,total,count),
                                                                                              //  ));
                                                                                                      
                                                                 
                                                                                                      },
                                                                                                       );
                                                    
                                                    
                                                  }
                                                  if (data['loan_number'].toString()
                                                      .toString().toLowerCase()
                                                      .startsWith(inputText.toLowerCase())) {
                                                  return ListTile(
                                                          title: Text(data['loan_number'].toString(),
                                                              maxLines: 1,
                                                              overflow: TextOverflow.ellipsis),
                                                          //subtitle: Text(data['loan_number'].toString()),
                                                              textColor: Colors.black,
                                                           onTap: (){
                                                       
                                                         setState(() {
                                                          loanNo= data['loan_number'];
                                                         
                                                         });
                                                                                    
                                                                                          //           Navigator.of(context).push(MaterialPageRoute(
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
                       ),
               ),


            //Grey and White Box Backgroud
              Padding(
                 padding: EdgeInsets.only(top: 100.0),
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: BoxDecoration(
                                borderRadius:BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40)
                              ),
                              color: Colors.white,
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
                                        Text('Loan no - '+loanNo.toString(),style: TextStyle(
                                                  fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
                                        Text('Total - Rs.'+tAmount.toString(),style: TextStyle(
                                                  fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black)),
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
                                                            Text('Loan no',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10)),
                                                            SizedBox(width: 10,),
                                                            Text('Paid amount',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10)),
                                                            
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
                                              .collection('cre_recept').doc(widget.date+'  '+widget.maxValue.toString()).collection('time')
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
                                                                Text(docs[index]['loan no'].toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10)),
                                                                 SizedBox(width: 30,),
                                                                Text('Rs.'+docs[index]['amount'].toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10)),
                                                               
                                                              ],
                                                            ),
                                                              trailing: SizedBox(
                                                                width: 20,
                                                                child:InkWell(
                                                                  onTap: (){
                                                                    getBalance(docs[index]['loan no']);
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
                                                                      model.removeAt(index);
                                                                      count--;
                                                                       tAmount-=docs[index]['amount'];
                                                                      //totalAmount-=tAmount;
                                                                    });
                                                                      updateBalance(docs[index]['loan no'],balance);
                                                                      delete(docs[index]['loan no'],docs[index].id); 
                                                    
                    
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
              ),
      
              Padding(
                padding:EdgeInsets.only(top:400),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                     height: 50,
                      width: 80,
                    child:TextButton(
                                          onPressed: ()async{ 
                                           if(loanNo==0){

                                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Select loan number')));   

                                           }else{
                                              getBalance(loanNo);

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
                                           }


                                         
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
                padding:EdgeInsets.only(top:600),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                     height: 50,
                      width: 100,
                    child:TextButton(
                                          onPressed: ()async{  

                                            printDoc();                                     
                                          //  Navigator.of(context).pushReplacement(MaterialPageRoute(
                                          //                                 builder: (_) => LoanHistory(name,nic,maxValue,widget.date,'',model),
                                          //                      ));
                                          }, 
                                          child: Text('Print',style: TextStyle(fontSize: 18),), 
                                                       style: TextButton.styleFrom(
                                                      foregroundColor: Colors.white,
                                                      elevation: 2,
                                                      backgroundColor: Colors.blue),
                                                      ),
                  ),
                ),
              ),

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
                                                    model.add(ListModel(loanNo: loanNo, time: currentDate, pamentType: paymentType, rate: rate, amount: int.parse(amount.text)));
                                                    count++;
                                                    tAmount+=int.parse(amount.text);
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
                                                      'loan no':loanNo,
                                                      'recept no':widget.maxValue
                                                      };
         
                                              // insert loan details into cre_loan collection
                                              try{
                                              final newDocument=FirebaseFirestore.instance.collection('cre_loan').doc(widget.nic).collection('loan_no').doc(loanNo.toString()).collection('recept_number').doc(currentDate+'  '+widget.maxValue.toString());
                                                      await newDocument.set(dataToSave);
         
                                              final newDocument2=FirebaseFirestore.instance.collection('cre_recept').doc(widget.date+'  '+widget.maxValue.toString()).collection('time').doc(currentDate+'  '+widget.maxValue.toString());
                                                      await newDocument2.set(dataToSave);

                                              // final newDocument3=FirebaseFirestore.instance.collection('cre_all_payment').doc(widget.nic).collection('time').doc(currentDate+'  '+widget.maxValue.toString());
                                              //         await newDocument3.set(dataToSave);

                                              final newDocument4=FirebaseFirestore.instance.collection('coustermer_loan').doc(widget.nic).collection('loan_no').doc(loanNo.toString()).collection('time').doc(currentDate+'  '+widget.maxValue.toString());
                                                      await newDocument4.set(dataToSave);
         
                                              // update balance into cre_loan collection
                                              final upadatBalance=FirebaseFirestore.instance.collection('cre_loan').doc(widget.nic).collection('loan_no').doc(loanNo.toString());
                                                      await upadatBalance.update({'Balance':balance});
         
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
                                            
                                                child: Text('Payment is Successfull')),
                                            
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
                                                    model.add(ListModel(loanNo: loanNo, time: currentDate, pamentType: paymentType, rate: rate, amount: int.parse(amount.text)));
                                                    count++;
                                                    tAmount+=int.parse(amount.text);
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
                                                      'loan no':loanNo,
                                                      'recept no':widget.maxValue
                                                      };
         
                                              // insert loan details into cre_loan collection
                                              try{
                                              final newDocument=FirebaseFirestore.instance.collection('cre_loan').doc(widget.nic).collection('loan_no').doc(loanNo.toString()).collection('recept_number').doc(currentDate+'  '+widget.maxValue.toString());
                                                      await newDocument.set(dataToSave);
         
                                              final newDocument2=FirebaseFirestore.instance.collection('cre_recept').doc(widget.date+'  '+widget.maxValue.toString()).collection('time').doc(currentDate+'  '+widget.maxValue.toString());
                                                      await newDocument2.set(dataToSave);

                                              // final newDocument3=FirebaseFirestore.instance.collection('cre_all_payment').doc(widget.nic).collection('time').doc(currentDate+'  '+widget.maxValue.toString());
                                              //         await newDocument3.set(dataToSave);

                                               final newDocument4=FirebaseFirestore.instance.collection('coustermer_loan').doc(widget.nic).collection('loan_no').doc(loanNo.toString()).collection('time').doc(currentDate+'  '+widget.maxValue.toString());
                                                      await newDocument4.set(dataToSave);
         
                                              // update balance into cre_loan collection
                                              final upadatBalance=FirebaseFirestore.instance.collection('cre_loan').doc(widget.nic).collection('loan_no').doc(loanNo.toString());
                                                      await upadatBalance.update({'Balance':balance});
         
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

     Future<void>printDoc()async{
   
      final doc=pw.Document();
      doc.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        
        build: (pw.Context context){
          
         return [
         pw.Column(children: [
    pw.Text('Credit App',
    style: pw.TextStyle(fontSize: 15.00,fontWeight: pw.FontWeight.bold)),
    pw.Text('Coustomer name -'+widget.name,
    style: pw.TextStyle(fontSize: 15.00,fontWeight: pw.FontWeight.bold)),
    pw.Text('Coustomer ID -'+widget.nic,
    style: pw.TextStyle(fontSize: 15.00,fontWeight: pw.FontWeight.bold)),
    pw.Text('Recept no -'+widget.maxValue.toString(),
    style: pw.TextStyle(fontSize: 15.00,fontWeight: pw.FontWeight.bold)),
    pw.Text('Date -'+widget.date,
    style: pw.TextStyle(fontSize: 15.00,fontWeight: pw.FontWeight.bold)),
 
    pw.SizedBox(height: 10),
    pw.Divider(
          //height: 50,
          color: PdfColor(0.1,0.1,0.1,0.1),
          thickness: 2,),
    pw.Container(
      color: PdfColor(0.1,0.4,0.9,0.1),
      width: double.infinity,
      height: 36.00,
      child: pw.Center(
        child: pw.Text(
          'Recept',
          style:pw.TextStyle(
            fontSize:15,
            fontWeight: pw.FontWeight.bold
          ),
        )
      )
    ),

    pw.Container(
      width: double.infinity,
      height: 36,
      child: pw.Padding(
        padding: pw.EdgeInsets.only(left: 10.0, right: 10.0),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('payment type',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 15,color: PdfColor(0.1,0.4,0.9,0.1))),
            pw.SizedBox(width: 10,),
            pw.Text('time',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 15,color: PdfColor(0.1,0.4,0.9,0.1))),
            pw.SizedBox(width: 10,),
            pw.Text('loan no',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 15,color: PdfColor(0.1,0.4,0.9,0.1))),
            pw.SizedBox(width: 10,),
            pw.Text('amount',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 15,color: PdfColor(0.1,0.4,0.9,0.1))),
          ]))
    ),

    for (var i = 0; i < count; i++)
        
              pw.Container(
             
                width: double.infinity,
                height: 36.00,
                child: pw.Padding(
                padding: pw.EdgeInsets.only(left: 20.0, right: 20.0),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children:[
                        pw.Text(
                              model[i].pamentType,
                              style: pw.TextStyle(
                                  fontSize: 15.00,
                                  fontWeight: pw.FontWeight.normal),
                            ),
                      
                      pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                    pw.SizedBox(width: 80,),
                     pw.Text(
                              model[i].time,
                              style: pw.TextStyle(
                                  fontSize: 15.00,
                                  fontWeight: pw.FontWeight.normal),
                            ),
                     pw.SizedBox(width: 80,),
                     pw.Text(
                             model[i].loanNo.toString(),
                              style: pw.TextStyle(
                                  fontSize: 15.00,
                                  fontWeight: pw.FontWeight.normal),
                            ),
                    pw.SizedBox(width: 80,),
                    pw.Text(
                              'Rs. ${model[i].amount}',
                              style: pw.TextStyle(
                                  fontSize: 15.00,
                                  fontWeight: pw.FontWeight.normal),
                            ),
                    ],
                  ),
                    ] )
                ),
              ),

              pw.Divider(
          //height: 50,
          color: PdfColor(0.1,0.1,0.1,0.1),
          thickness: 3,
          
        ),
 
     pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 25.0),
              child: pw.Container(
                width: double.infinity,
                height: 36.00,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text(
                     'Total amount - Rs. ${tAmount}',
                      style: pw.TextStyle(
                        fontSize: 15.00,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor(0.1,0.4,0.9,0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            

      pw.SizedBox(height: 15.00),
            pw.Text(
              "Thanks for choosing our service!",
              style: const pw.TextStyle(
                  color: PdfColor(0.5, 0.5, 0.5, 0.5), fontSize: 15.00),
            ),
            pw.SizedBox(height: 5.00),
            pw.Text(
              "Contact the branch for any clarifications.",
              style: const pw.TextStyle(
                  color: PdfColor(0.5, 0.5, 0.5, 0.5), fontSize: 15.00),
            ),
             pw.SizedBox(height: 5.00),
            pw.Text(
              "(C) Proxima Technologies",
              style: const pw.TextStyle(
                  color: PdfColor(0.5, 0.5, 0.5, 0.5), fontSize: 15.00),
            ),
            pw.SizedBox(height: 15.00),
          ],
        ),
        ];
        }));
        await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async=> doc.save());
  }
  }


