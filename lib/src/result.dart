import 'package:flutter/material.dart';
import 'package:myapp/db/user_data.dart';
import 'dart:async';
import 'package:myapp/models/money.dart';
import 'package:myapp/db/database_helper.dart';
import 'package:myapp/utils/store.dart';
import 'package:myapp/utils/integer_format.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

IntegerFormat formatter = new IntegerFormat();

class Result extends StatefulWidget {
  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  UserDataDatabase userDb = UserDataDatabase();
  List<Money> moneyList;
  int count = 0;

  int total = 0;
  int totalMoney = 0;

  @override
  void initState() {
    getTotalMoney();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (moneyList == null) {
      moneyList = List<Money>();
      updateListView();
    }


    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10, left: 30, bottom: 5),
            child: Container(
              alignment: Alignment.topLeft,
              child: Text(
                '총액 : $totalMoney',
                textScaleFactor: 1.3,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black54),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, left: 30, bottom: 5),
            child: Container(
              alignment: Alignment.topLeft,
              child: Text(
                '남은 금액 ${IntegerFormat.getFormat(totalMoney - total)}',
                textScaleFactor: 1.3,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black54),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, left: 30, bottom: 5),
            child: Container(
              alignment: Alignment.topLeft,
              child: Text(
                '총 지출 : ${IntegerFormat.getFormat(total)} bat (${IntegerFormat.getFormat(total * 39)} 원)',
                textScaleFactor: 1.3,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black54),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              primary: true,
              physics: ScrollPhysics(),
              child: ListView.builder(
                itemCount: count,
                // this is a hardcoded value
                shrinkWrap: true,
                primary: true,
                physics: ScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      top: 3,
                      left: 10,
                      right: 10,
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 10,
                      child: ExpansionTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
//                  Text(moneyList[index].total),
                            Text(
                              dateFormat(moneyList[index].date),
                              style: TextStyle(color: Colors.black54),
                            ),
                            Text(
                              '${IntegerFormat.getFormat(moneyList[index].money)} (${IntegerFormat.getFormat(moneyList[index].money * 39)})',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                            )
                          ],
                        ),
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Divider(
                                color: Colors.black54,
                              ),
                              DayList(moneyList[index].date)
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
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
      Future<List<Money>> moneyListFuture = databaseHelper.getDateAndTotal();

      moneyListFuture.then((moneyList) {
        setState(() {
          this.moneyList = moneyList;
          this.count = moneyList.length;
          if (moneyList.length != 0) {
            this.total = moneyList[0].total;
          }
        });
      });
    });
  }

  List getTodayListView(String date) {
    final Future<Database> dbFuture = databaseHelper.initDatabase();

    var currentDayList;
    dbFuture.then((database) {
      Future<List<Money>> moneyListFuture = databaseHelper.getDayList(date);

      moneyListFuture.then((moneyList) {
        currentDayList = moneyList;
      });
    });
    return currentDayList;
  }

  String dateFormat(String date) {
    return date.substring(0, 4) +
        '-' +
        date.substring(4, 6) +
        '-' +
        date.substring(6, 8);
  }
  void getTotalMoney() async{
    final Future<Database> dbFuture = userDb.init();

    dbFuture.then((database) {
      Future<List<Map<String, dynamic>>> money = userDb.getTotalMoney(Provider.of<Store>(context, listen: false).userData['category']);

      money.then((res) {
        print('뭐시여 ? $res');
        setState(() {
          totalMoney = res[0]['total_money'];
        });

      });
    });
  }
}

class DayList extends StatefulWidget {
  final date;

  DayList(this.date);

  @override
  _DayListState createState() => _DayListState();
}

class _DayListState extends State<DayList> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  List<Money> listDetail;
  int length = 0;

  @override
  Widget build(BuildContext context) {
    if (listDetail == null) {
      listDetail = List<Money>();
      listDetail = getTodayListView(widget.date);
    }

    return Container(
      child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
          child: ListView.builder(
            primary: true,
            physics: AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(listDetail[index].title),
                    Text(
                        '${IntegerFormat.getFormat(listDetail[index].money)} (${IntegerFormat.getFormat(listDetail[index].money * 39)})')
                  ],
                ),
              );
            },
          )),
    );
  }

  List getTodayListView(String date) {
    final Future<Database> dbFuture = databaseHelper.initDatabase();

    print('');

    var currentDayList;
    dbFuture.then((database) {
      Future<List<Money>> moneyListFuture = databaseHelper.getDayList(date);

      moneyListFuture.then((moneyList) {
        setState(() {
          listDetail = moneyList;
          length = moneyList.length;
        });
      });
    });
    return currentDayList;
  }


}
