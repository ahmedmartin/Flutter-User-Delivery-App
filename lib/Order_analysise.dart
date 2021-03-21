import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ra7al_seller/classies/order.dart';
import 'package:percent_indicator/percent_indicator.dart';



class Order_analysise extends StatefulWidget{


  List<order> all_orders;
  String wallet ; // el seller estlm flos wla la2


  Order_analysise(this.all_orders,this.wallet);



  @override
  State<StatefulWidget> createState() {

    return _Order_analysise(all_orders,wallet);
  }

}

class _Order_analysise extends State<Order_analysise>{


  List<order> all_orders; // كل الاوردارات اللى ف التاريخ اللى محدده
  String wallet ; // el seller estlm flos wla la2
  _Order_analysise(this.all_orders,this.wallet);



  int orders_delivered=0; //استلم
  int orders_wait=0;// مؤجل
  int orders_canceled=0;//مرتجع
  int orders_ked_tanfez=0;//قيد النفيذ
  int orders_sha7n_rasel=0;//شحن على الراسل
  int orders_mortg3_goz2=0;//مرتجع جزئى
  double delivery_fee =0;  // اجمالى مصاريف الشحن
  double orderies_price=0 ; // اجمالى مبلغ الاوردارات

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filter_data();
  }

  filter_data(){
    all_orders.forEach((element) {
      switch(element.cust_status){
        case'استلم': {orders_delivered+=1; break;}
        case 'مؤجل': {orders_wait+=1;break;}
        case 'شحن على الراسل':{orders_sha7n_rasel+=1;break;}
        case 'لاغى':{orders_canceled+=1;break;}
        case 'مرتجع جزئى':{orders_mortg3_goz2+=1;break;}
        case 'قيد التنفيذ':{orders_ked_tanfez+=1;break;}
      }

      try {
        if (element.cust_delivery_fee.isNotEmpty) {
          delivery_fee += double.parse(element.cust_delivery_fee);
          if (element.cust_delivery_fee_plus.isNotEmpty) {
            delivery_fee += double.parse(element.cust_delivery_fee_plus);
          }
        }
      }catch(e){}

      try {
        if (element.cust_delivery_price.isNotEmpty)
          orderies_price += double.parse(element.cust_delivery_price);
      }catch(e){}

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Container(height: 30,),
              Center(
                child: CircularPercentIndicator(
                  radius: 130.0,
                  animation: true,
                  animationDuration: 2000,
                  lineWidth: 15.0,
                  percent: orders_delivered/all_orders.length,
                  center: new Text(orders_delivered.toString(), style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                  circularStrokeCap: CircularStrokeCap.butt,
                  backgroundColor: Colors.white,
                  progressColor: Colors.black,
                  footer: Text('استلم',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                ),
              ),

              Container(height: 30,),
              Center(
                child: CircularPercentIndicator(
                  radius: 130.0,
                  animation: true,
                  animationDuration: 2000,
                  lineWidth: 15.0,
                  percent: orders_canceled/all_orders.length,
                  center: new Text(orders_canceled.toString(), style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                  circularStrokeCap: CircularStrokeCap.butt,
                  backgroundColor: Colors.white,
                  progressColor: Colors.black,
                  footer: Text('لاغى',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                ),
              ),

              Container(height: 30,),
              Center(
                child: CircularPercentIndicator(
                  radius: 130.0,
                  animation: true,
                  animationDuration: 2000,
                  lineWidth: 15.0,
                  percent: orders_wait/all_orders.length,
                  center: new Text(orders_wait.toString(), style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                  circularStrokeCap: CircularStrokeCap.butt,
                  backgroundColor: Colors.white,
                  progressColor: Colors.black,
                  footer: Text('مؤجل',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                ),
              ),

              Container(height: 30,),
              Center(
                child: CircularPercentIndicator(
                  radius: 130.0,
                  animation: true,
                  animationDuration: 2000,
                  lineWidth: 15.0,
                  percent: orders_sha7n_rasel/all_orders.length,
                  center: new Text(orders_sha7n_rasel.toString(), style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                  circularStrokeCap: CircularStrokeCap.butt,
                  backgroundColor: Colors.white,
                  progressColor: Colors.black,
                  footer: Text('شحن على الراسل',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                ),
              ),

              Container(height: 30,),
              Center(
                child: CircularPercentIndicator(
                  radius: 130.0,
                  animation: true,
                  animationDuration: 2000,
                  lineWidth: 15.0,
                  percent: orders_mortg3_goz2/all_orders.length,
                  center: new Text(orders_mortg3_goz2.toString(), style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                  circularStrokeCap: CircularStrokeCap.butt,
                  backgroundColor: Colors.white,
                  progressColor: Colors.black,
                  footer: Text('مرتجع جزئى',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                ),
              ),

              Container(height: 30,),
              Center(
                child: CircularPercentIndicator(
                  radius: 130.0,
                  animation: true,
                  animationDuration: 3000,
                  lineWidth: 20.0,
                  percent: orders_ked_tanfez/all_orders.length,
                  center: new Text(orders_ked_tanfez.toString(), style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                  circularStrokeCap: CircularStrokeCap.butt,
                  backgroundColor: Colors.white,
                  progressColor: Colors.black,
                  footer: Text('قيد التنفيذ',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                ),
              ),

              Container(height: 30,),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(orderies_price.toString(),style: TextStyle(fontSize: 20,color: Colors.black),),
                    Text(" : اجمالى التحصيل",style: TextStyle(fontSize: 25,color: Colors.black,fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
              
              Container(height: 30,),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(delivery_fee.toString(),style: TextStyle(fontSize: 20,color: Colors.black),),
                    Text(" : اجمالى الشحن",style: TextStyle(fontSize: 25,color: Colors.black,fontWeight: FontWeight.bold),)
                  ],
                ),
              ),

              Container(height: 30,),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text((orderies_price-delivery_fee).toString(),style: TextStyle(fontSize: 20,color: Colors.black),),
                    Text(" : الاجمالى",style: TextStyle(fontSize: 25,color: Colors.black,fontWeight: FontWeight.bold),)
                  ],
                ),
              ),

              Container(height: 30,),

            ],
          ),
        ),
      ),
      
      floatingActionButton: FloatingActionButton(
        child:wallet=='لم يتم تقفيل الحساب'?Icon(Icons.account_balance_wallet,color: Colors.white,size: 25,):
        wallet=='تم تقفيل الحساب'?Icon(Icons.check,color:Colors.white,size: 25,):
        wallet=='قيد التنفيذ'?Icon(Icons.timer,color:Colors.white,size: 25,):null,
        backgroundColor:Colors.black,
        onPressed: (){
          if(wallet=='لم يتم تقفيل الحساب'){
            String uid = FirebaseAuth.instance.currentUser.uid.toString();
            FirebaseDatabase.instance.reference().child('companies').child(all_orders[0].comp_id).child('money').
               child(uid).set(all_orders[0].order_date).whenComplete((){
                 setState(() {
                   wallet='قيد التنفيذ';
                 });
            });
            FirebaseDatabase.instance.reference().child('sellers').child(uid).child('orders').
              child(all_orders[0].comp_id).child(all_orders[0].order_date).set('قيد التنفيذ');
          }
        },
      ),
          
    );
  }


}