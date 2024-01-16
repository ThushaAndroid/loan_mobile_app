import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:credit_app/listmodel.dart';

class Print{

  // late List model;

  // Print(String cName,String cID,int rNo, String date, List model, int count){

  //   this.model=model;

  // }
  //  late List model;
  // //Print bill function
  // Future<void>printDoc(String cName,String cID,int rNo, String date, List model, int count)async{

  //   this.model=model;

  //     final doc=pw.Document();
  //     doc.addPage(pw.MultiPage(
  //       pageFormat: PdfPageFormat.a4,
        
  //       build: (pw.Context context){
          
  //        return [
  //        pw.Column(children: [
  //   pw.Text('Credit App',
  //   style: pw.TextStyle(fontSize: 15.00,fontWeight: pw.FontWeight.bold)),
  //   pw.Text('Coustomer name -'+cName!,
  //   style: pw.TextStyle(fontSize: 15.00,fontWeight: pw.FontWeight.bold)),
  //   pw.Text('Coustomer ID -'+cID,
  //   style: pw.TextStyle(fontSize: 15.00,fontWeight: pw.FontWeight.bold)),
  //   pw.Text('Recept no -'+rNo.toString(),
  //   style: pw.TextStyle(fontSize: 15.00,fontWeight: pw.FontWeight.bold)),
  //   pw.Text('Date -'+date,
  //   style: pw.TextStyle(fontSize: 15.00,fontWeight: pw.FontWeight.bold)),
 
  //   pw.SizedBox(height: 10),
  //   pw.Divider(
  //         //height: 50,
  //         color: PdfColor(0.1,0.1,0.1,0.1),
  //         thickness: 2,),
  //   pw.Container(
  //     color: PdfColor(0.1,0.4,0.9,0.1),
  //     width: double.infinity,
  //     height: 36.00,
  //     child: pw.Center(
  //       child: pw.Text(
  //         'Recept',
  //         style:pw.TextStyle(
  //           fontSize:15,
  //           fontWeight: pw.FontWeight.bold
  //         ),
  //       )
  //     )
  //   ),

  //   pw.Container(
  //     width: double.infinity,
  //     height: 36,
  //     child: pw.Padding(
  //       padding: pw.EdgeInsets.only(left: 10.0, right: 10.0),
  //       child: pw.Row(
  //         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //         children: [
  //           pw.Text('payment type',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 15,color: PdfColor(0.1,0.4,0.9,0.1))),
  //           pw.SizedBox(width: 10,),
  //           pw.Text('time',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 15,color: PdfColor(0.1,0.4,0.9,0.1))),
  //           pw.SizedBox(width: 10,),
  //           pw.Text('loan no',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 15,color: PdfColor(0.1,0.4,0.9,0.1))),
  //           pw.SizedBox(width: 10,),
  //           pw.Text('amount',style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 15,color: PdfColor(0.1,0.4,0.9,0.1))),
  //         ]))
  //   ),

  //   for (var i = 0; i < count; i++)
        
  //             pw.Container(
             
  //               width: double.infinity,
  //               height: 36.00,
  //               child: pw.Padding(
  //               padding: pw.EdgeInsets.only(left: 20.0, right: 20.0),
  //                 child: pw.Column(
  //                   crossAxisAlignment: pw.CrossAxisAlignment.start,
  //                   children:[
  //                       pw.Text(
  //                             model[i].,
  //                             style: pw.TextStyle(
  //                                 fontSize: 15.00,
  //                                 fontWeight: pw.FontWeight.normal),
  //                           ),
                      
  //                     pw.Row(
  //                   mainAxisAlignment: pw.MainAxisAlignment.end,
  //                   children: [
      
  //                    pw.Text(
  //                             'Rs.'+model[i].price,
  //                             style: pw.TextStyle(
  //                                 fontSize: 15.00,
  //                                 fontWeight: pw.FontWeight.normal),
  //                           ),
  //                    pw.SizedBox(width: 100,),
  //                    pw.Text(
  //                            'x'+ model[i].qty,
  //                             style: pw.TextStyle(
  //                                 fontSize: 15.00,
  //                                 fontWeight: pw.FontWeight.normal),
  //                           ),
  //                   pw.SizedBox(width: 100,),
  //                   pw.Text(
  //                             'Rs.'model[i].tatal,
  //                             style: pw.TextStyle(
  //                                 fontSize: 15.00,
  //                                 fontWeight: pw.FontWeight.normal),
  //                           ),
  //                   ],
  //                 ),
  //                   ] )
  //               ),
  //             ),

  //             pw.Divider(
  //         //height: 50,
  //         color: PdfColor(0.1,0.1,0.1,0.1),
  //         thickness: 3,
          
  //       ),
 
  //    pw.Padding(
  //             padding: const pw.EdgeInsets.symmetric(horizontal: 25.0),
  //             child: pw.Container(
  //               width: double.infinity,
  //               height: 36.00,
  //               child: pw.Row(
  //                 mainAxisAlignment: pw.MainAxisAlignment.end,
  //                 children: [
  //                   pw.Text(
  //                    'Total amount - Rs. ${widget.totalAmount}',
  //                     style: pw.TextStyle(
  //                       fontSize: 15.00,
  //                       fontWeight: pw.FontWeight.bold,
  //                       color: PdfColor(0.1,0.4,0.9,0.1),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //            pw.Padding(
  //             padding: const pw.EdgeInsets.symmetric(horizontal: 25.0),
  //             child: pw.Container(
  //               width: double.infinity,
  //               height: 36.00,
  //               child: pw.Row(
  //                 mainAxisAlignment: pw.MainAxisAlignment.end,
  //                 children: [
  //                   pw.Text(
  //                    'Total payment - Rs.${widget.totalBalance}',
  //                     style: pw.TextStyle(
  //                       fontSize: 15.00,
  //                       fontWeight: pw.FontWeight.bold,
  //                       color: PdfColor(0.1,0.4,0.9,0.1),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //            pw.Padding(
  //             padding: const pw.EdgeInsets.symmetric(horizontal: 25.0),
  //             child: pw.Container(
  //               width: double.infinity,
  //               height: 36.00,
  //               child: pw.Row(
  //                 mainAxisAlignment: pw.MainAxisAlignment.end,
  //                 children: [
  //                   pw.Text(
  //                    'Credit balance - Rs.${widget.totalCredit}',
  //                     style: pw.TextStyle(
  //                       fontSize: 15.00,
  //                       fontWeight: pw.FontWeight.bold,
  //                       color: PdfColor(0.1,0.4,0.9,0.1),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),


  //     pw.SizedBox(height: 15.00),
  //           pw.Text(
  //             "Thanks for choosing our service!",
  //             style: const pw.TextStyle(
  //                 color: PdfColor(0.5, 0.5, 0.5, 0.5), fontSize: 15.00),
  //           ),
  //           pw.SizedBox(height: 5.00),
  //           pw.Text(
  //             "Contact the branch for any clarifications.",
  //             style: const pw.TextStyle(
  //                 color: PdfColor(0.5, 0.5, 0.5, 0.5), fontSize: 15.00),
  //           ),
  //            pw.SizedBox(height: 5.00),
  //           pw.Text(
  //             "(C) Proxima Technologies",
  //             style: const pw.TextStyle(
  //                 color: PdfColor(0.5, 0.5, 0.5, 0.5), fontSize: 15.00),
  //           ),
  //           pw.SizedBox(height: 15.00),
  //         ],
  //       ),
  //       ];
  //       }));
  //       await Printing.layoutPdf(
  //         onLayout: (PdfPageFormat format) async=> doc.save());
  // }

}