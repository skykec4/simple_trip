import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/api/api.dart';
import 'package:myapp/db/user_data.dart';
import 'package:myapp/models/exchange_rate.dart';
import 'package:myapp/models/money.dart';
import 'package:myapp/db/database_helper.dart';
import 'package:myapp/models/rate.dart';
import 'package:myapp/models/user_data_model.dart';
import 'package:myapp/models/user_setting.dart';
import 'package:myapp/utils/store.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'input_money.dart';
import 'result.dart';
import 'setting.dart';
import 'exchange_rate.dart';
import 'package:myapp/utils/integer_format.dart';

IntegerFormat formatter = new IntegerFormat();

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _index = 0;

  var _list = [InputMoney(), Result(), ExchangeRateUI(), Setting()];
  var _titleList = ['오늘 지출', '전체 지출', '환율', '세팅'];

  String _selected = '태국';

  DatabaseHelper databaseHelper = DatabaseHelper();
  UserDataDatabase userDb = UserDataDatabase();

  List<Money> moneyList;
  int count = 0;

  int total = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateListView();
    getUserData();
  }

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

  String returnUrl(String nation) {
    return 'https://www.countryflags.io/$nation/shiny/64.png';
  }

  String _currentNation = '미국';
  String _targetNation = '한국';

  TextEditingController _destination = TextEditingController();
  TextEditingController _totalMoney = TextEditingController();
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



          });

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

  bool isInit = false;
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var provider = Provider.of<Store>(context);
    if (moneyList == null) {
      moneyList = List<Money>();
//      updateListView();
    }
    print('provider.getUserSelectedNation : ${provider.getUserSelectedNation}');



    if(isInit){
      print('111111111111111111111111111111111111111111111111111111111111111111');
      return Scaffold(
        appBar: AppBar(
          title: Text('여행정보 설정'),
        ),
        body: Container(
          padding: EdgeInsets.all(30),
          child: Form(
            child: ListView(
              children: <Widget>[
                TextFormField(
                  controller: _destination,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '목적지',
                    hintText: '어디로 여행가시나요?',
                    prefixIcon: Icon(Icons.airplanemode_active),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _totalMoney,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '여행 경비',
                    hintText: '여행경비는 얼마인가요?',
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('현지통화'),
                    Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
//                crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          FadeInImage.assetNetwork(
                              width: 35,
                              height: 50,
                              placeholder: 'assets/nation_flag_loading2.gif',
                              image: returnUrl(
                                  nation[nationList.indexOf(_currentNation)])),
                          SizedBox(
                            width: 30,
                          ),
                          DropdownButton<String>(
                            value: _currentNation,
                            onChanged: (value) {
                              setState(() {
                                _currentNation = value;
                              });
                            },
                            items: nationList
                                .map<DropdownMenuItem<String>>((value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Container(
                                    width: width * 0.3, child: Text(value)),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('환율통화'),
                    Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
//                crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          FadeInImage.assetNetwork(
                              width: 35,
                              height: 50,
                              placeholder: 'assets/nation_flag_loading2.gif',
                              image: returnUrl(
                                  nation[nationList.indexOf(_targetNation)])),
                          SizedBox(
                            width: 30,
                          ),
                          DropdownButton<String>(
                            value: _targetNation,
                            onChanged: (value) {
                              setState(() {
                                _targetNation = value;
                              });
                            },
                            items: nationList
                                .map<DropdownMenuItem<String>>((value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Container(
                                    width: width * 0.3, child: Text(value)),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  onPressed: () async {
                    insertUserData();

                  },
                  color: Colors.blue,
                  child: Text(
                    '추가',
                    style: TextStyle(color: Colors.white),
                    textScaleFactor: 1.2,
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }else{
      print('2222222222222222222222222222222222222222222222222222222222222222');
      return Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: Scaffold(
          drawer: Drawer(
            child: Container(
              color: Colors.grey[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                    ),
                    ListTile(
                      title: Text('MENU'),
                      trailing: Icon(Icons.add),
                    ),
                    Divider(),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text('태국'),
                              trailing: Text('${IntegerFormat.getFormat(total)}'),
                              selected: _selected == '태국' ? true : false,
                              onTap: () {
//                              updateListView();
                                setState(() {
                                  _selected = '태국';
                                });
                              },
                            ),
                            ListTile(
                              title: Text('유럽'),
                              selected: _selected == '유럽' ? true : false,
                              onTap: () {
                                setState(() {
                                  _selected = '유럽';
                                });
                              },
                            ),
                            ListTile(
                              title: Text('미국'),
                              selected: _selected == '미국' ? true : false,
                              onTap: () {
                                setState(() {
                                  _selected = '미국';
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          appBar: AppBar(
            title: Text(_titleList[_index]),
            centerTitle: true,
//        actions: <Widget>[
//          Container(
//            child: Padding(
//              padding: EdgeInsets.all(size.width * 0.025),
//              child: FloatingActionButton(
//                  foregroundColor: Colors.white,
//                  backgroundColor: Colors.lightBlue,
//                  elevation: 20,
//                  child: Icon(Icons.autorenew),
//                  onPressed: () {}),
//            ),
//          ),
//        ],
//        leading: Icon(Icons.monetization_on),
          ),
          body: _list[_index],

          bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _index,
              onTap: (index) {
                setState(() {
                  _index = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.input), title: Text('오늘')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.receipt), title: Text('전체')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.monetization_on), title: Text('환율')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings), title: Text('세팅')),
              ]),


        ),
      );
    }

    if(provider.getUserSelectedNation != null){

    }else if (provider.getUserSelectedNation == null && !isInit) {

    }else{
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
  }

//  void updateListView() {
//    final Future<Database> dbFuture = databaseHelper.initDatabase();
//
//    dbFuture.then((database) {
//      Future<List<Money>> moneyListFuture = databaseHelper.getDateAndTotal();
//
//      moneyListFuture.then((moneyList) {
//        setState(() {
//          this.moneyList = moneyList;
//          this.count = moneyList.length;
//          if (moneyList.length != 0) {
//            this.total = moneyList[0].total;
//          }
//        });
//      });
//    });
//  }

  void getUserData() async{
//    final Future<Database> dbFuture = databaseHelper.initDatabase();
    final Future<Database> dbFuture = userDb.init();

    print('userData!!!!!');
    dbFuture.then((database) {
      Future<List<Map<String,dynamic>>> setting = userDb.getUserData();

      setting.then((res) {
        print('뭐시여 ? $res');

        if(res.length == 0){
          setState(() {
            isInit = true;
          });
        }else{
          Provider.of<Store>(context, listen: false).setUserData(res[0]);
        }
      });
    });
  }

  void insertUserData() async {

    UserDataModel userData = new UserDataModel(
        _destination.text, unit[nationList.indexOf(_currentNation)], unit[nationList.indexOf(_targetNation)], int.parse(_totalMoney.text));
    UserSetting userSetting = new UserSetting(_destination.text);

    print('_destination.text : ${_destination.text}');
    int result = await userDb.insertUserDataModel(userData);
    int result2 = await userDb.insertUserSetting(userSetting);
    print('결과는요1?? $result');
    print('결과는요2?? $result2');

    getUserData();

    setState(() {
      isInit = false;
    });
  }
}
