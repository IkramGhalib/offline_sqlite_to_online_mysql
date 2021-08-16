import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:mes12quetta/contactinfomodel.dart';
import 'package:http/http.dart' as http;

import 'contactinfomodel.dart';
import 'databasehelper.dart';

class Controller {
  final conn = SqfliteDatabaseHelper.instance;

  // static Future<bool> isInternet() async {
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.mobile) {
  //     if (await DataConnectionChecker().hasConnection) {
  //       print("Mobile data detected & internet connection confirmed.");
  //       return true;
  //     } else {
  //       print('No internet :( Reason:');
  //       return false;
  //     }
  //   } else if (connectivityResult == ConnectivityResult.wifi) {
  //     if (await DataConnectionChecker().hasConnection) {
  //       print("wifi data detected & internet connection confirmed.");
  //       return true;
  //     } else {
  //       print('No internet :( Reason:');
  //       return false;
  //     }
  //   }
  //   else if (connectivityResult == ConnectivityResult.none) {
  //     if (await DataConnectionChecker().hasConnection) {
  //       print("Server Wifi detected & Wifi connection confirmed.");
  //       return true;
  //     }else{
  //       print('No Server Wifi :( Reason:');
  //       return false;
  //     }
  //   }else {
  //     print(
  //         "Neither mobile data or WIFI detected, not internet connection found.");
  //     return false;
  //   }
  // }

  Future<int> addData(ContactinfoModel contactinfoModel) async {
    var dbclient = await conn.db;
    int result=0;
    try {
      result = await dbclient.insert(
          SqfliteDatabaseHelper.data_reading1, contactinfoModel.toJson());
    } catch (e) {
      print(e.toString());
    }
    return result;
  }
  //delete
  Future<int> deleteData(ContactinfoModel contactinfoModel) async {
    var dbclient = await conn.db;
    int result=0;
    try {
      result = await dbclient.delete(
          SqfliteDatabaseHelper.data_reading1);
    } catch (e) {
      print(e.toString());
    }
    return result;
  }
  //delete

  Future<int> updateData(ContactinfoModel contactinfoModel) async {
    var dbclient = await conn.db;
   int result=0;
    try {
      result = await dbclient.update(
          SqfliteDatabaseHelper.data_reading1, contactinfoModel.toJson(),
          where: 'readingid=?', whereArgs: [contactinfoModel.readingid]);
    } catch (e) {
      print(e.toString());
    }
    return result;
  }

  Future fetchData() async {
    var dbclient = await conn.db;
    List userList = [];
    try {
      List<Map<String, dynamic>> maps = await dbclient.query(
          SqfliteDatabaseHelper.data_reading1, orderBy: 'readingid DESC');
      for (var item in maps) {
        userList.add(item);
      }
    } catch (e) {
      print(e.toString());
    }
    return userList;
  }
}