import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:credit_app/model_bottom_sheet.dart';

class LoanPayment extends StatefulWidget {

  late String name;
  late String nic;
  late String type;
  late String dur;
  late String tot;

  LoanPayment(String name,String nic,String type,String dur,String tot){
    
    this.name=name;
    this.nic=nic;
    this.type=type;
    this.dur=dur;
    this.tot=tot;
  }

  @override
  State<LoanPayment> createState() => _LoanPaymentState();
}

class _LoanPaymentState extends State<LoanPayment> {

  late var balance;

   @override
  void initState() {
    super.initState();
    getBalance();
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

    void bottomSheet(BuildContext ctx){
       showModalBottomSheet(isScrollControlled: true,context: ctx, builder: (_){
          return BottomSheets(widget.nic,widget.type,widget.tot,balance); 
       },);
    } 
  @override
  Widget build(BuildContext context) {
    String name=widget.name;
    String nic=widget.nic;
    String type=widget.type;
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
                                    Text('Loan type - '+widget.type,style: TextStyle(
                                              fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black)),
                                    Text('Duration - '+widget.dur,style: TextStyle(
                                              fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black)),
                                    Text('Total - '+widget.tot,style: TextStyle(
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
                                                        Text('Date',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10)),
                                                        SizedBox(width: 50,),
                                                        Text('Rate',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10)),
                                                        SizedBox(width: 50,),
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
                                          .collection('cre_loan').doc(nic).collection('loan_type').doc(type).collection('loan_payment')
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
                                                return  ListTile(
                                                     title:Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                          Text(docs[index]['time'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10)),
                                                           SizedBox(width: 50,),
                                                          Text(docs[index]['rate'].toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10)),
                                                           SizedBox(width: 50,),
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

            Padding(
              padding:EdgeInsets.only(top:500),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                   height: 50,
                    width: 80,
                  child:TextButton(
                                        onPressed: ()async{                                       
                                        bottomSheet(context);
                                        }, 
                                        child: Text('Pay',style: TextStyle(fontSize: 18),), 
                                                     style: TextButton.styleFrom(
                                                    foregroundColor: Colors.white,
                                                    elevation: 2,
                                                    backgroundColor: Colors.blue),),
                ),
              ),
            )
                       
        ],
       ),
      ),
    );
  }
}