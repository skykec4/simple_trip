import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:myapp/models/exchange_rate.dart';

class Store with ChangeNotifier {
  String _currentNation = '미국';
  String _targetNation = '한국';

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

  void setNationList(List<Map<String, dynamic>> list1,List<Map<String, dynamic>> list2){
    _currentNationMap = list1;
    _targetNationMap = list2;
    notifyListeners();
  }
}

class UseMoney {
  String title;
  int useMoney;
}
