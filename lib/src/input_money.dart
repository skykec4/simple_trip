import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/util/store.dart';
import 'package:provider/provider.dart';
import 'package:localstorage/localstorage.dart';

class InputMoney extends StatefulWidget {
  @override
  _InputMoneyState createState() => _InputMoneyState();
}

class _InputMoneyState extends State<InputMoney> {
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
    var getData = storage.getItem("use_money");

    int sum = 0;

    if (getData != null && getData.containsKey(today)) {

      for (var name in getData[today]) {

        sum += int.parse(name["money"]);
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
                              Text(
                                Provider.of<Money>(context, listen: true)
                                    .getNow
                                    .toString(),
                                textScaleFactor: 1.5,
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold),
                              ),
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
                                  Text(sum.toString())
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
//
                                      if(!getData.containsKey(today)){
                                        print('gjgjgj?? $getData');
                                        getData[today]=[];
                                      }

                                      print('sd1f  $getData');
                                      final todayData = getData[today];




                                      final todayNewData = {
                                        'title': _title.text.toString(),
                                        'money': _money.text
                                      };

                                      todayData.add(todayNewData);

                                      setState(() {
                                        getData[today] = todayData;
                                      });

//                                      storage.setItem("use_money", value)

//                                      Provider.of<Money>(context).setTodayList(
//                                          _inputTitle, _inputMoney);

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

    final data = storage.getItem('use_money');

    print('data : ' + data.toString());
    if (data == null) {
      return Center(child: Text('엄써용'));
    }

    if(!data.containsKey(today)){
      return Center(child: Text('엄써용'));
    }

    return FutureBuilder(
      future: storage.ready,
      builder: (BuildContext context, snapshot) {
        if (snapshot.data == true) {
          Map<String, dynamic> data = storage.getItem('use_money');
          print('gogo' + data.containsKey(today).toString());

          List todayList = data[today];
          return ListView.builder(
              itemCount: todayList.length,
              itemBuilder: (context, index) {
                print('todayList ' + todayList[index].toString());
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: GestureDetector(
                    onLongPress: () {
                      print('asdasd : ' + data[today].toString());
                      print('index : ' + index.toString());
                      setState(() {
                        data[today].removeAt(index);
                      });
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
                              Text(todayList[index]["title"]),
                              Text(todayList[index]["money"]),
                            ],
                          ),
                        )),
                  ),
                );
              });
        } else {
          return Text('nono');
        }
      },
    );

    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        print('' + data.length.toString());
        if (data.length == 0) {
          print('hi');
          return Center(
              child: Text(
            '항목을 추가해주세요!!',
            textScaleFactor: 1.5,
            style: TextStyle(color: Colors.grey),
          ));
        }

        final title = data[index]['title'];
        final money = data[index]['money'];

        print('!!!!checkehck $title, $money');

        return Card(
          elevation: 14,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: Padding(
            padding: EdgeInsets.only(
              left: 5,
              right: 5,
            ),
            child: ListTile(
              onLongPress: () {
                Provider.of<Money>(context).removeTodayList(index);
              },
              title: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
                textScaleFactor: 1.2,
              ),
              trailing: Text(
                formatter.format(int.parse(money)),
                style: TextStyle(fontWeight: FontWeight.bold),
                textScaleFactor: 1.2,
              ),
            ),
          ),
        );
      },
    );
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
