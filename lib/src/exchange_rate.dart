import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/api/api.dart';
import 'package:myapp/models/exchange_rate.dart';
import 'package:myapp/models/rate.dart';
import 'package:myapp/utils/store.dart';
import 'package:myapp/db/database_helper.dart';
import 'package:myapp/utils/integer_format.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class ExchangeRateUI extends StatefulWidget {
  @override
  _ExchangeRateUIState createState() => _ExchangeRateUIState();
}

class _ExchangeRateUIState extends State<ExchangeRateUI> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<ExChangeRate> exChangeList;

  @override
  void initState() {
    super.initState();
    updateListView();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void updateListView() async {
    final Future<Database> dbFuture = databaseHelper.initDatabase();
    dbFuture.then((database) {
      Future<List<ExChangeRate>> moneyListFuture =
          databaseHelper.getRecentExchangeRate();
      String today = DateFormat('yyyyMMdd').format(DateTime.now().toLocal());
//      List today2 = DateFormat('yyyyMMdd/Hmm/EEE')
//          .format(DateTime.now().toLocal())
//          .split('/');

      moneyListFuture.then((exChangeRateList) {
//        print('exChangeRateList : ${exChangeRateList.length}');
//        print('exChangeRateList : ${exChangeRateList[0].getExRateDate}');
        if (exChangeRateList.length == 0 || exChangeRateList[0].getExRateDate != today) {
          print('새로받아오쥬?');
          if(exChangeRateList.length > 0){
            print('삭제!');
            databaseHelper.deleteAllExChangeRate();
          }
          print('지나간다~');

          Api.fetchPhotos().then((list){
            List<Rate> rate = list;
            List<ExChangeRate> _exChangeRateList = [];

            for (var i = 0; i < rate.length; i++) {
              print('rateList : ${rate[i]}');
              _save(Api.rateDate != '' ? Api.rateDate : today, rate[i].curUnit, rate[i].curNm, rate[i].ttb,
                  rate[i].tts, rate[i].dealBasR);
              _exChangeRateList.add(ExChangeRate(
                  Api.rateDate != '' ? Api.rateDate : today,
                  rate[i].curUnit,
                  rate[i].curNm,
                  rate[i].ttb,
                  rate[i].tts,
                  rate[i].dealBasR));

              if (rate[i].curUnit == 'USD' || rate[i].curUnit == 'KRW') {
                List<Map<String, dynamic>> list = [
                  {
                    'rate_date': Api.rateDate,
                    'cur_unit': rate[i].curUnit,
                    'cur_name': rate[i].curNm,
                    'ttb': rate[i].ttb,
                    'tts': rate[i].tts,
                    'deal_bas_r': rate[i].dealBasR
                  }
                ];

                if (rate[i].curUnit == "USD") {
                  Provider.of<Store>(context).setCurrentNationMap(list);
                } else {
                  Provider.of<Store>(context).setTargetNationMap(list);
                }
              }
            }


            setState(() => exChangeList = _exChangeRateList);

          });

        } else {
          print('원래 있쮸?');
          setState(() => exChangeList = exChangeRateList);

          if (Provider.of<Store>(context).getCurrentNationMap.length == 0) {
            databaseHelper.getNationExchangeRate('USD').then((res) {
              Provider.of<Store>(context).setCurrentNationMap(res);
            });
          }

          if (Provider.of<Store>(context).getTargetNationMap.length == 0) {
            databaseHelper.getNationExchangeRate('KRW').then((res) {
              Provider.of<Store>(context).setTargetNationMap(res);
            });
          }
        }
      });
    });
  }

  void _save(String date, String curUnit, String curNm, String ttb, String tts,
      String dealBasR) async {
    ExChangeRate exChangeRate =
        new ExChangeRate(date, curUnit, curNm, ttb, tts, dealBasR);



    int result = await databaseHelper.insertExChangeRate(exChangeRate);



    if (result != 0) {
      print('성공');
    } else {
      print('실패');
    }
  }


  @override
  Widget build(BuildContext context) {
//    if (exChangeList == null) {
//      updateListView();
////      updateListView2();
//    }
//    print('exChangeList : $exChangeList');

    if (exChangeList == null) {
      return Center(child: CircularProgressIndicator());
    } else if (Provider.of<Store>(context).getCurrentNationMap.length == 0) {
      return Center(child: CircularProgressIndicator());
    } else {
      return PhotosList(photos: exChangeList);
    }

//    return Center(
//      child: FutureBuilder<List<Rate>>(
//          future: Api.fetchPhotos(),
//          builder: (context, snapshot) {
//            if (snapshot.hasError) {
//              print('엥?' + snapshot.error);
//            }
//            return snapshot.hasData
//                ? PhotosList(photos: snapshot.data)
//                : Center(child: CircularProgressIndicator());
//          }),
//    );
  }
}

String returnUrl(String nation) {
  return 'https://www.countryflags.io/$nation/shiny/64.png';
}

class PhotosList extends StatefulWidget {
  final List<ExChangeRate> photos;

  PhotosList({Key key, this.photos}) : super(key: key);

  @override
  _PhotosListState createState() => _PhotosListState();
}

class _PhotosListState extends State<PhotosList> {
  List unit = [
    "AED",
    "AUD",
    "BHD",
    "BND",
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
    "BN",
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
    "AU": '호주',
    "BH": '바레인',
    "BN": '브루나이',
    "CA": '캐나다',
    "CH": '스위스',
    "CN": '중국',
    "DK": '덴마크',
    "EU": '유로',
    "GB": '영국',
    "HK": '홍콩',
    "ID": '인도네시아',
    "JP": '일본',
    "KR": '한국',
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
  List nationList = [
    '아랍에미리트',
    '호주',
    '바레인',
    '브루나이',
    '캐나다',
    '스위스',
    '중국',
    '덴마크',
    '유로',
    '영국',
    '홍콩',
    '인도네시아',
    '일본',
    '한국',
    '쿠웨이트',
    '말레이시아',
    '노르웨이',
    '뉴질랜드',
    '사우디',
    '스웨덴',
    '싱가포르',
    '태국',
    '미국'
  ];

  List typeList = ['송금 받을때', '송금 보낼때', '매매기준율'];

  String type = '매매기준율';
  TextEditingController _current = TextEditingController();

  TextEditingController _target = TextEditingController();

  String _cur = '';
  DatabaseHelper databaseHelper = DatabaseHelper();

  void updateCurrentNation(String nation) async {
    final Future<Database> dbFuture = databaseHelper.initDatabase();
    dbFuture.then((database) {
      Future<List<Map<String, dynamic>>> cur = databaseHelper
          .getNationExchangeRate(unit[nationList.indexOf(nation)]);

      cur.then((res) {
        Provider.of<Store>(context).setCurrentNationMap(res);
        updateCurrentToTargetAmount(res[0]['deal_bas_r'].replaceAll(',', ''));
      });
    });
  }

  void updateTargetNation(String nation) async {
    final Future<Database> dbFuture = databaseHelper.initDatabase();
    dbFuture.then((database) {
      Future<List<Map<String, dynamic>>> target = databaseHelper
          .getNationExchangeRate(unit[nationList.indexOf(nation)]);

      target.then((res) {
        Provider.of<Store>(context).setTargetNationMap(res);
        updateCurrentToTargetAmount(res[0]['deal_bas_r'].replaceAll(',', ''));
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _current.dispose();
    _target.dispose();
  }

  String stringToDateFormat(String date) {
    return '${date.substring(0, 4)}-${date.substring(4, 6)}-${date.substring(6)}';
  }

  void updateCurrentToTargetAmount(String amount) {
    var current = double.parse(Provider.of<Store>(context)
        .getCurrentNationMap[0]['deal_bas_r']
        .replaceAll(',', ''));
    var target = double.parse(Provider.of<Store>(context)
        .getTargetNationMap[0]['deal_bas_r']
        .replaceAll(',', ''));

    int _currentAdd = Provider.of<Store>(context)
                .getCurrentNationMap[0]['cur_unit']
                .indexOf('100') <
            0
        ? 1
        : 100;
    int _targetAdd = Provider.of<Store>(context)
                .getTargetNationMap[0]['cur_unit']
                .indexOf('100') <
            0
        ? 1
        : 100;
    if (_current.text.indexOf("-") > -1) {
      setState(() => _current.text = _current.text.replaceAll('-', ''));
    } else if (_current.text != '') {
      setState(() => _target.text = (double.parse(_current.text) *
              (((current / _currentAdd) / (target) * _targetAdd)))
          .toStringAsFixed(2));
    } else {
      setState(() => _target.clear());
    }
  }

  void updateTargetToCurrentAmount(String amount) {
    var current = double.parse(Provider.of<Store>(context)
        .getCurrentNationMap[0]['deal_bas_r']
        .replaceAll(',', ''));
    var target = double.parse(Provider.of<Store>(context)
        .getTargetNationMap[0]['deal_bas_r']
        .replaceAll(',', ''));

    int _currentAdd = Provider.of<Store>(context)
                .getCurrentNationMap[0]['cur_unit']
                .indexOf('100') <
            0
        ? 1
        : 100;
    int _targetAdd = Provider.of<Store>(context)
                .getTargetNationMap[0]['cur_unit']
                .indexOf('100') <
            0
        ? 1
        : 100;

    if (_target.text.indexOf("-") > -1) {
      setState(() => _target.text = _target.text.replaceAll('-', ''));
    } else if (_target.text != '') {
      setState(() => _current.text = (double.parse(amount) *
              (((target / _targetAdd) / (current) * _currentAdd)))
          .toStringAsFixed(2));
    } else {
      setState(() => _current.clear());
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var provider = Provider.of<Store>(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            TabBar(
              onTap: (tap) {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: <Widget>[
                Tab(text: '환율조회'),
                Tab(text: '전체환율'),
              ],
            ),
            Flexible(
              child: TabBarView(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Container(
                      child: Column(children: <Widget>[
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              border: Border.all(color: Colors.grey[400])),
                          width: width * 0.85,
                          height: 180,
                          child: Column(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black54.withOpacity(.1),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                                ),
                                height: 50,
                                padding: EdgeInsets.only(left: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    FadeInImage.assetNetwork(
                                        width: 35,
                                        placeholder:
                                            'assets/nation_flag_loading2.gif',
                                        image: returnUrl(nation[
                                            nationList.indexOf(
                                                provider.getCurrentNation)])),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Container(
                                      child: DropdownButton<String>(
                                        isDense: true,
                                        focusColor: Colors.white,
                                        elevation: 30,
                                        value: provider.getCurrentNation,
                                        onChanged: (value) {
                                          provider.setCurrentNation(value);
                                          updateCurrentNation(value);
                                        },
                                        items: nationList
                                            .map<DropdownMenuItem<String>>(
                                                (value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Container(
                                                width: width * 0.3,
                                                child: Text(
                                                  value,
                                                )),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: TextField(
                                  textAlign: TextAlign.right,
                                  controller: _current,
                                  keyboardType: TextInputType.number,

                                  onChanged: (value) {
                                    updateCurrentToTargetAmount(value);
                                  },
                                ),
                              ),
                              Flexible(
                                child: Container(
                                  padding: EdgeInsets.only(right: 20),
                                  alignment: Alignment.centerRight,
                                  child: _current.text != ''
                                      ? Text(
                                          '${_current.text} ${provider.getCurrentNationMap[0]["cur_name"].split(' ').length == 1 ? provider.getCurrentNationMap[0]["cur_name"].split(' ')[0] : provider.getCurrentNationMap[0]["cur_name"].split(' ')[1]} (${provider.getCurrentNationMap[0]["cur_unit"].indexOf('100') < 0 ? provider.getCurrentNationMap[0]["cur_unit"] : provider.getCurrentNationMap[0]["cur_unit"].substring(0, provider.getCurrentNationMap[0]["cur_unit"].indexOf('100') - 1)})',
                                          style:
                                              TextStyle(color: Colors.black54),
                                        )
                                      : Text(''),
                                ),
                              )
                            ],
                          ),
                        ),
                        Icon(
                          Icons.pause,
                          size: height * 0.08,
                          color: Colors.black54.withOpacity(.5),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              border: Border.all(color: Colors.grey[400])),
                          width: width * 0.85,
                          height: 180,
                          child: Column(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black54.withOpacity(.1),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                                ),
                                height: 50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
//                crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    FadeInImage.assetNetwork(
                                        width: 35,
                                        height: 50,
                                        placeholder:
                                            'assets/nation_flag_loading2.gif',
                                        image: returnUrl(nation[
                                            nationList.indexOf(
                                                provider.getTargetNation)])),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    DropdownButton<String>(
                                      value: provider.getTargetNation,
                                      onChanged: (value) {
                                        provider.setTargetNation(value);
                                        updateTargetNation(value);
                                      },
                                      items: nationList
                                          .map<DropdownMenuItem<String>>(
                                              (value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Container(
                                              width: width * 0.3,
                                              child: Text(value)),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: TextField(
                                  textAlign: TextAlign.right,
                                  controller: _target,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    updateTargetToCurrentAmount(value);
                                  },
                                ),
                              ),
                              Flexible(
                                child: Container(
                                  padding: EdgeInsets.only(right: 20),
                                  alignment: Alignment.centerRight,
                                  child: _target.text != ''
                                      ? Text(
                                          '${_target.text} ${provider.getTargetNationMap[0]["cur_name"].split(' ').length == 1 ? provider.getTargetNationMap[0]["cur_name"].split(' ')[0] : provider.getTargetNationMap[0]["cur_name"].split(' ')[1]} (${provider.getTargetNationMap[0]["cur_unit"].indexOf('100') < 0 ? provider.getTargetNationMap[0]["cur_unit"] : provider.getTargetNationMap[0]["cur_unit"].substring(0, provider.getTargetNationMap[0]["cur_unit"].indexOf('100') - 1)})',
                                          style:
                                              TextStyle(color: Colors.black54),
                                        )
                                      : Text(''),
                                ),
                              )
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 10, left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '기준일 : ${stringToDateFormat(widget.photos[0].getExRateDate)}',
                              textScaleFactor: 1.3,
                            ),
                            Container(
                                alignment: Alignment.centerRight,
                                child: DropdownButton(
                                  value: type,
                                  onChanged: (value) {
                                    setState(() {
                                      type = value;
                                    });
                                  },
                                  items: typeList.map((list) {
                                    return DropdownMenuItem(
                                        value: list, child: Text(list));
                                  }).toList(),
                                )),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: widget.photos.length,
                            itemBuilder: (context, index) {
                              var flags = int.parse(unit
                                  .indexOf(widget.photos[index].getExCurUnit)
                                  .toString());

                              return Container(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    elevation: 10,
                                    child: Column(
                                      children: <Widget>[
                                        ListTile(
                                          leading: FadeInImage.assetNetwork(
                                              width: 50,
                                              height: 50,
                                              placeholder:
                                                  'assets/nation_flag_loading2.gif',
                                              image: returnUrl(nation[flags])),
                                          title: Text(
                                              "${nationName[nation[flags]]} (${widget.photos[index].getExCurNm.split(" ").length == 1 ? widget.photos[index].getExCurNm : widget.photos[index].getExCurNm.split(" ")[1]})"),
                                          subtitle: Text(
                                              "${widget.photos[index].getExCurUnit}"),
                                          trailing: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: <Widget>[
                                                Text(
                                                    " ${widget.photos[index].getExCurUnit} : 1"),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(type == '매매기준율'
                                                    ? " KRW : ${widget.photos[index].getExDealBasR}"
                                                    : (type == '송금 받을때'
                                                        ? " KRW : ${widget.photos[index].getExTTB}"
                                                        : " KRW : ${widget.photos[index].getExTTS}"))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              ));
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          '한국수출입은행이 제공하는 환율정보입니다.\n현재 환율을 실시간으로 제공합니다.\n(비영업일의 데이터, 혹은 영업당일 11시 이전에 해당일의 데이터를 요청할 경우 null 값이 반환)',
                          style: TextStyle(
                              color: Colors.black54.withOpacity(.5),
                              fontSize: 14),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
