import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:myapp/db/database_helper.dart';
import 'package:myapp/models/exchange_rate.dart';
import 'package:myapp/models/money.dart';
import 'package:myapp/models/rate.dart';
import 'package:myapp/utils/nation_flag.dart';
import 'package:sqflite/sqflite.dart';

class Store with ChangeNotifier {
  DatabaseHelper databaseHelper = DatabaseHelper();

  //환율정보 -> api 호출시 담는값
  List<Rate> _exChangeRateInfo;

  get exChangeRateInfo => this._exChangeRateInfo;

  void setExChangeRateInfo(List<Rate> rate) {
    this._exChangeRateInfo = rate;
    notifyListeners();
  }

  //유저 데이터 정보 (현재 설정된 유저 데이터)   db : getUserData
  Map<String, dynamic> _userData;

  Map<String, dynamic> get userData => _userData;

  void setUserData(Map<String, dynamic> value) {
    this._userData = value;
    notifyListeners();
  }

  //오늘 데이터
  List<Money> _todayMoneyList;

  List<Money> get todayMoneyList => _todayMoneyList;

  void setTodayMoneyList(List<Money> value) {
    this._todayMoneyList = value;
    notifyListeners();
  }

  void updateTodayMoneyList([String day]) {
    final Future<Database> dbFuture = databaseHelper.initDatabase();
    final _date = day != null
        ? day
        : DateFormat('yyyyMMdd').format(DateTime.now().toLocal());

    print('[[[[[[[[[get user!!! ]]]]] : $_date');
    dbFuture.then((database) {
      Future<List<Money>> moneyListFuture =
          databaseHelper.getTodayList(_date, this.userData['category']);

      moneyListFuture.then((moneyList) {
        setTodayMoneyList(moneyList);
      });
    });
  }

  void deleteTodayMoneyList(int index, int id) async {

    int result = await databaseHelper.deleteMoney(id);
    this._todayMoneyList.removeAt(index);
    if (result != 0) {
      print('삭제완ㄹ!!!');
//      _showSnackBar(context, '삭제되었습니다.');
//      updateListView();
    }
    notifyListeners();
  }


  DateTime _selectedDate = DateTime.now().toLocal();


  DateTime get selectedDate => _selectedDate;

  void setSelectedDate(DateTime value) {
    this._selectedDate = value;
  }


  ///////////////////////
  String _userSelectedNation; //category

  String get getUserSelectedNation => _userSelectedNation;

  set setUserSelectedNation(String value) {
    this._userSelectedNation = value;
  }

  void setUserSelectedNation2(String value) {
    this._userSelectedNation = value;
    notifyListeners();
  }

  String _currentNation = '미국';
  String _targetNation = '한국';
  String _rateDate = '';

  String get getRateDate => _rateDate;

  set setRateDate(String value) {
    this._rateDate = value;
    notifyListeners();
  }

  List<Map<String, dynamic>> _currentNationMap = [];
  List<Map<String, dynamic>> _targetNationMap = [];

  get getCurrentNation => _currentNation;

  get getCurrentNationMap => _currentNationMap;

  get getTargetNation => _targetNation;

  get getTargetNationMap => _targetNationMap;

  void setCurrentNation(String nationName) {
    _currentNation = nationName;
    notifyListeners();
  }

  void setTargetNation(String nationName) {
    _targetNation = nationName;
    notifyListeners();
  }

  void setCurrentNationMap(List<Map<String, dynamic>> list) {
    _currentNationMap = list;
    notifyListeners();
  }

  void setTargetNationMap(List<Map<String, dynamic>> list) {
    _targetNationMap = list;
    notifyListeners();
  }

  void setNationList(
      List<Map<String, dynamic>> list1, List<Map<String, dynamic>> list2) {
    _currentNationMap = list1;
    _targetNationMap = list2;
    notifyListeners();
  }
}
