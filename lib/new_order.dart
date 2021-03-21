import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:ra7al_seller/classies/order.dart';
import 'package:firebase_database/firebase_database.dart'; //for mobile app
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_db_web_unofficial/firebasedbwebunofficial.dart';  //for web app
import 'package:ra7al_seller/classies/Db_helper.dart';
class new_order extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _new_order();
  }

}

class _new_order extends State<new_order>{

  List<String> comp_list = [];
  List<String> comp_id_list =[];
  List<String> city = ['القاهرة','الجيزة','القليوبية','الإسكندرية','البحيرة','مطروح','الدقهليه','كفر الشيخ','الغربية','المنوفية','دمياط',
  	'بورسعيد','الإسماعيلية','السويس','الشرقية','بني سويف','المنيا','الفيوم','أسيوط' ,'سوهاج' ,'قنا','الأقصر','أسوان','الوادي الجديد','شمال سيناء','جنوب سيناء','البحر الأحمر'];
  String comp_selected ;
  String city_selected ;
  String user_id , comp_id;
  bool network_connection ;

  DbHelper db = new DbHelper();

  List<order> orders_list=[];


  TextEditingController controller_cust_name = TextEditingController();
  TextEditingController controller_cust_phone = TextEditingController();
  TextEditingController controller_cust_address = TextEditingController();
  TextEditingController controller_cust_price =TextEditingController();
  TextEditingController controller_cust_note=TextEditingController();


  @override
  Widget build(BuildContext context) {

    user_id = FirebaseAuth.instance.currentUser.uid.toString();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [



          Draw_form(),

          FutureBuilder <List>(
              future:  db.allOrders(),
              builder: (context,snapshot) {
                if (snapshot.hasData) {
                  orders_list.clear();
                  return SizedBox(
                      height: 400,
                      child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            // add orders from local database to orders_list
                            orders_list.add(order.new_order(snapshot.data[index]['cust_name'], snapshot.data[index]['cust_phone'],
                                snapshot.data[index]['cust_city'], snapshot.data[index]['cust_address'], snapshot.data[index]['cust_price'],
                                snapshot.data[index]['cust_note'], snapshot.data[index]['comp'],snapshot.data[index]['comp_id']));

                            return Row_style(index,snapshot.data[index]['cust_name'],snapshot.data[index]['cust_phone'],snapshot.data[index]['cust_address']
                                ,snapshot.data[index]['cust_note'],snapshot.data[index]['cust_price'],snapshot.data[index]['cust_city'],snapshot.data[index]['comp']);
                          }
                      )
                  );
                }else
                  return Container();
              }
          ),

            Container(height: 20,),
            RaisedButton(
                child: Text('ارسال الى الشركه',style: TextStyle(fontSize: 30,color: Colors.white),),
                color: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: Colors.black)
                ),
                onPressed: (){
                  if(orders_list.isNotEmpty){
                    
                        // Internet Present Case
                        for(order O in orders_list) {
                          FirebaseDatabase.instance.reference().child('companies').child(O.comp_id).child('waiting').child(user_id).push()
                              .set({
                            'cust_name': O.cust_name,
                            'cust_phone': O.cust_phone,
                            'cust_city': O.cust_city,
                            'cust_address': O.cust_address,
                            'cust_price': O.cust_price,
                            'cust_note': O.cust_note,
                          }).whenComplete((){
                            setState(() {
                              db.deleteorder(O.cust_phone, O.cust_name);
                              orders_list.remove(O);
                            });
                          }).timeout(Duration(seconds: 10),onTimeout: (){
                            show_no_internet_connection();
                          });
                        }

                    //...........................\\
                  }else
                    comp_container = false;
                }
                ),
            Container(height: 20,),
            
          ],
        ),
      )
    );

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

  Widget Row_style(index,cust_name,cust_phone,cust_address,cust_note,cust_price,cust_city,comp){

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 8,
      shadowColor: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [

            Text(comp,style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
            Container(height: 10,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(cust_price,style: TextStyle(fontSize: 20,color: Colors.black),),
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
            Text(cust_note,style: TextStyle(fontSize: 20,color: Colors.black),),

            //-----------------------------------------------------------------------------------------

            Container(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // button fro update row from list view
                RaisedButton(
                    child: Icon(Icons.update,color: Colors.white,size: 40,),
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        side: BorderSide(color: Colors.black)
                    ),
                    onPressed: (){

                      setState(() {
                        controller_cust_name.text = cust_name;
                        controller_cust_phone.text = cust_phone;
                        controller_cust_address.text= cust_address;
                        controller_cust_note.text = cust_note;
                        controller_cust_price.text = cust_price;
                        city_selected = cust_city;
                        comp_selected = comp;
                        comp_id= comp_id_list[comp_list.indexOf(comp_selected)];
                        print(comp_id);
                      });
                      delete_row(cust_phone,cust_name);

                    }),
                // button for delete row from list view
                RaisedButton(
                    child: Icon(Icons.delete_forever,color: Colors.white,size: 40,),
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        side: BorderSide(color: Colors.black)
                    ),
                    onPressed: (){delete_row(cust_phone,cust_name);}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  delete_row(String phone,String name){

    setState(() {
      db.deleteorder(phone, name);

    });

  }

  bool comp_container=true;
  Widget Draw_form(){

    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Form(
            child: Column(
              children: [
                SizedBox(height: 20,),

                FutureBuilder <List>(
                    future:  db.allcomp(),
                    builder: (context,snapshot) {
                      if (snapshot.hasData) {
                        for(int i=0;i<snapshot.data.length;i++) {
                          if(!comp_id_list.contains(snapshot.data[i]['comp_id'])) {
                            print(snapshot.data);
                            comp_list.add(snapshot.data[i]['comp_name']);
                            comp_id_list.add(snapshot.data[i]['comp_id']);
                          }
                        }
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 90.0,vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            border: Border.all(
                                color: comp_container ? Colors.black:Colors.red , style: BorderStyle.solid, width: 2),
                          ),
                          child: DropdownButton(
                            hint: Text('اختار الشركه'),
                            items: comp_list.map((comp) {
                              return DropdownMenuItem<String>(child: Text(comp,style: TextStyle(fontSize: 20,color: Colors.black),),value: comp,);
                            }).toList(),
                            value: comp_selected,
                            onChanged: (value){
                              setState(() {
                                comp_selected = value;
                                comp_id= comp_id_list[comp_list.indexOf(comp_selected)];
                                print(comp_id);
                              });
                            },
                          ),
                        );
                      }
                      return Container();
                    }),


             //---------------------------------------------------------------

                SizedBox(height: 20,),
                TextFormField(
                  decoration: InputDecoration(hintText: 'اسم العميل...',
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black,width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black,width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black,fontSize: 20),

                  controller: controller_cust_name,
                ),

                //-------------------------------------------------------------

                SizedBox(height: 20,),
                TextFormField(
                  decoration: InputDecoration(hintText: 'التليفون',
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black,width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black,width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black,fontSize: 20),
                  controller: controller_cust_phone,
                ),

                //-----------------------------------------------------------------------

                SizedBox(height: 20,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 90,vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(
                    color: Colors.black, style: BorderStyle.solid, width: 2),
              ),
              child: DropdownButton(
                    hint: Text("اختار المحافظه"),
                    items: city.map((val){
                          return DropdownMenuItem(child: Text(val),value: val,);
                          }).toList(),
                    value: city_selected,
                    onChanged: (val){
                      setState(() {
                        city_selected = val;
                      });
                }),
            ),

                //-----------------------------------------------------------------------

                SizedBox(height: 20,),
                TextFormField(
                  decoration: InputDecoration(hintText: 'العنوان',
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black,width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black,width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black,fontSize: 20),
                  controller: controller_cust_address,
                ),

                //------------------------------------------------------------------------------

                SizedBox(height: 20,),
                TextFormField(
                  decoration: InputDecoration(hintText: 'المبلغ',
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black,width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black,width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black,fontSize: 20),
                  controller: controller_cust_price,
                ),

                //------------------------------------------------------------------------------------

                SizedBox(height: 20,),
                TextFormField(
                  decoration: InputDecoration(hintText: 'ملاحظات',
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black,width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black,width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black,fontSize: 20),
                  controller: controller_cust_note,
                ),

                //-----------------------------------------------------------------------------------------

                SizedBox(height: 30,),
                RaisedButton(
                    child: Text('اضف الاوردر', style: TextStyle(fontSize: 35,color: Colors.white),textAlign: TextAlign.center,),
                    color: comp_container? Colors.black : Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(color: Colors.black)
                    ),
                    onPressed: (){
                      add_item_tolist();
                    }),
              ],
            ),

      ),
    ) ;
  }

   add_item_tolist() {

    setState(() {
      if(comp_selected!=null) {
        comp_container = true;

        if (city_selected == null)
          db.create_order(order.new_order(controller_cust_name.text, controller_cust_phone.text, '', controller_cust_address.text,
              controller_cust_price.text, controller_cust_note.text, comp_selected,comp_id));
        else
         db.create_order(order.new_order(controller_cust_name.text, controller_cust_phone.text, city_selected, controller_cust_address.text,
             controller_cust_price.text, controller_cust_note.text, comp_selected,comp_id));

        controller_cust_name.clear();
        controller_cust_address.clear();
        controller_cust_phone.clear();
        controller_cust_price.clear();
        controller_cust_note.clear();


    }else
      comp_container = false;
    });

  }

}

class MyConnectivity {
  MyConnectivity._internal();

  static final MyConnectivity _instance = MyConnectivity._internal();

  static MyConnectivity get instance => _instance;

  Connectivity connectivity = Connectivity();

  StreamController controller = StreamController.broadcast();

  Stream get myStream => controller.stream;

  void initialise() async {
    ConnectivityResult result = await connectivity.checkConnectivity();
    _checkStatus(result);
    connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isOnline = true;
      } else
        isOnline = false;
    } on SocketException catch (_) {
      isOnline = false;
    }
    controller.sink.add({result: isOnline});
  }

  void disposeStream() => controller.close();
}



