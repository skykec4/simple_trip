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

  @override
  Widget build(BuildContext context) {

    if (moneyList == null) {
      moneyList = List<Money>();
      updateListView();
    }

    print('나와봐라 ! $moneyList');

    var list2 = ['a','b'];

    return ListView.builder(
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Text(
                moneyList[index].date,
              ),
              ListView.builder(
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text('Nested list item ${list2}index'),
                  );
                },
                itemCount: 2, // this is a hardcoded value
              ),
            ],
          ),
        );
      },
      itemCount: moneyList.length, // this is a hardcoded value
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
  void updateListView(){
    final Future<Database> dbFuture = databaseHelper.initDatabase();
    dbFuture.then((database){
      Future<List<Money>> moneyListFuture = databaseHelper.getMoneyList();

      moneyListFuture.then((moneyList){
        setState(() {
          this.moneyList = moneyList;
          this.count = moneyList.length;
        });

      });
    });



  }
}
