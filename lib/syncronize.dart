import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'databasehelper.dart';
import 'contactinfomodel.dart';
import 'package:http/http.dart' as http;

class SyncronizationData {

  // static Future<bool> isInternet()async{
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.none) {
  //     if (await DataConnectionChecker().hasConnection) {
  //       print("Mobile data detected & internet connection confirmed.");
  //       return true;
  //     }else{
  //       print('wifi internet :( Reason:');
  //       return false;
  //     }
  //   } else if (connectivityResult == ConnectivityResult.mobile) {
  //     if (await DataConnectionChecker().hasConnection) {
  //       print("wifi data detected & internet connection confirmed.");
  //       return true;
  //     }else{
  //       print('mobile internet :( Reason:');
  //       return false;
  //     }
  //   }
  //   else if (connectivityResult == ConnectivityResult.wifi) {
  //     if (await DataConnectionChecker().hasConnection) {
  //       print("Server Wifi detected & Wifi connection confirmed.");
  //       return true;
  //     }else{
  //       print('No Server Wifi :( Reason:');
  //       return false;
  //     }
  //   }else {
  //     print("Neither mobile data or WIFI detected, not internet connection found.");
  //     return false;
  //   }
  // }

  final conn = SqfliteDatabaseHelper.instance;

  Future<List<ContactinfoModel>> fetchAllInfo()async{
    final dbClient = await conn.db;
    List<ContactinfoModel> contactList = [];
    try {
      final maps = await dbClient.query(SqfliteDatabaseHelper.data_reading1);
      for (var item in maps) {
        contactList.add(ContactinfoModel.fromJson(item));
      }
    } catch (e) {
      print(e.toString());
    }
    return contactList;
  }

  Future saveToMysqlWith(List<ContactinfoModel> contactList)async{
    for (var i = 0; i < contactList.length; i++) {
      Map<String, dynamic> data = {
        "readingid":contactList[i].readingid.toString(),
        "meter_no":contactList[i].meter_no,
        // "peak":contactList[i].peak,
        "offpeak":contactList[i].offpeak,
        "month":contactList[i].month,
        "year":contactList[i].year,
        // "image":contactList[i].offpkimage,
        "datetime":contactList[i].datetime,
      };
      // final response = await http.post(Uri.parse('http://192.168.137.2/mes/upload.php'),body: data);
      // final response = await http.post(Uri.parse('http://192.168.137.1/dgwce/android/upload.php'),body: data);
      // final response = await http.post(Uri.parse('http://192.168.0.200/mes12corps/dgwce/android/upload.php'),body: data);
    // final response = await http.post('http://192.168.137.1/dgwce/android/upload.php',body: data);
      final response = await http.post(Uri.parse('http://192.168.0.200/mes12corps/dgwce/android/upload.php'),body: data);
    //   final response = await http.post(Uri.parse('http://192.168.137.1/mes/upload.php'), body: data);
      if (response.statusCode==200) {
        print("Saving Data");
      }else{
        print(response.statusCode);
      }
    }
  }

  Future<List> fetchAllCustoemrInfo()async{
    final dbClient = await conn.db;
    List contactList = [];
    try {
      final maps = await dbClient.query(SqfliteDatabaseHelper.data_reading1);
      for (var item in maps) {
        contactList.add(item);
      }
    } catch (e) {
      print(e.toString());
    }
    return contactList;
  }

  Future saveToMysql(List contactList)async{
    for (var i = 0; i < contactList.length; i++) {
      Map<String, dynamic> data = {
        "readingid":contactList[i]['readingid'].toString(),
        "meter":contactList[i]['meter'],
        "peak":contactList[i]['peak'],
        "offpeak":contactList[i]['offpeak'],
        "month":contactList[i].month,
        "year":contactList[i].year,
        "offpkimage":contactList[i]['offpkimage'],
        "datetime":contactList[i]['datetime'],
      };
      // final response = await http.post(Uri.parse('http://192.168.0.200/mes12corps/dgwce/android/upload.php'),body: data);
      // final response = await http.post('http://192.168.137.1/dgwce/android/upload.php',body: data);
      final response = await http.post(Uri.parse('http://192.168.0.200/mes12corps/dgwce/android/upload.php'),body: data);

      // final response = await http.post(Uri.parse('http://192.168.137.1/dgwce/android/upload.php'), body: data);
      // final response = await http.post(Uri.parse('http://192.168.137.1/mes/upload.php'), body: data);
      http://192.168.10.8/mes/upload.php
      if (response.statusCode==200) {
        print("Saving Data ");
      }else{
        print(response.statusCode);
      }
    }
  }

}