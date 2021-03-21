import 'dart:async';

import 'package:flutter/material.dart';
import 'Order_analysise.dart';
import 'Order_detailes.dart';
import 'package:ra7al_seller/classies/order.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'classies/Db_helper.dart';
import 'classies/notfication.dart';

class Order extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
       return _Order();
  }

}

class _Order extends State<Order>{

  List<String> comp_list = [];
  List<String> date_list = [];
  List<String> statuse_list = ['شحن على الراسل','استلم','مؤجل','مرتجع جزئى','لاغى','قيد التنفيذ'];
  List<order> all_orders = [];/*order('ahmed','01245235684','الجيزه','bbbjkbkjbjkbbkbkffjnfnk اكتوبر دريم لاند ','5248','5248','اتصل بالعميل واتس','مؤجل','40','0'),
                            order('mohamed','01145235874','الجيزه','المهندسين العجوزه','3258','3200','','لاغى','40','20'),
                            order('ibrahem','01254123658','البحيره','السمبلاوين الطباشى','1124','1100','','استلم','60','0'),
                            order('ibrahem','012542236854','الشرقيه','الزقازيق ش فروق','1124','1100','','مرتجع جزئى','60','0'),
                            order('ibrahem','012542236854','الشرقيه','الزقازيق ش فروق','1124','1100','','شحن على الراسل','60','0')];*/
  List<order> search_list = [];
  List<String> comp_id_list=[];
  //Map orders_key_map = {} ;
  DbHelper db;

  String selected_comp;
  String comp_id;
  String selected_date;
  String selected_statuse;
  TextEditingController search_controller = TextEditingController();
  String uid ;
  bool have_data=false;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = FirebaseAuth.instance.currentUser.uid.toString();

    db =DbHelper();
/*
    db.create_comp('comp_id', 'comp_name');
    db.create_comp('comp_id_1', 'comp_name1');
    db.create_comp('comp_id_2', 'comp_name2');*/
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(height: 30,),
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                    FutureBuilder <List>(
                    future:  db.allcomp(),
                    builder: (context,snapshot) {
                      if (snapshot.hasData) {
                        for (int i = 0; i < snapshot.data.length; i++) {
                          if (!comp_id_list.contains(snapshot.data[i]['comp_id'])) {
                            print(snapshot.data);
                            comp_list.add(snapshot.data[i]['comp_name']);
                            comp_id_list.add(snapshot.data[i]['comp_id']);
                          }
                        }
                        return DropdownButton(
                            hint: Text('اختار الشركه',
                              style: TextStyle(
                                  fontSize: 20, color: Colors.black),),
                            items: comp_list.map((comp) =>
                                DropdownMenuItem <String>(child: Text(comp,
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                  textAlign: TextAlign.center,),
                                  value: comp,)).toList(),
                            value: selected_comp,
                            onChanged: (value) {
                              setState(() {
                                selected_comp = value;
                                comp_id = comp_id_list[comp_list.indexOf(selected_comp)];
                                get_dates(comp_id);
                              });
                            });
                      }
                      return Container();
                    }),


                     DropdownButton(
                      hint: Text('اختار التاريخ',style: TextStyle(fontSize: 20,color: Colors.black),),
                        items: date_list.map((date) => DropdownMenuItem <String>(child: Text(date,style: TextStyle(fontSize: 20,color: Colors.black),textAlign: TextAlign.end,),
                          value: date,)).toList(),
                        value: selected_date ,
                        onChanged: (value){
                          setState(() {
                            selected_date = value;
                            get_all_orders();
                          });
                        }),

                ],
              ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    border: Border.all(
                        color:  Colors.black, style: BorderStyle.solid, width: 2),
                  ),
                  child: DropdownButton(
                      hint: Text('اختار الحاله',style: TextStyle(fontSize: 20,color: Colors.black),),
                      items: statuse_list.map((statuse) => DropdownMenuItem <String>(child: Text(statuse,style: TextStyle(fontSize: 20,color: Colors.black),textAlign: TextAlign.center,),
                        value: statuse,)).toList(),
                      value: selected_statuse ,
                      onChanged: (value){
                        setState(() {
                          selected_statuse = value;
                          search_list.clear();
                          all_orders.forEach((element) {
                            if(element.cust_status.contains(value)&&(element.cust_name.contains(search_controller.text)||element.cust_phone.contains(search_controller.text)))
                              search_list.add(element);
                          });
                        });
                      }),
                ),

                SizedBox(width: 10,),

                Flexible(
                  child: TextFormField(
                    controller: search_controller,
                    decoration: InputDecoration(hintText: ' الاسم, التليفون',
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black,width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black,width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      suffixIcon: Icon(Icons.search,color: Colors.black,size: 30,),
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20,color: Colors.black),
                    onChanged: (value){
                      setState(() {
                        search_list.clear();
                        all_orders.forEach((element) {
                          if((element.cust_name.contains(search_controller.text)||element.cust_phone.contains(search_controller.text))&&(selected_statuse==null||element.cust_status.contains(selected_statuse)))
                            search_list.add(element);
                        });
                      });
                    },
                  ),
                ),

              ],
            ),


           Expanded(
             child: have_data?
                 // check if it have orders show it if else show image
              ListView.builder(
               itemCount: search_list.length,
               itemBuilder: (context,index){
                 return GestureDetector(
                   child: Row_style(index,search_list[index].cust_name,search_list[index].cust_phone,search_list[index].cust_address,search_list[index].cust_note,
                       search_list[index].cust_price,search_list[index].cust_city,search_list[index].cust_delivery_fee,search_list[index].cust_delivery_price,
                       search_list[index].cust_status,search_list[index].cust_delivery_fee_plus),
                   onTap: (){
                     Navigator.push(context,MaterialPageRoute(builder: (context)=> Order_detailes(search_list[index])));
                   },
                 );
               },
             )
             // if it doesn't have orders show image
            : Image(image:NetworkImage('https://www.jonmgomes.com/wp-content/uploads/2020/03/Magnifying-Glass-Research-Icon.gif')),
           ),


            RaisedButton(
              onPressed: (){
                if(all_orders.length!=0)
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> Order_analysise(all_orders,get_mony[selected_date])));

              },
              child: Text('تحليل البيانات',style: TextStyle(fontSize: 30,color: Colors.white),),
              color: Colors.black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: Colors.black)
              ),
            )

          ],
        ),
      ),
    );

  }

  Map get_mony={};

  get_dates(comp_id){
    FirebaseDatabase.instance.reference().child('sellers').child(uid).child('orders').child(comp_id).once().then((DataSnapshot snapshot){
      if(snapshot.value!=null){
        print(snapshot.value);
        Map m = snapshot.value;
        get_mony = m;
        date_list.clear();
        m.forEach((key, value) {
          setState(() {
            date_list.add(key);
          });
        });
        //print(orders_key_map);
        print(date_list);
      }
    });
  }



  get_all_orders(){
  FirebaseDatabase.instance.reference().child('companies').child(comp_id).child('orders').child(selected_date)
      .orderByChild('seller_id').startAt(uid).once().then((DataSnapshot snapshot){
        if(snapshot.value!=null){
           Map map =snapshot.value;
           all_orders.clear();
           search_list.clear();
           map.forEach((key, value) {
             List<notfication> notfi = [];
             try {
               value['notfications'].values.forEach((element) {
                 notfi.add(notfication.chat(
                     element['date'], element['hour'], element['sender_name'],
                     element['content']));
               });
             }catch (e){
               print('hereee');
             }
             order o = order(value['cust_name'], value['cust_phone'], value['cust_city'], value['cust_address'],
                 value['cust_price'], value['cust_delivery_price'], value['cust_note'], value['cust_status'], value['cust_delivery_fee'],
                 value['cust_delivery_fee_plus'], notfi, key, value['delivery_id'],selected_date,comp_id);
                   all_orders.add(o);
           });

           setState(() {
             search_list.addAll(all_orders);
             have_data=true;
           });

        }
  });

 /* Timer timerrr ;
   timerrr= Timer.periodic(Duration(seconds: 5), (timer) {
      if(selected_date=='date_1') {
        timer.cancel();
        timerrr.cancel();
        print('hereee');
      }
      print(DateTime.now());
    });*/
  }

  Widget Row_style(index,cust_name,cust_phone,cust_address,cust_note,cust_price,cust_city,cust_delivery_fee,cust_delivery_price,cust_status,delivery_price_plus){

  return Padding(padding: EdgeInsets.all(10),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 10,
        shadowColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipOval(
                    child: Container(
                      width: 90,
                      height: 70,
                      //decoration: BoxDecoration(shape: BoxShape.circle ,),
                      child:Center(child: Text(cust_status,style: TextStyle(fontSize: 20,color: Colors.black),textAlign: TextAlign.center,)),
                      color: cust_status== statuse_list[0]? Colors.red :
                      cust_status== statuse_list[1]? Colors.green:
                      cust_status== statuse_list[2]? Colors.yellow:
                      cust_status== statuse_list[3]? Colors.orange:
                      cust_status== statuse_list[4]? Colors.redAccent:Colors.white,

                    ),
                  ),
                  Text(cust_name , style: TextStyle(fontSize: 20,color: Colors.black),),
                ],
              ),

              //--------------------------------------------------------------------------------

              Container(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Text(cust_phone , style: TextStyle(fontSize: 20,color: Colors.black),),
                  Text(cust_city, style: TextStyle(fontSize: 20,color: Colors.black),textAlign: TextAlign.center,),
                ],
              ),

              //---------------------------------------------------------------------------------

              Container(height: 10,),
              Text(cust_address,style: TextStyle(fontSize: 20,color: Colors.black),),

              Container(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Text(cust_delivery_fee +"+"+delivery_price_plus , style: TextStyle(fontSize: 20,color: Colors.black),),
                  Text(cust_delivery_price, style: TextStyle(fontSize: 20,color: Colors.black),textAlign: TextAlign.center,),
                  Text(cust_price, style: TextStyle(fontSize: 20,color: Colors.black),textAlign: TextAlign.center,),
                ],
              ),
              Container(height: 10,),
              Text(cust_note,style: TextStyle(fontSize: 20,color: Colors.black),),

              //-----------------------------------------------------------------------------------------
            ],

    ),
        ),
      ),
    );
  }

}