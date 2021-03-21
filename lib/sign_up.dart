import 'dart:ui';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'classies/Db_helper.dart';
import 'home.dart';


class Sign_up extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _sign_up();
  }

}

class _sign_up extends State<Sign_up>{

  TextEditingController name_controller = TextEditingController();
  TextEditingController phone_controller = TextEditingController();

  String comp_id,comp_name;
  String error_msg="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if(user!=null)
       // print('signed before');
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (c)=>Home()), (route) => false);

      else
        print('no login');

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(height: 50,),
              Text('تسجيل حساب جديد',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 35),textAlign: TextAlign.center,),
              SizedBox(height: 40,),

              TextFormField(
                decoration: InputDecoration(hintText: 'اسم الشركه',
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black,width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black,width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                ),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black,fontSize: 20),
                controller: name_controller,
              ),

              SizedBox(height: 20,),
              TextFormField(
                keyboardType:TextInputType.number,
                decoration: InputDecoration(hintText: 'التليفون',
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black,width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black,width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(30))),

                ),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black,fontSize: 20),
                controller: phone_controller,
              ),

              // error message\\
              Text(error_msg,style: TextStyle(color: Colors.red,fontSize: 15),textAlign: TextAlign.center,),

              SizedBox(height: 30,),
              RaisedButton(
                  child: Text('تسجيل حساب جديد', style: TextStyle(fontSize: 35,color: Colors.white),textAlign: TextAlign.center,),
                  color:  Colors.black ,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.black)
                  ),
                  onPressed: (){
                    phone_controller.text = phone_controller.text.replaceAll(" ", "");
                    if(phone_controller.text.isNotEmpty) {
                      if(name_controller.text.isNotEmpty) {
                        DatabaseReference ref = FirebaseDatabase.instance
                            .reference().child("waiting_list").child(
                            phone_controller.text);
                        ref.once().then((DataSnapshot snapshot) {
                          if (snapshot.value != null) {
                            //print(snapshot.value.toString());
                            List temp = snapshot.value.toString().split(',');
                            comp_id = temp[0];
                            comp_name = temp[1];
                            firebase_Auth(true);
                          } else {
                            setState(() {
                              error_msg =
                              'هذا الرقم لم يتم التعرف عليه تأكد ان هناك شركه شحن اضافتك الى قائمه الانتظار';
                            });
                            print('no in waiting list');
                          }
                        });
                      }else
                        setState(() {
                          error_msg = 'يجب ادخال اسم الشركه لاتمام تسجيل حساب جديد';
                        });
                    }else{
                      setState(() {
                        error_msg='يجب ادخال رقم هاتف';
                      });

                    }
                  }),

              SizedBox(height: 30,),
              FlatButton(child:Text('اذا كنت تمتلك حساب اضغط هنا',style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
              onPressed: (){
                sign_in();
              })
            ],
          ),
        ),
      ),
    );
  }

  TextEditingController sign_in_controller = TextEditingController();
 sign_in(){
   showDialog(
       context: context,
       builder: (BuildContext context) {
         return BackdropFilter(
             filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
             child:  AlertDialog(
               title: new Text(' تسجيل الدخول',style: TextStyle(fontSize: 30,color: Colors.black),textAlign: TextAlign.center,),
               content: TextFormField(
                 keyboardType:TextInputType.number,
                 decoration: InputDecoration(hintText: 'ادخل رقم الهاتف'),
                 textAlign: TextAlign.center,
                 controller: sign_in_controller,
                 style: TextStyle(color: Colors.black,fontSize: 20),
               ),
               actions: [
                 FlatButton(child: Text('تسجيل دخول',style: TextStyle(color: Colors.black,fontSize: 20),),
                   onPressed: ()async{
                    firebase_Auth(false);
                   },
                 )
               ],
             ));
       });
 }

  String verificationId;
  firebase_Auth(bool sign_up)async{

    FirebaseAuth auth = FirebaseAuth.instance;
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber:sign_up ? '+2'+phone_controller.text:'+2'+sign_in_controller.text,
      verificationCompleted: (PhoneAuthCredential credential) async{
        await auth.signInWithCredential(credential).whenComplete((){
         /* print("signed in success 2");
          if(sign_up)
              make_profile();
          else
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (c)=>Home()), (route) => false);*/
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          Text('The provided phone number is not valid.');
        }
      },
      codeSent: (String _verificationId, int resendToken) async{
        // Create a PhoneAuthCredential with the code
        enter_sms_code(sign_up);
        verificationId = _verificationId;
      },
      timeout: const Duration(seconds: 120),
      codeAutoRetrievalTimeout: (String _verificationId) {verificationId = _verificationId;},
    );

  }

  TextEditingController sms_code = TextEditingController();
  enter_sms_code(bool sign_up){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child:  AlertDialog(
                title: new Text('ادخل الكود لتأكيد تسجيل الدخول',style: TextStyle(fontSize: 30,color: Colors.black),textAlign: TextAlign.center,),
                content: TextFormField(
                  decoration: InputDecoration(hintText: 'ادخل الكود'),
                  keyboardType:TextInputType.number,
                  textAlign: TextAlign.center,
                  controller: sms_code,
                  style: TextStyle(color: Colors.black,fontSize: 20),
                ),
                actions: [
                  FlatButton(child: Text('ارسال',style: TextStyle(color: Colors.black,fontSize: 20),),
                    onPressed: ()async{

                      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: sms_code.text);
                      // Sign the user in (or link) with the credential
                      await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential).whenComplete((){
                        print('signed in success 1');
                        if(sign_up)
                          make_profile();
                        else
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (c)=>Home()), (route) => false);
                      });
                    },
                  )
                ],
              ));
        });
  }

  make_profile() {
    String uid = FirebaseAuth.instance.currentUser.uid.toString();
    DatabaseReference s_ref = FirebaseDatabase.instance.reference().child("sellers").child(uid);
    s_ref.child('profile').set({'name': name_controller.text,'phone':phone_controller.text});
    DbHelper().create_comp(comp_id, comp_name);
    s_ref.child('companies').child(comp_id).set(comp_name).whenComplete((){Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (c)=>Home()), (route) => false);});
    FirebaseDatabase.instance.reference().child("waiting_list").child(phone_controller.text).remove();
  }


}