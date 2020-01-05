import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/api/api.dart';
import 'package:myapp/db/user_data.dart';
import 'package:myapp/models/rate.dart';
import 'package:myapp/models/user_data_model.dart';
import 'package:myapp/models/user_setting.dart';
import 'package:myapp/ui/destination/destination.dart';
import 'package:myapp/ui/exchange/exchange_rate_info.dart';
import 'package:myapp/ui/result/total_result.dart';
import 'package:myapp/ui/setting/setting.dart';
import 'package:myapp/ui/today/today.dart';
import 'package:myapp/ui/today/today_add.dart';
import 'package:myapp/utils/store.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  Future<List<Rate>> rateList;
  int _index = 0;
  var _titleList = ['오늘 지출', '전체 지출', '환율', '세팅'];

//  DatabaseHelper databaseHelper = DatabaseHelper();
  UserDataDatabase userDb = UserDataDatabase();

  @override
  void initState() {
    super.initState();
    rateList = Api.fetchPhotos();
    rateList.then((res) {
      Provider.of<Store>(context).setExChangeRateInfo(res);
      getUserData();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
//    print('${nation[nationList.indexOf(_currentNation)]}');
//    print('${Provider.of<Store>(context).exChangeRateInfo[nationList.indexOf(_currentNation)].dealBasR}');
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 60),
          child: Scaffold(
            appBar: AppBar(
              title: Text('${_titleList[_index]}'),
            ),
            body: IndexedStack(
              index: _index,
              children: <Widget>[
                Provider.of<Store>(context).userData == null
                    ? SizedBox()
                    : Today(),
                TotalResult(),
                ExchangeRateInfo(),
                Setting()
              ],
            ),
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
            floatingActionButton: _index == 0
                ? FloatingActionButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return TodayAdd();
                          });
                    },
                    child: Icon(Icons.add),
                  )
                : null,
          ),
        ),
        FutureBuilder<List<Rate>>(
            future: rateList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
//                print('snapshot : ${snapshot.data[22].curNm}');
                return SizedBox();
              } else if (snapshot.hasError) {
                return Container(
                  color: Colors.black54.withOpacity(.5),
                  child: Center(
                    child: AlertDialog(
                      title: Text('오류'),
                      content: Text('환율정보를 가져오지 못했습니다.'),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () {},
                          child: Text('확인'),
                        )
                      ],
                    ),
                  ),
                );
              }
              return Container(
                  color: Colors.black54.withOpacity(.5),
                  child: Center(child: CircularProgressIndicator()));
            })
      ],
    );
  }

  void getUserData() async {
    final Future<Database> dbFuture = userDb.init();

    dbFuture.then((database) {
      Future<List<Map<String, dynamic>>> userData = userDb.getUserData();

      userData.then((data) {
//        print('Main]]]]]  $data');
        if (data.length > 0) {
          Provider.of<Store>(context).setUserData(data[0]);
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Destination()),
              (Route<dynamic> route) => false);
        }
      });
    });
  }
}
