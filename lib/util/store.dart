import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:localstorage/localstorage.dart';

class Money with ChangeNotifier {
  var storage;
  var _today;
  var _totalList;

  Money(this._today, this.storage);

  get getToday => _today;

  get totalList => _totalList;

  void setToday(Map todayList) {
    if (_today == null) {
      _today = [todayList];
    } else {
      _today.add(todayList);
    }
print('들어가버렸! $_today');

    notifyListeners();
    setLocalStorageToday(_today);
    printt();
  }

  void setLocalStorageToday(todayList) {

    var _today = storage.getItem("use_money");

    _today[nowNoDash] = todayList;


    print('저장끝');
    printt();
  }

  void printt() {
    var _today = storage.getItem("use_money");
    print('_today _today _today2222  :::: $_today');
  }

  int total = 0;

  //오늘날짜
  var todayList = [];
  int todayTotalMoney = 0;
  var now = DateFormat('yyyy-MM-dd').format(DateTime.now());
  var nowNoDash = DateFormat('yyyyMMdd').format(DateTime.now());

  //세팅

  //메소드
  //오늘
  get getNow => now; //날짜
  get getTodayTotalMoney => todayTotalMoney; //총합
  get getTodayList => todayList;

  void setTodayTotalMoney(int useMoney) {
    todayTotalMoney += useMoney;
    notifyListeners();
  }

  void setTodayList(String title, String money) {
    final list = {'title': title, 'money': money};
    todayList.add(list);
    todayTotalMoney += int.parse(money);
    setDataToday();
    notifyListeners();
  }

  void removeTodayList(int index) {
    todayTotalMoney -= todayList[index]['money'];

    todayList.removeAt(index);

    notifyListeners();
  }

//총합

//세팅
  setDataToday() async {
    print('!!!!!!!!!!!');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('@@@@@@@@@@@@@');
    await prefs.setStringList('today', todayList);

    print('################');
    final list = prefs.get('today');
    print(list.toString());
  }

/*
  --save

  final prefs = await SharedPreferences.getInstance();
  prefs.setInt('counter', counter);
  */

/*
  --get
    final prefs = await SharedPreferences.getInstance();
    final counter = prefs.getInt('counter') ?? 0;
  */

}

class UseMoney {
  String title;
  int useMoney;
}
