import 'dart:io';

import 'package:mes12quetta/contactinfomodel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqfliteDatabaseHelper {
  // Database _db;
  SqfliteDatabaseHelper.internal();
  static final SqfliteDatabaseHelper instance = new SqfliteDatabaseHelper.internal();
  factory SqfliteDatabaseHelper() => instance;

  static final data_reading1 = 'data_reading1';
  static final _version = 1;

  Database _db;

  Future<Database> get db async {
    if (_db !=null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }


  Future<Database> initDb()async{
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path,'mes.db');
    print(dbPath);
    var openDb = await openDatabase(dbPath,version: _version,
        onCreate: (Database db,int version)async{
          await db.execute("""
        CREATE TABLE data_reading1 (
          readingid INTEGER PRIMARY KEY AUTOINCREMENT,  
          meter_no TEXT, 
          offpeak TEXT,
          month TEXT,
          year TEXT,
          datetime TEXT
          )""");
        },
        onUpgrade: (Database db, int oldversion,int newversion)async{
          if (oldversion<newversion) {
            print("Version Upgrade");
          }
        }
    );
    print('db initialize');
    return openDb;
  }

  static void save(ContactinfoModel photo) {}

}