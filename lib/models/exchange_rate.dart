class ExChangeRate {
  String _exRateDate; //가져온 날짜
  String _exCurUnit; //통화코
  String _exCurNm; //국가/통화명
  String _exTTB; //송금 받으실때
  String _exTTS; //송금 보낼때
  String _exDealBasR;

  ExChangeRate(this._exRateDate, this._exCurUnit, this._exCurNm, this._exTTB,
      this._exTTS, this._exDealBasR);

  String get getExDealBasR => _exDealBasR;

  void setExDealBasR(String value) {
    _exDealBasR = value;
  }

  String get getExTTS => _exTTS;

  void setExTTS(String value) {
    _exTTS = value;
  }

  String get getExTTB => _exTTB;

  void setExTTB(String value) {
    _exTTB = value;
  }

  String get getExCurNm => _exCurNm;

  void setExCurNm(String value) {
    _exCurNm = value;
  }

  String get getExCurUnit => _exCurUnit;

  void setExCurUnit(String value) {
    _exCurUnit = value;
  }

  String get getExRateDate => _exRateDate;

  void setExRateDate(String value) {
    _exRateDate = value;
  }
//
//  int get getExColId => _exColId;
//
//  void setExColId(int value) {
//    _exColId = value;
//  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

//    if (_exColId != null) {
//      map['id'] = _exColId;
//    }

    map['rate_date'] = _exRateDate;
    map['cur_unit'] = _exCurUnit;
    map['cur_name'] = _exCurNm;
    map['ttb'] = _exTTB;
    map['tts'] = _exTTS;
    map['deal_bas_r'] = _exDealBasR;

    return map;
  }

  ExChangeRate.fromMapObject(Map<String, dynamic> map) {
//    this._exColId = map['id'];
    this._exRateDate = map['rate_date'];
    this._exCurUnit = map['cur_unit'];
    this._exCurNm = map['cur_name'];
    this._exTTB = map['ttb'];
    this._exTTS = map['tts'];
    this._exDealBasR = map['deal_bas_r'];
  }
}
