import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ra7al_seller/profile.dart';
import 'package:ra7al_seller/sign_up.dart';
import 'Order_detailes.dart';
import 'classies/notfication.dart';
import 'classies/order.dart';
import 'main.dart';
import 'new_order.dart';
import 'orders.dart';
import 'package:ra7al_seller/Order_analysise.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_database/firebase_database.dart';
import 'classies/Db_helper.dart';


class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _Home();
  }


}

class _Home extends State<Home>{

  StreamSubscription <Event> updates;
  String order_key;
  String order_date;
  String comp_id;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }


  void check_notfication() {

    String uid = FirebaseAuth.instance.currentUser.uid.toString();
    DatabaseReference ref = FirebaseDatabase.instance.reference().child('sellers').child(uid).child('notfications');
    updates = ref.onChildAdded.listen((data) {
      Map<dynamic,dynamic> element = data.snapshot.value;
      print(element);
      notfication notf = notfication(element['date'], element['hour'], element['sender_name'], element['content'],
          element['order_key'], element['comp_id'], element['cust_name'], element['cust_phone'],element['order_date']);
      setState(() {
        DbHelper().create_notification(notf);
      });
      scheduleAlarm(element['content'],element['sender_name'],element['order_key'],element['comp_id'],element['order_date']);
      ref.child(data.snapshot.key).remove();
    });

  }

  @override
  Widget build(BuildContext context) {



    GlobalKey<ScaffoldState> Home_scaffold_key = GlobalKey<ScaffoldState>();

    check_notfication();
    /*SystemChannels.lifecycle.setMessageHandler((msg){
      debugPrint('SystemChannels> $msg');
      //if(msg==AppLifecycleState.resumed.toString())setState((){check_notfication();});
      if(msg==AppLifecycleState.paused.toString())setState((){check_notfication();});
    });*/

    String order_key;

    return Scaffold(
      backgroundColor: Colors.white,
      key:Home_scaffold_key ,
      drawer: Drawer(
        child: ListView(
          children: [
            Draw_header(),

                 FlatButton(
                  child: Text("الاوردارات", style: TextStyle(fontSize: 25,color: Colors.black)),
                  color: Colors.grey.withOpacity(0),
                  onPressed: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder:(context)=> Order())
                    );
                  },
                  ),
//            SizedBox(
//              height: 10,
//            ),
//            FlatButton(
//                child: Text("تحليل النتائج",style: TextStyle(fontSize: 25,color: Colors.black),),
//                color: Colors.grey.withOpacity(0),
//              onPressed: (){
//                Navigator.push(context,
//                    MaterialPageRoute(builder:(context)=> Order_analysise.empty())
//                );
//              },
//               ),

            SizedBox(
              height: 10,
            ),
            FlatButton(
                child: Text("الملف الشخصى", style: TextStyle(fontSize: 25,color: Colors.black),),
                color: Colors.grey.withOpacity(0),
              onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(builder:(context)=> Profile())
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            FlatButton(
                child: Text("تسجيل الخروج" , style: TextStyle(fontSize: 20,color: Colors.black),),
                color: Colors.grey.withOpacity(0),
              onPressed: (){
                 FirebaseAuth.instance.signOut().whenComplete((){
                   Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (c)=>Sign_up()), (route) => false);
                 });
              },
            ),
          ],
        ),

      ),
      appBar: AppBar(
        title: Text('Ra7al',
          style: TextStyle(color: Colors.white, fontSize: 40),
        ),
        leading: IconButton(
          icon: Icon(Icons.menu , color: Colors.white,),
          onPressed: (){
             Home_scaffold_key.currentState.openDrawer();
          } ,
        ),
        backgroundColor: Colors.black,

      ),
      body: Container(
              child:FutureBuilder<List>(
                  future: DbHelper().allNotification(),
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      if(snapshot.data.length==0){
                        return Center(child: Image(image:NetworkImage('https://egitimvadisi.com.tr/assets/img/no-result.gif'),));
                      }else{
                      return Column(
                        children:[
                          IconButton(icon: Icon(Icons.delete_forever,size: 40,), onPressed: (){
                            setState(() {
                              DbHelper().deleteall_notfication();
                            });
                          }),

                          Expanded(
                            child: ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context,index){
                                print(snapshot.data[index]['cust_name']+snapshot.data[index]['cust_phone']+snapshot.data[index]['sender_name']+
                                    snapshot.data[index]['date']+snapshot.data[index]['hour']+snapshot.data[index]['content']);
                                return GestureDetector(
                                  child: Row_style(snapshot.data[index]['cust_name'],snapshot.data[index]['cust_phone'],snapshot.data[index]['sender_name'],
                                                   snapshot.data[index]['date'],snapshot.data[index]['hour'],snapshot.data[index]['content']),

                                  onTap: (){
                                    //-----go to order detailes -------\\
                                    order_key = snapshot.data[index]['order_key'];
                                    order_date = snapshot.data[index]['order_date'];
                                    comp_id = snapshot.data[index]['comp_id'];
                                    FirebaseDatabase.instance.reference().child('companies').child(comp_id).child('orders')
                                        .child(order_date).child(order_key).once().then((DataSnapshot snapshot){
                                        if(snapshot.value!=null){
                                          Map map = snapshot.value;
                                          print(map);
                                          print(map['cust_delivery_fee_plus']);
                                         List<notfication> notfi =[];
                                          map['notfications'].values.forEach((element) {
                                            notfi.add(notfication.chat(element['date'], element['hour'], element['sender_name'], element['content']));
                                          });

                                          order o = order(map['cust_name'],map['cust_phone'],map['cust_city'],map['cust_address'],map['cust_price'],
                                          map['cust_delivery_price'],map['cust_note'],map['cust_status'],map['cust_delivery_fee'],map['cust_delivery_fee_plus'],notfi,
                                              order_key,map['delivery_id'],order_date,comp_id);
                                           Navigator.push(context, MaterialPageRoute(builder: (context)=> Order_detailes(o)));
                                        }else{
                                          setState(() {
                                            DbHelper().deletNotfication(order_key);
                                            print('no order matched');
                                            print(snapshot.key.toString());
                                          });
                                        }
                                    });
                                  //---------------------------------------\\
                                  },
                                );
                              }
                        ),
                          ),
                        ]
                      );
                      }
                    }
                      return Container();
                  }
              ) ,

          ),
      // floating button for new order
      floatingActionButton: FloatingActionButton(
          child : Icon(Icons.add),
          backgroundColor: Colors.black,
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder:(context)=> new_order()));

          },
      ),

    );
  }

  Widget Draw_header(){
    return DrawerHeader(
      decoration: BoxDecoration(color: Colors.black),
       padding: EdgeInsets.all(10),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.center,
         //mainAxisAlignment: MainAxisAlignment.center,
         children: [
           Container(height: 100,
           width: 110,
             child:CircleAvatar(backgroundImage: NetworkImage("https://images.squarespace-cdn.com/content/v1/5c528d9e96d455e9608d4c63/1586379635937-DUGHB6LHU59QIVDH2QHZ/ke17ZwdGBToddI8pDm48kHTW22EZ3GgW4oVLBBkxXg1Zw-zPPgdn4jUwVcJE1ZvWQUxwkmyExglNqGp0IvTJZUJFbgE-7XRK3dMEBRBhUpwEg94W6zd8FBNj5MCw-Ij7INTc0XdOQR2FYhNzGmPXJN9--qDehzI3YAaYB5CQ-LA/Hiker.gif?format=500w"),),
           ),

           SizedBox(width: 20,),

           Expanded(
               child: Text('Ra7al',style: TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.bold),),
           ),

         ],
       ),
    );
  }


  // row shape of every row in notification list
  Widget Row_style(cust_nam,cust_phon,sender,date,houre,content){
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

                         SizedBox(height: 15,),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text(cust_phon,style: TextStyle(color: Colors.black,fontSize: 20)),
                             Text(cust_nam,style: TextStyle(color: Colors.black,fontSize: 20)),
                           ],
                         ),

                         SizedBox(height: 40,),
                         Center(child: Text(content,style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold))),
                         SizedBox(height: 20,),
                       ]
                   ),
             ),

         ),
       );

  }

int temp =0 ;
  void scheduleAlarm(String content,String sender,String order_key,comp_id,order_date) async {

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      'Channel for Alarm notification',
      icon: 'app_logo',
      //sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
      largeIcon: DrawableResourceAndroidBitmap('app_logo'),
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
       // sound: 'a_long_cold_sting.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true);
    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics,iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(temp, sender, content, platformChannelSpecifics, payload: order_key+','+comp_id+','+order_date);
    temp++;

   /* await flutterLocalNotificationsPlugin.zonedSchedule(0, 'title', "body",
        time, platformChannelSpecifics);*/
  }


}