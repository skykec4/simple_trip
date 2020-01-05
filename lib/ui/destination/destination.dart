import 'package:flutter/material.dart';
import 'package:myapp/db/user_data.dart';
import 'package:myapp/models/user_data_model.dart';
import 'package:myapp/models/user_setting.dart';
import 'package:myapp/ui/main.dart';
import 'package:myapp/utils/nation_flag.dart';
import 'package:myapp/utils/store.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqlite_api.dart';

class Destination extends StatefulWidget {
  @override
  _DestinationState createState() => _DestinationState();
}

class _DestinationState extends State<Destination> {
  UserDataDatabase userDb = UserDataDatabase();

  TextEditingController _destination = TextEditingController();
  TextEditingController _totalMoney = TextEditingController();

  String _currentNation = '미국';
  String _targetNation = '한국';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _destination.dispose();
    _totalMoney.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(bottom: 60),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('여행지설정'),
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
                                image: NationFlag.getNationFlagImage(
                                    _currentNation)),
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
//                              Text('${Provider.of<Store>(context).exChangeRateInfo[unit[nationList.indexOf(_currentNation)]]["curNm"]}'),
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
                                image: NationFlag.getNationFlagImage(
                                    _targetNation)),
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
        ),
      ),
    );
  }

  void getUserData() async {
    final Future<Database> dbFuture = userDb.init();

    print('userData!!!!!');
    dbFuture.then((database) {
      Future<List<Map<String, dynamic>>> userData = userDb.getUserData();

      userData.then((data) {
        if (data.length > 0) {
          Provider.of<Store>(context).setUserData(data[0]);
        }
      });
    });
  }

  void insertUserData() async {
    UserDataModel userData = new UserDataModel(
        _destination.text,
        unit[nationList.indexOf(_currentNation)],
        unit[nationList.indexOf(_targetNation)],
        int.parse(_totalMoney.text));
    UserSetting userSetting = new UserSetting(_destination.text);

    print('_destination.text : ${_destination.text}');
    int result = await userDb.insertUserDataModel(userData);
    int result2 = await userDb.insertUserSetting(userSetting);
    print('결과는요1?? $result');
    print('결과는요2?? $result2');


    await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Main()),
        (Route<dynamic> route) => false);
  }
}
