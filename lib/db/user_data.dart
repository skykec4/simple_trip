import 'package:myapp/db/database_helper.dart';
import 'package:myapp/models/user_data_model.dart';
import 'package:myapp/models/user_setting.dart';
import 'package:sqflite/sqflite.dart';

class UserDataDatabase {
  String userSettingTable = 'user_settings_table';
  String userSettingId = 'id';
  String userSettingCategory = 'category';

  String userDataTable = 'user_data_table';
  String userId = 'id';
  String userCategory = 'category';
  String userCurrentNation = 'current_nation';
  String userTargetNation = 'target_nation';
  String userTotalMoney = 'total_money';
  String userRegisterDate = 'register_date';

  String exChangeRateTable = 'exchange_rate_table';
  String exRateDate = 'rate_date'; //가져온 날짜
  String exCurUnit = 'cur_unit'; //통화코드
  String exCurNm = 'cur_name'; //국가/통화명
  String exTTB = 'ttb'; //송금 받으실때
  String exTTS = 'tts'; //송금 보낼때
  String exDealBasR = 'deal_bas_r'; //매매기준율

  DatabaseHelper _db = DatabaseHelper();

  Future<Database> init() async {
    return _db.initDatabase();
  }

  Future<List<Map<String,dynamic>>> getUserData() async {
    Database db = await _db.database;

    var userMapList = await db
        .rawQuery('''
        SELECT $userCategory, 
               $userCurrentNation,
               (SELECT $exCurNm FROM $exChangeRateTable WHERE $exCurUnit = "$userCurrentNation") AS cur_nm,
               (SELECT $exDealBasR FROM $exChangeRateTable WHERE $exCurUnit = "$userCurrentNation") AS cur_rate,
               $userTargetNation,
               (SELECT $exCurNm FROM $exChangeRateTable WHERE $exCurUnit = "$userTargetNation") AS tar_nm,
               (SELECT $exDealBasR FROM $exChangeRateTable WHERE $exCurUnit = "$userTargetNation") AS tar_rate, 
               $userTotalMoney, 
               $userRegisterDate
        FROM $userDataTable
        WHERE $userCategory = (SELECT $userSettingCategory FROM $userSettingTable) 
        ''');
    return userMapList;
  }

  Future<List<UserDataModel>> getUserList() async {
    Database db = await _db.database;

    var userMapList = await db.rawQuery('''
        SELECT * FROM $userDataTable ORDER BY $userRegisterDate DESC
        ''');
    int count = userMapList.length;

    List<UserDataModel> userList = List<UserDataModel>();
    for (int i = 0; i < count; i++) {
      userList.add(UserDataModel.fromMapObject(userMapList[i]));
    }

    return userList;
  }

  Future<int> insertUserDataModel(UserDataModel data) async {
    Database db = await _db.database;
    var result = await db.insert(userDataTable, data.toMap());
    return result;
  }

  Future<int> insertUserSetting(UserSetting data) async {
    Database db = await _db.database;
    var result = await db.insert(userSettingTable, data.toMap());
    return result;
  }

  Future<List<Map<String, dynamic>>> getTotalMoney(String category) async {
    Database db = await _db.database;

    var userMapList = await db.rawQuery('''
    SELECT $userCurrentNation, 
           (SELECT $exCurNm FROM $exChangeRateTable WHERE $exCurUnit = "$userCurrentNation") AS cur,
           $userTargetNation, 
           (SELECT $exCurNm FROM $exChangeRateTable WHERE $exCurUnit = "$userTargetNation") AS tar, 
           $userTotalMoney
    FROM $userDataTable 
    WHERE $userCategory = "$category"
    ''');

    return userMapList;
//    return userMapList.length > 0 ? userMapList[0]["total_money"] : 0;
  }
}
