import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/money.dart';
import 'package:myapp/utils/database_helper.dart';
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

  var _list = [InputMoney(), Result(), ExchangeRate(), Setting()];
  var _titleList = ['오늘 지출', '전체 지출', '환율', '세팅'];

  String _selected = '태국';

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Money> moneyList;
  int count = 0;

  int total = 0;

  @override
  Widget build(BuildContext context) {
    if (moneyList == null) {
      moneyList = List<Money>();
      updateListView();
    }

    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
                          trailing: Text('${formatter.getFormat(total)}'),
                          selected: _selected == '태국' ? true : false,
                          onTap: () {
                            updateListView();
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
        actions: <Widget>[
          Container(
            child: Padding(
              padding: EdgeInsets.all(size.width * 0.025),
              child: FloatingActionButton(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.lightBlue,
                  elevation: 20,
                  child: Icon(Icons.autorenew),
                  onPressed: () {}),
            ),
          ),
        ],
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
            BottomNavigationBarItem(icon: Icon(Icons.input), title: Text('오늘')),
            BottomNavigationBarItem(
                icon: Icon(Icons.receipt), title: Text('전체')),
            BottomNavigationBarItem(
                icon: Icon(Icons.monetization_on), title: Text('환율')),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), title: Text('세팅')),
          ]),
//      bottomNavigationBar: FancyBottomNavigation(
//        tabs: [
//          TabData(iconData: Icons.input, title: "오늘쓴돈"),
//          TabData(iconData: Icons.receipt, title: "쓴돈들"),
//          TabData(iconData: Icons.monetization_on, title: "환율"),
//          TabData(iconData: Icons.settings, title: "세팅")
//        ],
//        onTabChangedListener: (position) {
//          setState(() {
//            _index = position;
//          });
//        },
//      ),
    );
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
}
