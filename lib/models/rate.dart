// To parse this JSON data, do
//
//     final rate = rateFromJson(jsonString);

import 'dart:convert';

List<Rate> rateFromJson(String str) => List<Rate>.from(json.decode(str).map((x) => Rate.fromJson(x)));

String rateToJson(List<Rate> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Rate {
  int result;
  String curUnit;
  String ttb;
  String tts;
  String dealBasR;
  String bkpr;
  String yyEfeeR;
  String tenDdEfeeR;
  String kftcBkpr;
  String kftcDealBasR;
  String curNm;

  Rate({
    this.result,
    this.curUnit,
    this.ttb,
    this.tts,
    this.dealBasR,
    this.bkpr,
    this.yyEfeeR,
    this.tenDdEfeeR,
    this.kftcBkpr,
    this.kftcDealBasR,
    this.curNm,
  });

  factory Rate.fromJson(Map<String, dynamic> json) => Rate(
    result: json["result"],
    curUnit: json["cur_unit"],
    ttb: json["ttb"],
    tts: json["tts"],
    dealBasR: json["deal_bas_r"],
    bkpr: json["bkpr"],
    yyEfeeR: json["yy_efee_r"],
    tenDdEfeeR: json["ten_dd_efee_r"],
    kftcBkpr: json["kftc_bkpr"],
    kftcDealBasR: json["kftc_deal_bas_r"],
    curNm: json["cur_nm"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "cur_unit": curUnit,
    "ttb": ttb,
    "tts": tts,
    "deal_bas_r": dealBasR,
    "bkpr": bkpr,
    "yy_efee_r": yyEfeeR,
    "ten_dd_efee_r": tenDdEfeeR,
    "kftc_bkpr": kftcBkpr,
    "kftc_deal_bas_r": kftcDealBasR,
    "cur_nm": curNm,
  };
}
