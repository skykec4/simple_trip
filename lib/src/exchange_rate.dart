import 'package:flutter/material.dart';
//import 'package:http/http.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

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

Future<List<Rate>> fetchPhotos() async {
  var now = new DateTime.now();

  String year = now.year.toString();
  String month = now.month.toString().length ==1 ? "0"+now.month.toString() :now.month.toString();
  String day = now.day.toString();


  final response = await http.post(
      'https://www.koreaexim.go.kr/site/program/financial/exchangeJSON?authkey=nHpyy6i0GGVLJeExq4ZrZnf13tWQ89Lk&searchdate=$year$month$day&data=AP01',
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json;',
      });

  print('response.body : ${utf8.decode(response.bodyBytes).toString()}');
  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parsePhotos, utf8.decode(response.bodyBytes));
}

List<Rate> parsePhotos(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Rate>((json) => Rate.fromJson(json)).toList();
}

class ExchangeRate extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<Rate>>(
          future: fetchPhotos(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print('엥?' + snapshot.error);
            }
            return snapshot.hasData
                ? PhotosList(photos: snapshot.data)
                : Center(child: CircularProgressIndicator());

          }),
    );
  }
}

String returnUrl(String nation){

  var url = 'https://www.countryflags.io/$nation/shiny/64.png';

  return url;
}

class PhotosList extends StatelessWidget {

  final List<Rate> photos;



  List unit = [
    "AED",
    "AUD",
    "BHD",
    "CAD",
    "CHF",
    "CNH",
    "DKK",
    "EUR",
    "GBP",
    "HKD",
    "IDR(100)",
    "JPY(100)",
    "KRW",
    "KWD",
    "MYR",
    "NOK",
    "NZD",
    "SAR",
    "SEK",
    "SGD",
    "THB",
    "USD"
  ];

  List nation = [
    "AE",
    "AU",
    "BH",
    "CA",
    "CH",
    "CN",
    "DK",
    "EU",
    "GB",
    "HK",
    "ID",
    "JP",
    "KR",
    "KW",
    "MY",
    "NO",
    "NZ",
    "SA",
    "SE",
    "SG",
    "TH",
    "US"
  ];

  Map nationName = {
    "AE": '아랍에미리트',
    "AU" : '호주',
    "BH": '바레인',
    "CA": '캐나다',
    "CH": '스위스',
    "CN": '중국',
    "DK": '덴마크',
    "EU": '유로',
    "GB": '영국',
    "HK": '홍콩',
    "ID": '인도네시아',
    "JP": '원숭이',
    "KR": '한국짱!',
    "KW": '쿠웨이트',
    "MY": '말레이시아',
    "NO": '노르웨이',
    "NZ": '뉴질랜드',
    "SA": '사우디',
    "SE": '스웨덴',
    "SG": '싱가포르',
    "TH": '태국',
    "US": '미국'
  };

  PhotosList({Key key, this.photos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: photos.length,
        itemBuilder: (context, index) {

          var flags = int.parse(unit.indexOf(photos[index].cur_unit).toString());
          return Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    elevation: 10,
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading:
                          FadeInImage.assetNetwork(width: 50,height: 50,placeholder: 'assets/nation_flag_loading2.gif', image: returnUrl(nation[flags])),
                          title: Text("${nationName[nation[flags]]} (${photos[index].cur_nm.split(" ").length == 1 ?photos[index].cur_nm :photos[index].cur_nm.split(" ")[1]})"),
                          subtitle: Text("${photos[index].cur_unit}"),
                          trailing: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                Text(" ${photos[index].cur_unit} : 1"),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(" KRW : ${photos[index].deal_bas_r}")
                              ],
                            ),
                          ),
                        ),
//                        Text("통화코드 : "+photos[index].cur_unit.toString()),
//                        Text("국가 + 통화코드명"+photos[index].cur_nm.toString()),
//                        Text("송금 받으실 때 : "+photos[index].ttb.toString()),
//                        Text("송금 보내실 때" + photos[index].tts.toString()),
//                        Text("매매기준율 : " + photos[index].deal_bas_r.toString()),
//                        Text("장부가격 : "+photos[index].bkpr.toString()),
//                        Text("년환가료율 : " + photos[index].yy_efee_r.toString()),
//                        Text("10일 환거료율 : " + photos[index].ten_dd_efee_r.toString()),
//                        Text("서울외국환중계 매매기준율"+photos[index].kftc_deal_bas_r.toString()),
//                        Text("서울외국환중계 장부가격" + photos[index].kftc_bkpr.toString()),
                      ],
                    )),
              ));
        });

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        print('예~~~~~~~~~~~!!    ' + photos[index].toString());
        return Text('d');
//        return Image.network(photos[index].thumbnailUrl);
      },
    );
  }
}

class An extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('An')),
      body: Column(
        children: <Widget>[
          Text('An'),
          RaisedButton(
            child: Text('click'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(
            height: 300,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Hero(
                tag: 'imageHero',
                child: Icon(Icons.add),
              ),
            ),
          )
        ],
      ),
    );
  }
}