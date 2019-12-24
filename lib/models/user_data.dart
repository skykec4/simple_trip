class UserData {
  String _userId;
  String _userCategory;

  String _userCurrentNation;

  String _userTargetNation;

  String _userTotalMoney;

  String get userId => _userId;

  set userId(String value) {
    this._userId = value;
  }

  String get userCategory => _userCategory;

  set userCategory(String value) {
    this._userCategory = value;
  }

  String get userCurrentNation => _userCurrentNation;

  set userCurrentNation(String value) {
    this._userCurrentNation = value;
  }

  String get userTargetNation => _userTargetNation;

  set userTargetNation(String value) {
    this._userTargetNation = value;
  }

  String get userTotalMoney => _userTotalMoney;

  set userTotalMoney(String value) {
    this._userTotalMoney = value;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (_userId != null) {
      map['id'] = _userId;
    }

    map['category'] = _userCategory;
    map['current_nation'] = _userCurrentNation;
    map['target_nation'] = _userTargetNation;
    map['total_money'] = _userTotalMoney;

    return map;
  }

  UserData.fromMapObject(Map<String, dynamic> map) {
    this._userId = map['id'];
    this._userCategory = map['category'];
    this._userCurrentNation = map['current_nation'];
    this._userTargetNation = map['target_nation'];
    this._userTotalMoney = map['total_money'];
  }
}
