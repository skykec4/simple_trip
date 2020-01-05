import 'package:intl/intl.dart';
import 'package:myapp/models/exchange_rate.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:myapp/models/money.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String userSettingTable = 'user_settings_table';
  String userSettingId = 'id';
  String userSettingCategory = 'category';

  String userDataTable = 'user_data_table';
  String userId = 'id';
  String userCategory = 'category';
  String userTotalMoney = 'total_money';
  String userCurrentNation = 'current_nation';
  String userTargetNation = 'target_nation';
  String userRegisterDate = 'register_date';

  String moneyTable = 'money_table';
  String colId = 'id';
  String colCategory = 'category';
  String colTitle = 'title';
  String colMoney = 'money';
  String colDate = 'date';
  String colPayment = 'payment';
  String colInputDate = 'input_date';

  //
  String exChangeRateTable = 'exchange_rate_table';
  String exRateDate = 'rate_date'; //가져온 날짜
  String exCurUnit = 'cur_unit'; //통화코드
  String exCurNm = 'cur_name'; //국가/통화명
  String exTTB = 'ttb'; //송금 받으실때
  String exTTS = 'tts'; //송금 보낼때
  String exDealBasR = 'deal_bas_r'; //매매기준율

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
    await db.execute('''
       CREATE TABLE $userSettingTable(
        $userSettingId INTEGER PRIMARY KEY AUTOINCREMENT,
        $userSettingCategory Text
        )''');
    await db.execute('''
       CREATE TABLE $userDataTable(
        $userId INTEGER PRIMARY KEY AUTOINCREMENT,
        $userCategory Text,
        $userTotalMoney INTEGER,
        $userCurrentNation Text,
        $userTargetNation Text,
        $userRegisterDate Text
        )''');
    await db.execute('''
      CREATE TABLE $moneyTable(
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colCategory Text,
        $colTitle Text,
        $colMoney INTEGER, 
        $colDate Text,
        $colPayment Text,
        $colInputDate Text
        )''');
    await db.execute('''
       CREATE TABLE $exChangeRateTable(
        $exRateDate Text,
        $exCurUnit Text,
        $exCurNm Text,
        $exTTB Text,
        $exTTS Text,
        $exDealBasR Text,
        PRIMARY KEY($exRateDate, $exCurUnit)
        )''');
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

  Future<int> nextId() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT MAX($colId) FROM $moneyTable');

    int result = Sqflite.firstIntValue(x);

    return result;
  }

  //전체에서 날짜별 총 사용한 돈
  Future<List<Map<String, dynamic>>> getDateAndTotalMapList() async {
    Database db = await this.database;

//    var result = await db.rawQuery('SELECT * FROM $moneyTable');
    var result = await db.rawQuery(
//        'SELECT $colDate, SUM($colMoney) AS money FROM $moneyTable GROUP BY $colDate'
        'SELECT $colDate, SUM($colMoney) AS money, (SELECT SUM($colMoney) FROM $moneyTable) AS total FROM $moneyTable GROUP BY $colDate');
//    var result = await db.query(moneyTable, orderBy: '$colDate ASC');

    return result;
  }

  Future<List<Money>> getDateAndTotal() async {
    var dateAndTotalMapList = await getDateAndTotalMapList();
    int count = dateAndTotalMapList.length;

    List<Money> moneyList = List<Money>();

    for (int i = 0; i < count; i++) {
      moneyList.add(Money.fromMapObject(dateAndTotalMapList[i]));
    }

    return moneyList;
  }

  Future<List<Map<String, dynamic>>> getTodayMapList() async {
    Database db = await this.database;

    var result =
        await db.rawQuery('SELECT * FROM $moneyTable ORDER BY $colDate ASC');
//    var result = await db.query(moneyTable, orderBy: '$colDate ASC');
    return result;
  }

  Future<List<Money>> getTodayList(String date, String category) async {
    Database db = await this.database;
//    var result = await db.query(moneyTable, orderBy: '$colDate ASC');
//    String _today = DateFormat('yyyyMMdd').format(DateTime.now());

    var moneyMapList = await db.rawQuery(
        '''SELECT $colId,
                  $colTitle,
                  $colMoney,
                  $colDate,
                  $colPayment,
                  (SELECT SUM($colMoney) 
                     FROM $moneyTable 
                    WHERE $colDate = $date 
                      AND $colCategory = "$category" ) as total,
                  $colInputDate 
             FROM $moneyTable 
            WHERE $colDate = $date 
              AND $colCategory = "$category" 
         ORDER BY $colId DESC''');
    print('moneyMapListmoneyMapListmoneyMapListmoneyMapList : $moneyMapList');
//    var moneyMapList = await getMoneyMapList();
    int count = moneyMapList.length;

    List<Money> moneyList = List<Money>();
    for (int i = 0; i < count; i++) {
      moneyList.add(Money.fromMapObject(moneyMapList[i]));
    }
    print('moneyList ::: $moneyList');

    return moneyList;
  }

  Future<List<Money>> getDayList(String date) async {
    Database db = await this.database;
//    var result = await db.query(moneyTable, orderBy: '$colDate ASC');

    var moneyMapList = await db.rawQuery(
        'SELECT * FROM $moneyTable WHERE $colDate = $date ORDER BY $colId ASC');

//    var moneyMapList = await getMoneyMapList();
    int count = moneyMapList.length;

    List<Money> moneyList = List<Money>();
    for (int i = 0; i < count; i++) {
      moneyList.add(Money.fromMapObject(moneyMapList[i]));
    }

    return moneyList;
  }

  /*
  *********************
  *********************
  *** exChange_Rate ***
  *********************
  *********************
  */

  Future<List<ExChangeRate>> getRecentExchangeRate() async {
    Database db = await this.database;

    var exChangeRateMapList = await db.rawQuery(
        'SELECT * FROM $exChangeRateTable WHERE $exRateDate = (SELECT MAX($exRateDate) FROM $exChangeRateTable) ORDER BY $exRateDate ASC');

//    var moneyMapList = await getMoneyMapList();
    int count = exChangeRateMapList.length;

    List<ExChangeRate> exChangeRateList = List<ExChangeRate>();
    for (int i = 0; i < count; i++) {
      exChangeRateList.add(ExChangeRate.fromMapObject(exChangeRateMapList[i]));
    }

    return exChangeRateList;
  }

  Future<int> insertExChangeRate(ExChangeRate exChangeRate) async {
    Database db = await this.database;
    var result = await db.insert(exChangeRateTable, exChangeRate.toMap());
    return result;
  }

  Future<int> getCountTodayExxrChangeRate(String today) async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery(
        'SELECT COUNT(*) FROM $exChangeRateTable where $exRateDate = $today');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Map<String, dynamic>>> getNationExchangeRate(String unit) async {
    Database db = await this.database;

    var exChangeRateMapList = await db.rawQuery(
        'SELECT * FROM $exChangeRateTable WHERE $exRateDate = (SELECT MAX($exRateDate) FROM $exChangeRateTable) AND $exCurUnit = "$unit"');

//    var moneyMapList = await getMoneyMapList();
//    int count = exChangeRateMapList.length;
//
//    List<ExChangeRate> exChangeRateList = List<ExChangeRate>();
//    for (int i = 0; i < count; i++) {
//      exChangeRateList.add(ExChangeRate.fromMapObject(exChangeRateMapList[i]));
//    }

    return exChangeRateMapList;
  }

  Future<int> deleteExChangeRate(String date) async {
    Database db = await this.database;
    var result = await db
        .rawDelete('DELETE FROM $exChangeRateTable WHERE $exRateDate = $date');
//    var result = await db.update(moneyTable, money.toMap(), where: '$colId = ? ',whereArgs: [money.id]);
    return result;
  }

  Future<int> deleteAllExChangeRate() async {
    Database db = await this.database;
    var result = await db.rawDelete('DELETE FROM $exChangeRateTable');
//    var result = await db.update(moneyTable, money.toMap(), where: '$colId = ? ',whereArgs: [money.id]);
    return result;
  }
}
