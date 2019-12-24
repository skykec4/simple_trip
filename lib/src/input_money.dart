import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:myapp/models/money.dart';
import 'package:myapp/utils/database_helper.dart';
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

//  String _date = DateFormat('yyyyMMdd').format(DateTime.now());
  DateTime _date = DateTime.now();
  bool _tap = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    if (moneyList == null) {
      moneyList = List<Money>();
      updateListView();
    }
    Future selectDate() async {
      DateTime picked = await showDatePicker(
        context: context,
        locale: const Locale('ko', 'KO'),
        initialDate: DateTime.now(),
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
        setState(() => _date = picked);
        updateListView();

        return picked.toString().substring(0, 10);
      }
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
                                    /*
                                    DatePicker.showDatePicker(context,
                                        showTitleActions: true,
                                        minTime: DateTime(2017, 1, 1),
                                        maxTime: DateTime(2030, 12, 31),
                                        onChanged: (date) {
                                      print('change $date');
                                    }, onConfirm: (date) {
                                      print('confirm $date');
                                      setState(() {
                                        _date =
                                            DateFormat('yyyyMMdd').format(date);
                                      });
                                      updateListView();
                                    },
                                        currentTime: DateTime.parse(_date),
//                                        DateFormat('yyyy-MM-dd hh:nn:mm:ss').format(_date),
//                                        DateTime.now(),
                                        locale: LocaleType.ko);

                                     */
                                  },
                                  child: Text(
//                                    DateFormat("yyyy-MM-dd")
//                                        .format(DateTime.parse(_date)),
                                    DateFormat('yyyy-MM-dd').format(_date),
//                                    _date.toString(),
                                    textScaleFactor: 1.2,
                                    style: TextStyle(
                                        color: _tap
                                            ? Colors.blue
                                            : Colors.black26),
                                  )),
                              Container(
                                child: Text(
                                  '오늘 지출 : ${IntegerFormat.getFormat(total)} (${IntegerFormat.getFormat(total * 39)}원)',
                                  textScaleFactor: 1.2,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54),
                                ),
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

  void _save(String newTitle, int newMoney) async {
    updateListView();

    Money money =
        new Money('test',newTitle, newMoney, DateFormat('yyyyMMdd').format(_date));

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
      Future<List<Money>> moneyListFuture =
          databaseHelper.getTodayList(DateFormat('yyyyMMdd').format(_date));

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
