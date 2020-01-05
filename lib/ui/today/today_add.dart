import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/db/database_helper.dart';
import 'package:myapp/models/money.dart';
import 'package:myapp/utils/store.dart';
import 'package:provider/provider.dart';

class TodayAdd extends StatefulWidget {
  @override
  _TodayAddState createState() => _TodayAddState();
}

class _TodayAddState extends State<TodayAdd> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _title = TextEditingController();
  TextEditingController _money = TextEditingController();
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _moneyFocus = FocusNode();
  List<bool> isSelected = [true, false];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _title.dispose();
    _money.dispose();
    _titleFocus.dispose();
    _moneyFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var provider = Provider.of<Store>(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Material(
        color: Colors.transparent,
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 20),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: CircleAvatar(
                    backgroundColor: Colors.black54.withOpacity(.3),
                    child: Icon(Icons.close),
                  ),
                ),
              ),
              Container(
                  width: width * 0.85,
                  child: Column(
                    children: <Widget>[
                      Form(
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
                                      _fieldFocusChange(context,
                                          _titleFocus, _moneyFocus);
                                    },
                                    decoration: InputDecoration(
                                        icon: Icon(Icons.title),
                                        hintText: "내용"),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return '제목을 입력하세요!';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
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
                                    height: size.height * 0.04,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        ToggleButtons(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          children: <Widget>[
                                            Text('현금'),
                                            Text('카드')
                                          ],
                                          onPressed: (int index) {
                                            print(index);
                                            setState(() {
                                              for (int buttonIndex = 0;
                                                  buttonIndex <
                                                      isSelected.length;
                                                  buttonIndex++) {
                                                if (buttonIndex == index) {
                                                  isSelected[buttonIndex] =
                                                      true;
                                                } else {
                                                  isSelected[buttonIndex] =
                                                      false;
                                                }
                                              }
                                            });
                                          },
                                          isSelected: isSelected,
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                          child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20)),
                                            child: Text(
                                              '추가',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight:
                                                      FontWeight.bold),
                                              textScaleFactor: 1.2,
                                            ),
                                            color: Colors.lightBlue,
                                            onPressed: () {
                                              print(provider
                                                  .userData['category']);

                                              if (_formKey.currentState
                                                  .validate()) {
                                                _save(
                                                    provider.userData[
                                                        'category'],
                                                    _title.text,
                                                    int.parse(_money.text),
                                                    isSelected.indexOf(
                                                                true) ==
                                                            0
                                                        ? 'cash'
                                                        : 'card');
                                                _title.text = '';
                                                _money.text = '';

                                                FocusScope.of(context)
                                                    .requestFocus(
                                                        new FocusNode());
                                                Navigator.pop(context);
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void _save(
      String category, String newTitle, int newMoney, String payment) async {
//    updateListView();
    final today = Provider.of<Store>(context).selectedDate;

    print('[[[[[[[[[[[[[[  저장일 : $today   ]]]]]]]]]]]]]]]]]');
    Money money = new Money(
        category,
        newTitle,
        newMoney,
        DateFormat('yyyyMMdd').format(today),
        payment,
        DateFormat('hh:mm').format(today));
    print('ooo');

    int result = await databaseHelper.insertMoney(money);

    if (result != 0) {
      print('성공');
//      _showAlertDialog('성공', '정상저장');
//      updateListView();
      Provider.of<Store>(context).updateTodayMoneyList(DateFormat('yyyyMMdd').format(today));
    } else {
      print('실패');
//      _showAlertDialog('실패', '실패!');
    }
  }
}
