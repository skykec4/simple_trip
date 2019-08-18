import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'input_money.dart';
import 'result.dart';
import 'setting.dart';
import 'exchange_rate.dart';

class MainPage extends StatefulWidget {

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _index = 0;

  var _list = [InputMoney(), Result(), ExchangeRate(), Setting()];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('너의 쓴돈은?'),
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
//      bottomNavigationBar: BottomNavigationBar(
//          type: BottomNavigationBarType.fixed,
//          currentIndex: _index,
//          onTap: (index) {
//            setState(() {
//              _index = index;
//            });
//          },
//          items: [
//            BottomNavigationBarItem(
//                icon: Icon(Icons.input), title: Text('오늘쓴돈')),
//            BottomNavigationBarItem(
//                icon: Icon(Icons.receipt), title: Text('쓴돈들')),
//            BottomNavigationBarItem(
//                icon: Icon(Icons.monetization_on), title: Text('환율')),
//            BottomNavigationBarItem(
//                icon: Icon(Icons.settings), title: Text('세팅')),
//          ]),
    bottomNavigationBar: FancyBottomNavigation(
      tabs: [
        TabData(iconData: Icons.input, title: "오늘쓴돈"),
        TabData(iconData: Icons.receipt, title: "쓴돈들"),
        TabData(iconData: Icons.monetization_on, title: "환율"),
        TabData(iconData: Icons.settings, title: "세팅")
      ],
      onTabChangedListener: (position) {
        setState(() {
          _index = position;
        });
      },
    ),
    );
  }
}
