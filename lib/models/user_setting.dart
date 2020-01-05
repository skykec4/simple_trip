class UserSetting{
  int _userSettingId;
  String _userSettingCategory;


  UserSetting(this._userSettingCategory);

  int get userSettingId => _userSettingId;

  set userSettingId(int value) {
    this._userSettingId = value;
  }

  String get userSettingCategory => _userSettingCategory;

  set userSettingCategory(String value) {
    this._userSettingCategory = value;
  }


  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (_userSettingId != null) {
      map['id'] = _userSettingId;
    }

    map['category'] = _userSettingCategory;

    return map;
  }

  UserSetting.fromMapObject(Map<String, dynamic> map) {
    this._userSettingId = map['id'];
    this._userSettingCategory = map['category'];
  }
}