class Money {
  int _id;
  String _category;

  String _title;
  int _money;
  String _date;
  int _total;

//  Money(this._title, this._money, this._date);

  Money(this._category, this._title, this._money, this._date);

  int get id => _id;

  String get category => _category;

  String get title => _title;

  int get money => _money;

  String get date => _date;

  int get total => _total;

  set category(String value) {
    this._category = value;
  }

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set date(String newDate) => this._date = newDate;

  set money(int newMoney) => this._money = newMoney;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map['id'] = _id;
    }

    map['category'] = _category;
    map['title'] = _title;
    map['money'] = _money;
    map['date'] = _date;

    if (total != null) {
      map['total'] = _total;
    }

    return map;
  }

  Money.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._category = map['category'];
    this._title = map['title'];
    this._money = map['money'];
    this._date = map['date'];
    this._total = map['total'];
  }
}
