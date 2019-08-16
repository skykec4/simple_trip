import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//import 'package:myapp/util/store.dart';
import 'package:provider/provider.dart';
import 'package:localstorage/localstorage.dart';

import 'dart:async';
import 'package:myapp/models/money.dart';
import 'package:myapp/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class InputMoney extends StatefulWidget {
  @override
  _InputMoneyState createState() => _InputMoneyState();
}

class _InputMoneyState extends State<InputMoney> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Money> moneyList;
  int count = 0;

  final _formKey = GlobalKey<FormState>();
  TextEditingController _title = TextEditingController();
  TextEditingController _money = TextEditingController();
  var formatter = new NumberFormat("#,###");

  final FocusNode _titleFocus = FocusNode();
  final FocusNode _moneyFocus = FocusNode();

  //localStorage
  final LocalStorage storage = new LocalStorage('trip');

//  var now = DateTime.now();

  var today = DateTime.now().year.toString() +
      (DateTime.now().month.toString().length == 1
          ? "0" + DateTime.now().month.toString()
          : DateTime.now().month.toString()) +
      (DateTime.now().day.toString().length == 1
          ? "0" + DateTime.now().day.toString()
          : DateTime.now().day.toString());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
//    var getData = storage.getItem("use_money");
//    print(getData);
    if (moneyList == null) {
      moneyList = List<Money>();
      updateListView();
    }
    int total = 0;

    for (int i = 0; i < moneyList.length; i++) {
      total = total + moneyList[i].money;
    }

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
                              Text(DateFormat('yyyy-MM-dd')
                                  .format(DateTime.now())),
//                              Text(
//                                Provider.of<Money>(context, listen: true)
//                                    .getNow
//                                    .toString(),
//                                textScaleFactor: 1.5,
//                                style: TextStyle(
//                                    color: Colors.black54,
//                                    fontWeight: FontWeight.bold),
//                              ),
                              Container(
                                  child: Row(
                                children: <Widget>[
                                  Text(
                                    '총합 : ',
                                    textScaleFactor: 1.2,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54),
                                  ),
                                  Text(total.toString())
//                                  Text(
//                                    formatter.format(Provider.of<Money>(context)
//                                        .getTodayTotalMoney),
//                                    textScaleFactor: 1.4,
//                                  )
                                ],
                              ))
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
                                    icon: Icon(Icons.title),
                                    hintText: "사용한 내용"),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return '제목을 입력하세요!';
                                  }
                                  return null;
                                },
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
                                width: size.width * 0.7,
                                height: size.height * 0.05,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Text(
                                    '입력',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                    textScaleFactor: 1.2,
                                  ),
                                  color: Colors.lightBlue,
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      final list = {
                                        'title': _title.text,
                                        'money': _money.text
                                      };
//                                      Provider.of<Money>(context)
//                                          .setToday(list);
                                      _save(
                                          _title.text, int.parse(_money.text));

                                      _title.text = '';
                                      _money.text = '';

                                      FocusScope.of(context)
                                          .requestFocus(new FocusNode());
                                    }
                                  },
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
    print("moneyList :::: $moneyList");
//    var today = Provider.of<Money>(context).getToday;

    return ListView.builder(
        itemCount: moneyList.length,
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
                        Text(moneyList[index].money.toString()),
                      ],
                    ),
                  )),
            ),
          );
        });

//    return ListView.builder(
//        itemCount: today.length,
//        itemBuilder: (context, index) {
//          return SizedBox(
//            height: MediaQuery.of(context).size.height * 0.1,
//            child: GestureDetector(
//              onLongPress: () {},
//              child: Card(
//                  shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.circular(25)),
//                  child: Padding(
//                    padding: EdgeInsets.only(
//                        top: 10,
//                        left: MediaQuery.of(context).size.width * 0.05,
//                        right: MediaQuery.of(context).size.width * 0.05,
//                        bottom: 10),
//                    child: Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      children: <Widget>[
//                        Text(today[index]["title"]),
//                        Text(today[index]["money"]),
//                      ],
//                    ),
//                  )),
//            ),
//          );
//        });

//    return ListView.builder(
//      itemCount: data.length,
//      itemBuilder: (context, index) {
//        print('' + data.length.toString());
//        if (data.length == 0) {
//          print('hi');
//          return Center(
//              child: Text(
//            '항목을 추가해주세요!!',
//            textScaleFactor: 1.5,
//            style: TextStyle(color: Colors.grey),
//          ));
//        }
//
//        final title = data[index]['title'];
//        final money = data[index]['money'];
//
//        print('!!!!checkehck $title, $money');
//
//        return Card(
//          elevation: 14,
//          shape:
//              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//          child: Padding(
//            padding: EdgeInsets.only(
//              left: 5,
//              right: 5,
//            ),
//            child: ListTile(
//              onLongPress: () {
//                Provider.of<Money>(context).removeTodayList(index);
//              },
//              title: Text(
//                title,
//                style: TextStyle(fontWeight: FontWeight.bold),
//                textScaleFactor: 1.2,
//              ),
//              trailing: Text(
//                formatter.format(int.parse(money)),
//                style: TextStyle(fontWeight: FontWeight.bold),
//                textScaleFactor: 1.2,
//              ),
//            ),
//          ),
//        );
//      },
//    );
  }

  void _save(String newTitle, int newMoney) async {
    updateListView();
    int nextId = await databaseHelper.nextId();
    print('nextId111111 : $nextId');
    if (nextId == null) {
      nextId = 1;
    } else {
      nextId += 1;
    }

    String date = DateFormat('yyyyMMdd').format(DateTime.now());
    Money money = new Money(nextId, newTitle, newMoney, date);

    print('money : $money');

    int result = await databaseHelper.insertMoney(money);
    print('result : $result');

    if (result != 0) {
//      _showAlertDialog('성공', '정상저장');
      updateListView();
    } else {
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
      Future<List<Money>> moneyListFuture = databaseHelper.getMoneyList();

      moneyListFuture.then((moneyList) {
        setState(() {
          this.moneyList = moneyList;
          this.count = moneyList.length;
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
