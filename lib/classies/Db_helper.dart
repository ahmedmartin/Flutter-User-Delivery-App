import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'notfication.dart';
import 'order.dart';


class DbHelper {
  static final DbHelper _instance = DbHelper.internal();

  factory DbHelper() => _instance;

  DbHelper.internal();

  static Database _db;

  String table_orders = 'orders';
  String table_notfic = 'notifications';
  String table_history_orders = 'history_orders';
  String table_comp = 'companies';

  Future<Database> createDatabase() async {
    if (_db != null) {
      return _db;
    }
    //define the path to the database
    String path = join(await getDatabasesPath(), 'order.db');
    _db = await openDatabase(path, version: 1, onCreate: (Database db, int v) {
      //create all tables
      /*db.execute(
          'CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');*/
      db.execute(
          "CREATE TABLE orders(cust_name varchar(50),cust_phone varchar(50),cust_city varchar(50),cust_address varchar(50),"
              "cust_price varchar(50),cust_note varchar(50),comp varchar(50),comp_id varchar(50))");

      db.execute(
          "CREATE TABLE notifications(order_key varchar(50),sender_name varchar(50),content varchar(50),date varchar(50),hour varchar(50),cust_name varchar(50),cust_phone varchar(50),comp_id varchar(50),order_date varchar(50))");


      db.execute(
          "CREATE TABLE companies(comp_id varchar(50),comp_name varchar(50))");

    });

    return _db;
  }

  Future<int> create_order(order Order) async{
    Database db = await createDatabase();
    //db.rawInsert('insert into courses')
    return db.insert(table_orders, order_to_map(Order));
  }

  Future<int> create_notification(notfication notific) async{
    Database db = await createDatabase();
    //db.rawInsert('insert into courses')
    return db.insert(table_notfic, notific.notifi_to_map());
  }

  Future<int> create_comp(comp_id,comp_name) async{
    Database db = await createDatabase();
    //db.rawInsert('insert into courses')
    return db.insert(table_comp, {'comp_id':comp_id,'comp_name':comp_name});
  }


  Map<String,dynamic> order_to_map(order Order){

    return{
       'cust_name':Order.cust_name, 'cust_phone':Order.cust_phone, 'cust_city':Order.cust_city, 'cust_address':Order.cust_address,
      'cust_price':Order.cust_price, 'cust_note':Order.cust_note, 'comp':Order.comp
    };
  }

  Future<List> allOrders() async{
    Database db = await createDatabase();
    return db.query(table_orders);
  }

  Future<List> allNotification() async{
    Database db = await createDatabase();
    return db.query(table_notfic);
  }

  //SELECT DISTINCT Country FROM Customers;
  Future<List> allcomp_with_name(comp_name) async{
    Database db = await createDatabase();
    return db.query(table_comp,where: 'comp_name = ?',whereArgs: [comp_name]);
  }

  // get distinct data in order_key table
  Future<List> allcomp() async{
    Database db = await createDatabase();
    return db.query(table_comp);
  }

  Future<int> deleteorder(String phone,String name) async{
    Database db = await createDatabase();
    return db.delete(table_orders,where: 'cust_phone = ? AND cust_name = ?',whereArgs:[phone,name] );
  }

  Future<int> deletNotfication(String order_key) async{
    Database db = await createDatabase();
    return db.delete(table_notfic,where: 'order_key = ?',whereArgs:[order_key] );
  }

  Future<int> deletcomp(String comp_name) async{
    Database db = await createDatabase();
    return db.delete(table_comp,where: 'comp_name = ?',whereArgs:[comp_name] );
  }

  Future<int> deleteall() async{
    Database db = await createDatabase();
    return db.delete(table_orders);
  }

  Future<int> deleteall_notfication() async{
    Database db = await createDatabase();
    return db.delete(table_notfic);
  }

}