import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/utils/nation_flag.dart';
import 'package:myapp/utils/store.dart';
import 'package:myapp/utils/integer_format.dart';
import 'package:provider/provider.dart';

class Today extends StatefulWidget {
  @override
  _TodayState createState() => _TodayState();
}

class _TodayState extends State<Today> {
  bool _tap = true;
  bool _changeRate = true;

  @override
  void initState() {
    super.initState();
    Provider.of<Store>(context, listen: false).updateTodayMoneyList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('user : ${Provider.of<Store>(context).userData}');
    print('exChangeRateInfo : ${Provider.of<Store>(context).exChangeRateInfo}');
    print('todayMoneyList : ${Provider.of<Store>(context).todayMoneyList}');

    print('==============================');
//    print('${NationFlag.threeWordToNationName(Provider.of<Store>(context).userData['current_nation'])}');

    var provider = Provider.of<Store>(context);
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            GestureDetector(
                onTapUp: (TapUpDetails details) {
                  dateTap(true);
                },
                onTapDown: (TapDownDetails details) {
                  dateTap(false);
                },
                onTap: () {
                  selectDate();
                },
                child: Text(
                  DateFormat('yyyy-MM-dd').format(provider.selectedDate),
                  textScaleFactor: 1.2,
                  style: TextStyle(color: _tap ? Colors.blue : Colors.black26),
                )),
            Row(
              children: <Widget>[
//                                  Text(
//                                          '${IntegerFormat.getFormat(total)} '
//                                          '${provider.userData['cur_nm'].split(' ').length == 1 ? provider.userData['cur_nm'] : provider.userData['cur_nm'].split(' ')[1]}',
//                                          textScaleFactor: 1.2,
//                                          style: TextStyle(
//                                              fontWeight: FontWeight.bold,
//                                              color: Colors.black54),
//                                        ),
//                                  _changeRate
//                                      ? Text(
//                                          '${IntegerFormat.getFormat(total)} '
//                                          '${provider.userData['cur_nm'].split(' ').length == 1 ? provider.userData['cur_nm'] : provider.userData['cur_nm'].split(' ')[1]}',
//                                          textScaleFactor: 1.2,
//                                          style: TextStyle(
//                                              fontWeight: FontWeight.bold,
//                                              color: Colors.black54),
//                                        )
////                                  double.parse(provider.userData['cur_rate'].replaceAll(',',''))
//                                      : Text(
//                                          '${IntegerFormat.getFormat(total * 2)}',
//                                          style: TextStyle(
//                                              fontWeight: FontWeight.bold,
//                                              color: Colors.black54)),
                SizedBox(
                  width: 5,
                ),
                Text('${NationFlag.threeWordToNationName(provider.userData['current_nation'])} -> ${NationFlag.threeWordToNationName(provider.userData['target_nation'])}'),
              ],
            )
          ],
        ),
        provider.todayMoneyList == null || provider.todayMoneyList.length == 0
            ? Expanded(
                child: Container(
                    alignment: Alignment.center, child: Text('사용 내역을 추가해보세요!')),
              )
            : Flexible(
                child: ListView.builder(
                    itemCount: provider.todayMoneyList == null ||
                            provider.todayMoneyList.length == 0
                        ? 1
                        : provider.todayMoneyList.length,
                    itemBuilder: (context, idx) {
                      return Dismissible(
                        onDismissed: (direction) {
                          print('dismissible ::::::::: $direction');
                          print('idx : $idx');
                          print('id : ${provider.todayMoneyList[idx].id}');

                          provider.deleteTodayMoneyList(
                              idx, provider.todayMoneyList[idx].id);
                        },
                        key: Key(provider.todayMoneyList[idx].id.toString()),
                        child: ListTile(
                          leading:
                              provider.todayMoneyList[idx].payment == 'card'
                                  ? Icon(Icons.credit_card)
                                  : Icon(Icons.attach_money),
                          title: Text('${provider.todayMoneyList[idx].title}'),
                          subtitle:
                              Text('${provider.todayMoneyList[idx].inputDate}'),
                          trailing:
                              Text('${provider.todayMoneyList[idx].money}'),
                        ),
                      );
                    }),
              ),
        provider.todayMoneyList == null || provider.todayMoneyList.length == 0
            ? SizedBox()
            : Container(
                padding: EdgeInsets.only(left: 20),
                width: double.infinity,
                height: 85,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text('오늘 지출'),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                              '${IntegerFormat.getFormat(provider.todayMoneyList[0].total)} ${provider.exChangeRateInfo[NationFlag.threeWordIndex(provider.userData['current_nation'])].curNm}'),
                        ),
                        Expanded(
                          flex:1,
                          child: Text(
                              '${provider.exChangeRateInfo[NationFlag.threeWordIndex(provider.userData['current_nation'])].dealBasR}'),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text('환율 금액'),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text(
                              '${IntegerFormat.getFormat2( provider.todayMoneyList[0].total * (
                                  double.parse(provider.exChangeRateInfo[NationFlag.threeWordIndex(provider.userData['current_nation'])].dealBasR.replaceAll(',',''))
                                      /
                                      double.parse(provider.exChangeRateInfo[NationFlag.threeWordIndex(provider.userData['target_nation'])].dealBasR.replaceAll(',','') ))
                              )
                              } ${provider.exChangeRateInfo[NationFlag.threeWordIndex(provider.userData['target_nation'])].curNm}'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ],
    );
  }

  Future<Null> selectDate() async {
    DateTime picked = await showDatePicker(
      context: context,
      locale: const Locale('ko', 'KO'),
      initialDate: Provider.of<Store>(context).selectedDate,
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
    if (picked != null && picked != Provider.of<Store>(context).selectedDate) {
      Provider.of<Store>(context).setSelectedDate(picked);
      Provider.of<Store>(context)
          .updateTodayMoneyList(DateFormat('yyyyMMdd').format(picked));
    }
  }

  void dateTap(bool tap) {
    setState(() => _tap = tap);
  }
}
