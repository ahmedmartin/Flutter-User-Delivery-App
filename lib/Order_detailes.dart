import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ra7al_seller/classies/order.dart';
import 'package:ra7al_seller/classies/notfication.dart';
import 'package:intl/intl.dart';


class Order_detailes extends StatefulWidget{


  order  my_order;

  Order_detailes(this.my_order);

  @override
  State<StatefulWidget> createState() {
    return _Order_detailes(this.my_order);
  }

}

class _Order_detailes extends State<Order_detailes>{


  order  my_order;
  String user_name;
  bool run_circularBrogresbar = false;
  bool no_delivery_id=false;
  bool no_comment=false;
  TextEditingController comment_controller = TextEditingController();

  _Order_detailes(this.my_order);

  List <notfication> notfication_list = [];


  @override
  Widget build(BuildContext context) {

    notfication_list = my_order.chat;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(my_order.cust_name ,style: TextStyle(fontSize: 25,color: Colors.black)),
                  Text('  : اسم العميل' ,style: TextStyle(fontSize: 25,color: Colors.black,fontWeight: FontWeight.bold)),
                  Container(width: 10,)
                ],
              ),

              Container(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(my_order.cust_phone,style: TextStyle(fontSize: 25,color: Colors.black),),
                  Text('  : التليفون',style: TextStyle(fontSize: 25,color: Colors.black,fontWeight: FontWeight.bold),),
                  Container(width: 10,)
                ],

              ),

              Container(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(my_order.cust_city,style: TextStyle(fontSize: 25,color: Colors.black),),
                  Text('  : المحافظه',style: TextStyle(fontSize: 25,color: Colors.black,fontWeight: FontWeight.bold),),
                ],
              ),

              Container(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(child: Text(my_order.cust_address,style: TextStyle(fontSize: 25,color: Colors.black),textAlign: TextAlign.right,)),
                  Text('  : العنوان',style: TextStyle(fontSize: 25,color: Colors.black,fontWeight: FontWeight.bold),),
                  Container(width: 10,)
                ],

              ),

              Container(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(my_order.cust_price,style: TextStyle(fontSize: 25,color: Colors.black),),
                  Text('  : المبلغ',style: TextStyle(fontSize: 25,color: Colors.black,fontWeight: FontWeight.bold),),
                ],
              ),

              Container(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(my_order.cust_delivery_price,style: TextStyle(fontSize: 25,color: Colors.black),),
                  Text('  : مبلغ الاستلام',style: TextStyle(fontSize: 25,color: Colors.black,fontWeight: FontWeight.bold),),
                ],

              ),

              Container(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(my_order.cust_delivery_fee + "+" + my_order.cust_delivery_fee_plus,style: TextStyle(fontSize: 25,color: Colors.black),),
                  Text(' : مبلغ الشحن + زياده على الشحن',style: TextStyle(fontSize: 25,color: Colors.black,fontWeight: FontWeight.bold),),
                  Container(width: 20,)
                ],
              ),

              Container(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(my_order.cust_status,style: TextStyle(fontSize: 25,color: Colors.black),),
                  Text('  : الحاله',style: TextStyle(fontSize: 25,color: Colors.black,fontWeight: FontWeight.bold),),
                ],
              ),

              Container(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(child: Text(my_order.cust_note,style: TextStyle(fontSize: 25,color: Colors.black),textAlign: TextAlign.right,),),
                  Text('  : ملاحظات',style: TextStyle(fontSize: 25,color: Colors.black,fontWeight: FontWeight.bold),),
                  Container(width: 20,)
                ],
              ),

              Container(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 RaisedButton(
                   child: Text('ارسال',style: TextStyle(fontSize: 30,color: Colors.white),textAlign: TextAlign.center,),
                   color: Colors.black,
                   shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(10.0),
                       side: BorderSide(color: Colors.black)
                   ),
                   onPressed: (){
                     if(my_order.delivery_id.isNotEmpty){
                       if(comment_controller.text.isNotEmpty) {
                         upload_comment();
                         setState(() {
                           no_comment = false;
                         });
                       }else
                         setState(() {
                           no_comment =true;
                         });
                     }else
                       setState(() {
                         no_delivery_id=true;
                       });

                   },
                 ),
                 Container(width: 10,),
                 Expanded(
                   child: TextFormField(decoration: InputDecoration(
                     hintText: "تعليق",
                     focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black,width: 2),
                         borderRadius: BorderRadius.all(Radius.circular(30))),
                     enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black,width: 2),
                         borderRadius: BorderRadius.all(Radius.circular(30))),
                     errorText:no_comment?'يجب كتابه ملاحظه او تعليق':no_delivery_id?'لم يتم تسليم الاوردر لمندوب':null,
                   ),
                     textAlign: TextAlign.center,
                     controller: comment_controller,
                     style: TextStyle(fontSize: 20,color: Colors.black),
                   ),
                 ),

               ],
              ),

              Container(height: 10,),
              Center(
                child: run_circularBrogresbar?CircularProgressIndicator(
                  backgroundColor: Colors.black,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                ):null,
              ),

              Container(
                height: 400,
                child: ListView.builder(
                    itemCount: notfication_list.length,
                    itemBuilder: (context,index){
                      return row_style(notfication_list[index].date,notfication_list[index].hour,notfication_list[index].sender_name,notfication_list[index].content);
                    }

                ),
              )


            ],
          ),
        ),
      )
    );
  }

  // upload comment to delivery and comp
  upload_comment(){
    print('try upload now..');
    run_circularBrogresbar=true;
    // first we get seller name from it's profile
    String uid = FirebaseAuth.instance.currentUser.uid.toString();
    FirebaseDatabase.instance.reference().child('sellers').child(uid).child('profile').child('name').
    once().then((DataSnapshot snapshot){
      if(snapshot.value!=null)
        user_name=snapshot.value;
    }).whenComplete(() {
      // second we upload comment tp delivery..
      FirebaseDatabase.instance.reference().child('deliveries').child(my_order.delivery_id).child('notfications').
      push().set(convert_comment_to_map());
      // ...then we  upload comment to comp
      FirebaseDatabase.instance.reference().child('companies').child(my_order.comp_id).child('orders').child(my_order.order_date).
      child(my_order.order_key).child('notfications').push().set({
        // convert comment to map for uploading it to comp
        'content':comment_controller.text,
        'date':DateFormat('dd-MM-yyyy').format(DateTime.now()),
        'hour':DateFormat('HH:mm:ss').format(DateTime.now()),
        'sender_name':user_name
      }).whenComplete((){
        // third when all data are uploaded we show comment to screen
        setState(() {
          notfication_list.add(notfication.chat(DateFormat('dd-MM-yy').format(DateTime.now()), DateFormat('HH:mm:ss').format(DateTime.now()),
              user_name, comment_controller.text));
          comment_controller.text='';
          run_circularBrogresbar = false;
        });
      });

    }).timeout(Duration(seconds: 10), onTimeout: (){
      print('soooo late');
      setState(() {
        run_circularBrogresbar = false;
      });
      show_no_internet_connection();
    });

  }

  show_no_internet_connection(){

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child:  AlertDialog(
                title:  Text('تحذير'),
                content:Text('تأكد من الاتصال بالانترنت ربما يكون الاتصال بالانترنت ضعيف او الجهاز غير متصل بالانترنت سوف نقوم بارسال الرساله عند توافر الانترنت') ,
          ));
          });
  }

  // convert comment to map to upload it to delivery
 Map<String,dynamic> convert_comment_to_map(){
    return {
    'comp_id':my_order.comp_id,
    'content':comment_controller.text,
    'cust_name':my_order.cust_name,
    'cust_phone':my_order.cust_phone,
    'date':DateFormat('dd-MM-yy').format(DateTime.now()),
    'hour':DateFormat('HH:mm:ss').format(DateTime.now()),
    'order_date':my_order.order_date,
    'order_key':my_order.order_key,
    'sender_name':user_name
    };
  }

  Widget row_style(date,houre,sender,content){
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 10,

        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [

                // sender notfication detailes\\
                Container(child: Text("  "+date+"  ",style: TextStyle(color: Colors.black,fontSize: 15),textAlign: TextAlign.end,)),
                Container(child: Text("  "+houre+"  ",style: TextStyle(color: Colors.black,fontSize: 15),textAlign: TextAlign.end,)),
                Container(child: Text("  "+sender+"  ",style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),textAlign: TextAlign.end,)),
                //-----------------------\\

                SizedBox(height: 40,),
                Center(child: Text(content,style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold))),
                SizedBox(height: 20,),
              ]
          ),
        ),

      ),
    );
  }

}
