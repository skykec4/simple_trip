import 'package:flutter/material.dart';
import 'dart:async';
import 'package:myapp/models/money.dart';
import 'package:myapp/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class Result extends StatefulWidget {
  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Money> moneyList;
  int count = 0;

  List<Money> totalList;

  @override
  Widget build(BuildContext context) {
    if (moneyList == null) {
      moneyList = List<Money>();
      totalList = List<Money>();
      updateListView();
    }

    print('나와봐라 ! $totalList');

    var list2 = ['a', 'b'];

    return ListView.builder(
      itemCount: moneyList.length, // this is a hardcoded value
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(
            top: 3,
            left: 10,
            right: 10,
          ),
          child: Card(
            child: ExpansionTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(dateFormat(moneyList[index].date)),
                  Text(
                    moneyList[index].money.toString(),
                  )
                ],
              ),
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Divider(),
                    _dayList(moneyList[index].date, totalList)
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _dayList(String date, List money) {
    var currentDate = date;
    var currentDayList = money;

    var length = currentDayList.length;

    var test = List<Money>();
    for (int i = 0; i < length; i++) {
      if(date == currentDayList[i].date){
        test.add(currentDayList[i]);
      }

    }
    print('testtesttesttesttest : $test');

    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: test.length,
          itemBuilder: (context, index) {

            return Row(
              children: <Widget>[
                Text(test[index].title),
                Text(test[index].money.toString()),
              ],
            );
            if (currentDate == currentDayList[index].date) {
              return Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(currentDayList[index].date),
              );
            } else {
              return Text('a');
            }
          },
        ));

    return Text(date);
    ;
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
    print('gogo');
    final Future<Database> dbFuture = databaseHelper.initDatabase();
    dbFuture.then((database) {
//      Future<List<Money>> moneyListFuture = databaseHelper.getMoneyList();
      Future<List<Money>> moneyListFuture = databaseHelper.getDateAndTotal();

      Future<List<Money>> moneyListFuture2 = databaseHelper.getMoneyList();
//      Future<List<Money>> moneyListFuture2 = databaseHelper.getDateAndTotal();

//      getDateAndTotal

      moneyListFuture.then((moneyList) {
        print('흠 / //  $moneyList');
        setState(() {
          this.moneyList = moneyList;
          this.count = moneyList.length;
        });
      });

      moneyListFuture2.then((moneyList) {
        print('흠 / //  $moneyList');
        setState(() {
          this.totalList = moneyList;
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
}
