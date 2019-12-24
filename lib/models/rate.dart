class Rate {
  final result;
  final cur_unit;
  final ttb;
  final tts;
  final deal_bas_r;
  final bkpr;
  final yy_efee_r;
  final ten_dd_efee_r;
  final kftc_bkpr;
  final kftc_deal_bas_r;
  final cur_nm;

//  Rate({this.result, this.cur_unit, this.ttb, this.tts, this.deal_bas_r, this.bkpr, this.yy_efee_r, this.ten_dd_efee_r, this.kftc_bkpr, this.kftc_deal_bas_r, this.lcur_nm});
  Rate(
      {this.result,
        this.cur_unit,
        this.ttb,
        this.tts,
        this.deal_bas_r,
        this.bkpr,
        this.yy_efee_r,
        this.ten_dd_efee_r,
        this.kftc_bkpr,
        this.kftc_deal_bas_r,
        this.cur_nm});

  factory Rate.fromJson(Map<String, dynamic> json) {
    return Rate(
      result: json['result'],
      cur_unit: json['cur_unit'],
      ttb: json['ttb'],
      tts: json['tts'],
      deal_bas_r: json['deal_bas_r'],
      bkpr: json['bkpr'],
      yy_efee_r: json['yy_efee_r'],
      ten_dd_efee_r: json['ten_dd_efee_r'],
      kftc_bkpr: json['kftc_bkpr'],
      kftc_deal_bas_r: json['kftc_deal_bas_r'],
      cur_nm: json['cur_nm'],
    );
  }
}