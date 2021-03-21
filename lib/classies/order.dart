
import 'notfication.dart';

class order{

  String cust_name ;//اسم العميل
  String cust_phone ;//تليفون العميل
  String cust_city ;//محافظه العميل
  String cust_address ;//عنوان تفصيلى للعميل
  String cust_price ;// سعر الاجمالى من الاوردر
  String cust_delivery_price ;//  سعر الاستلام من العميل
  String cust_note ;//ملحوظه
  String cust_status ;//حاله الاوردر و بتبقى كبدايه قيد االتنفيذ
  String cust_delivery_fee ;//سعر الشحن و ده بيتضاف من الابلكيشن بتاع الseller من الداتا بيز الداخليه بتاعته
  String cust_delivery_fee_plus; // لو شركه الشحن هتزود مبغ اضافه على الشحنه ع كبيره
  String comp; // اسم الشركه
  String comp_id;//الشركه id
  String order_key;//order_key
  String delivery_id;//delivery_id
  String order_date;// date of order
  List <notfication> chat; // الدردشه او الاشعارات الى تمت بين الseller و الdelivery

  order(this.cust_name,this.cust_phone,this.cust_city,this.cust_address,this.cust_price,
      this.cust_delivery_price,this.cust_note,this.cust_status,this.cust_delivery_fee,this.cust_delivery_fee_plus,
      this.chat,this.order_key,this.delivery_id,this.order_date,this.comp_id);

   order.new_order(this.cust_name,this.cust_phone,this.cust_city,this.cust_address,this.cust_price,this.cust_note,this.comp,this.comp_id);



}