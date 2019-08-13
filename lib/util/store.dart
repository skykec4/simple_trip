import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:localstorage/localstorage.dart';

class Money with ChangeNotifier {

  int total = 0;

  //오늘날짜
  var todayList = [];
  int todayTotalMoney = 0;
  var now = DateFormat('yyyy-MM-dd').format(DateTime.now());

  //총합
  var totalList = [];

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
  void removeTodayList(int index){

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
