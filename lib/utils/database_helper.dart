import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:myapp/models/money.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String moneyTable = 'money_table';
  String colId = 'id';
  String colTitle = 'title';
  String colMoney = 'money';
  String colDate = 'date';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }

    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDatabase();
    }
    return _database;
  }

  Future<Database> initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'money.db';

    var moneyDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return moneyDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $moneyTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle Text,'
        '$colMoney INTEGER, $colDate Text)');
  }

  Future<List<Map<String, dynamic>>> getMoneyMapList() async {
    Database db = await this.database;

//    var result = await db.rawQuery('SELECT * FROM $moneyTable ORDER BY $colDate ASC');
    var result = await db.query(moneyTable, orderBy: '$colDate ASC');
    return result;
  }

  Future<int> insertMoney(Money money) async {
    Database db = await this.database;
    var result = await db.insert(moneyTable, money.toMap());
    return result;
  }

  Future<int> updateMoney(Money money) async {
    Database db = await this.database;
    var result = await db.update(moneyTable, money.toMap(),
        where: '$colId = ? ', whereArgs: [money.id]);
    return result;
  }

  Future<int> deleteMoney(int id) async {
    Database db = await this.database;
    var result =
        await db.rawDelete('DELETE FROM $moneyTable WHERE $colId = $id');
//    var result = await db.update(moneyTable, money.toMap(), where: '$colId = ? ',whereArgs: [money.id]);
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT(*) FROM $moneyTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Money>> getMoneyList() async {
    var moneyMapList = await getMoneyMapList();
    int count = moneyMapList.length;

    List<Money> moneyList = List<Money>();

    for (int i = 0; i < count; i++) {
      moneyList.add(Money.fromMapObject(moneyMapList[i]));
    }

    return moneyList;
  }

  Future<int> nextId() async{
    Database db = await this.database;
    List<Map<String, dynamic>> x =
    await db.rawQuery('SELECT MAX($colId) FROM $moneyTable');

    int result = Sqflite.firstIntValue(x);

    return result;

  }
}
