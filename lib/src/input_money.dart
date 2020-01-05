import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:myapp/models/money.dart';
import 'package:myapp/db/database_helper.dart';
import 'package:myapp/utils/store.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:myapp/utils/integer_format.dart';

class InputMoney extends StatefulWidget {
  @override
  _InputMoneyState createState() => _InputMoneyState();
}

class _InputMoneyState extends State<InputMoney> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Money> moneyList;
  int moneyListLength = 0;
  int total = 0;

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  TextEditingController _title = TextEditingController();
  TextEditingController _money = TextEditingController();

  final FocusNode _titleFocus = FocusNode();
  final FocusNode _moneyFocus = FocusNode();
  List<bool> isSelected = [true, false];

//  String _date = DateFormat('yyyyMMdd').format(DateTime.now());
  DateTime _date = DateTime.now();
  bool _tap = true;

  bool _changeRate = true;

  Future<Null> selectDate() async {
    DateTime picked = await showDatePicker(
      context: context,
      locale: const Locale('ko', 'KO'),
      initialDate: _date,
      firstDate: DateTime(2017),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );
    print('picked: $picked');
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
      updateListView();
    }
  }

  @override
  void initState() {
    super.initState();
    updateListView();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var provider = Provider.of<Store>(context);

//    if (moneyList == null) {
//      moneyList = List<Money>();
//      updateListView();
//    }
    FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-5836517707450415/9866875219")
        .then((response) {
      myBanner
        ..load()
        ..show();
    });

    print(']]]] ${provider.userData}');

    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: Container(
                  width: size.width,
                  color: Colors.lightBlue[50],
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: size.height * 0.05,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: size.width * 0.02,
                              left: size.width * 0.05,
                              right: size.width * 0.05,
                              bottom: 1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              GestureDetector(
                                  onTapUp: (TapUpDetails details) {
                                    setState(() {
                                      _tap = true;
                                    });
                                  },
                                  onTapDown: (TapDownDetails details) {
                                    setState(() {
                                      _tap = false;
                                    });
                                  },
                                  onTap: () {
                                    selectDate();
                                  },
                                  child: Text(
                                    DateFormat('yyyy-MM-dd').format(_date),
                                    textScaleFactor: 1.2,
                                    style: TextStyle(
                                        color: _tap
                                            ? Colors.blue
                                            : Colors.black26),
                                  )),
                              Row(
                                children: <Widget>[

//                                  Text(
//                                          '${IntegerFormat.getFormat(total)} '
//                                          '${provider.userData['cur_nm'].split(' ').length == 1 ? provider.userData['cur_nm'] : provider.userData['cur_nm'].split(' ')[1]}',
//                                          textScaleFactor: 1.2,
//                                          style: TextStyle(
//                                              fontWeight: FontWeight.bold,
//                                              color: Colors.black54),
//                                        ),
//                                  _changeRate
//                                      ? Text(
//                                          '${IntegerFormat.getFormat(total)} '
//                                          '${provider.userData['cur_nm'].split(' ').length == 1 ? provider.userData['cur_nm'] : provider.userData['cur_nm'].split(' ')[1]}',
//                                          textScaleFactor: 1.2,
//                                          style: TextStyle(
//                                              fontWeight: FontWeight.bold,
//                                              color: Colors.black54),
//                                        )
////                                  double.parse(provider.userData['cur_rate'].replaceAll(',',''))
//                                      : Text(
//                                          '${IntegerFormat.getFormat(total * 2)}',
//                                          style: TextStyle(
//                                              fontWeight: FontWeight.bold,
//                                              color: Colors.black54)),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _changeRate = !_changeRate;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.autorenew,
                                      color: Colors.blue,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: _myListView(context)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.grey[200],
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: size.width * 0.02,
                        left: size.width * 0.02,
                        right: size.width * 0.02,
                        bottom: size.width * 0.1,
                      ),
                      child: Card(
                        elevation: 20,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: size.width * 0.02,
                            left: size.width * 0.05,
                            right: size.width * 0.05,
                            bottom: size.width * 0.05,
                          ),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: _title,
                                focusNode: _titleFocus,
                                textInputAction: TextInputAction.next,
                                onFieldSubmitted: (term) {
                                  _fieldFocusChange(
                                      context, _titleFocus, _moneyFocus);
                                },
                                decoration: InputDecoration(
                                    icon: Icon(Icons.title), hintText: "내용"),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return '제목을 입력하세요!';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: _money,
                                focusNode: _moneyFocus,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    icon: Icon(Icons.monetization_on),
                                    hintText: "가격"),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return '가격을 입력하세요!';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              SizedBox(
                                height: size.height * 0.04,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    ToggleButtons(
                                      borderRadius: BorderRadius.circular(20),
                                      children: <Widget>[
                                        Text('현금'),
                                        Text('카드')
                                      ],
                                      onPressed: (int index) {
                                        print(index);
                                        setState(() {
                                          for (int buttonIndex = 0;
                                              buttonIndex < isSelected.length;
                                              buttonIndex++) {
                                            if (buttonIndex == index) {
                                              isSelected[buttonIndex] = true;
                                            } else {
                                              isSelected[buttonIndex] = false;
                                            }
                                          }
                                        });
                                      },
                                      isSelected: isSelected,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Text(
                                          '추가',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                          textScaleFactor: 1.2,
                                        ),
                                        color: Colors.lightBlue,
                                        onPressed: () {
                                          print(provider.userData['category']);
                                          if (_formKey.currentState
                                              .validate()) {
                                            _save(
                                                provider.userData['category'],
                                                _title.text,
                                                int.parse(_money.text),
                                                isSelected.indexOf(true) == 0
                                                    ? 'cash'
                                                    : 'card');
                                            _title.text = '';
                                            _money.text = '';

                                            FocusScope.of(context)
                                                .requestFocus(new FocusNode());
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _myListView(BuildContext context) {
//    final data = Provider.of<Money>(context, listen: true).getTodayList;
    if (moneyList == null) {
      moneyList = List<Money>();
    }

    if (moneyListLength == 0) {
      return Center(
        child: Text('지출 내역을 써보세요~'),
      );
    }

    return ListView.builder(
        itemCount: moneyListLength,
        itemBuilder: (context, index) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: GestureDetector(
              onLongPress: () {
                _delete(context, moneyList[index]);
              },
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 10,
                        left: MediaQuery.of(context).size.width * 0.05,
                        right: MediaQuery.of(context).size.width * 0.05,
                        bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(moneyList[index].title),
                        Text(
                            '${IntegerFormat.getFormat(moneyList[index].money)} (${(IntegerFormat.getFormat(moneyList[index].money * 39))})'),
                      ],
                    ),
                  )),
            ),
          );
        });
  }

  void _save(
      String category, String newTitle, int newMoney, String payment) async {
    updateListView();

    Money money = new Money(category, newTitle, newMoney,
        DateFormat('yyyyMMdd').format(_date), payment, DateFormat('hh:mm').format(DateTime.now().toLocal()));
    print('ooo');

    int result = await databaseHelper.insertMoney(money);

    if (result != 0) {
      print('성공');
//      _showAlertDialog('성공', '정상저장');
      updateListView();
    } else {
      print('실패');
//      _showAlertDialog('실패', '실패!');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );

    showDialog(context: context, builder: (_) => alertDialog);
  }

  void _delete(BuildContext context, Money money) async {
    int result = await databaseHelper.deleteMoney(money.id);
    if (result != 0) {
      _showSnackBar(context, '삭제되었습니다.');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initDatabase();
    dbFuture.then((database) {
      Future<List<Money>> moneyListFuture = databaseHelper.getTodayList(
          DateFormat('yyyyMMdd').format(_date),
          Provider.of<Store>(context).userData['category']);

      moneyListFuture.then((moneyList) {
        setState(() {
          this.moneyList = moneyList;
          this.moneyListLength = moneyList.length;
          if (moneyList.length != 0) {
            this.total = moneyList[0].total;
          } else {
            this.total = 0;
          }
        });
      });
    });
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}

MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  keywords: <String>[
    'trip',
    'travle',
    'exchange rate',
    'rate of exchange',
  ],
//  contentUrl: 'https://flutter.io',
  childDirected: false,
  testDevices: <String>[], // Android emulators are considered test devices
);

BannerAd myBanner = BannerAd(
  // Replace the testAdUnitId with an ad unit id from the AdMob dash.
  // https://developers.google.com/admob/android/test-ads
  // https://developers.google.com/admob/ios/test-ads
  adUnitId: BannerAd.testAdUnitId,
//  adUnitId: "ca-app-pub-5836517707450415~7623855251",
  size: AdSize.banner,
  targetingInfo: targetingInfo,
  listener: (MobileAdEvent event) {
    print("BannerAd event is $event");
  },
);

InterstitialAd myInterstitial = InterstitialAd(
  // Replace the testAdUnitId with an ad unit id from the AdMob dash.
  // https://developers.google.com/admob/android/test-ads
  // https://developers.google.com/admob/ios/test-ads
  adUnitId: "ca-app-pub-5836517707450415~7623855251",
  targetingInfo: targetingInfo,
  listener: (MobileAdEvent event) {
    print("InterstitialAd event is $event");
  },
);
