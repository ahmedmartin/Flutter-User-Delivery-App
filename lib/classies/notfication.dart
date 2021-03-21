class notfication {

  String date;
  String hour;
  String sender_name;
  String content;
  String order_key;
  String comp_id;
  String cust_name;
  String cust_phone;
  String order_date;

  notfication(this.date, this.hour, this.sender_name, this.content,
      this.order_key, this.comp_id, this.cust_name, this.cust_phone,this.order_date);


  notfication.chat(this.date, this.hour, this.sender_name, this.content);

  notifi_to_map(){

    return {
      'order_key':order_key,
      'sender_name':sender_name,
      'content':content,
      'date':date,
      'hour':hour,
      'cust_name':cust_name,
      'cust_phone':cust_phone,
      'comp_id':comp_id,
      'order_date':order_date
    };

  }




}