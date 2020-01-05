//import 'package:flutter/material.dart';
//import 'package:intl/date_symbol_data_local.dart';
//import 'package:table_calendar/table_calendar.dart';
//import 'package:intl/intl.dart';
//import 'dart:async';
//import 'package:myapp/models/money.dart';
//import 'package:myapp/utils/database_helper.dart';
//import 'package:sqflite/sqflite.dart';
//
//final Map<DateTime, List> _holidays = {
//  DateTime(2019, 1, 1): ['New Year\'s Day'],
//  DateTime(2019, 1, 6): ['Epiphany'],
//  DateTime(2019, 2, 14): ['Valentine\'s Day'],
//  DateTime(2019, 2, 15): ['Valentine\'s Day'],
//  DateTime(2019, 4, 21): ['Easter Sunday'],
//  DateTime(2019, 4, 22): ['Easter Monday'],
//};
//
//class Setting extends StatefulWidget {
//  @override
//  _SettingState createState() => _SettingState();
//}
//
//class _SettingState extends State<Setting> with TickerProviderStateMixin {
//  Map<DateTime, List> _events;
//  List _selectedEvents;
//  AnimationController _animationController;
//  CalendarController _calendarController;
//
//  DatabaseHelper databaseHelper = DatabaseHelper();
//  List<Money> moneyList;
//
//
//  @override
//  void initState() {
//    super.initState();
//    final _selectedDay = DateTime.now();
//
////    String now = DateFormat('yyyyMMdd').format(DateTime.now());
////    String day = '20190709';
////    print('$now - $day = ');
////    print('::'+ (int.parse(now)- int.parse(day)).toString());
////
////    final birthday = DateTime(2019, 07, 09);
////    final date2 = DateTime.now();
////    final difference = date2.difference(birthday).inDays;
//
//    _events = {
////      _selectedDay.subtract(Duration(days: 30)): ['Event A0', 'Event B0', 'Event C0'],
////      _selectedDay.subtract(Duration(days: 27)): ['Event A1'],
////      _selectedDay.subtract(Duration(days: 20)): ['Event A2', 'Event B2', 'Event C2', 'Event D2'],
////      _selectedDay.subtract(Duration(days: 16)): ['Event A3', 'Event B3'],
////      _selectedDay.subtract(Duration(days: 10)): ['Event A4', 'Event B4', 'Event C4'],
////      _selectedDay.subtract(Duration(days: 4)): ['Event A5', 'Event B5', 'Event C5'],
////      _selectedDay.subtract(Duration(days: 2)): ['Event A6', 'Event B6'],
////      _selectedDay: ['Event A7', 'Event B7', 'Event C7', 'Event D7'],
////      _selectedDay.add(Duration(days: 1)): ['Event A8', 'Event B8', 'Event C8', 'Event D8'],
////      _selectedDay.add(Duration(days: 3)): Set.from(['Event A9', 'Event A9', 'Event B9']).toList(),
////      _selectedDay.add(Duration(days: 7)): ['Event A10', 'Event B10', 'Event C10'],
////      _selectedDay.add(Duration(days: 11)): ['Event A11', 'Event B11'],
////      _selectedDay.add(Duration(days: 17)): ['Event A12', 'Event B12', 'Event C12', 'Event D12'],
////      _selectedDay.add(Duration(days: 22)): ['Event A13', 'Event B13'],
////      _selectedDay.add(Duration(days: 26)): ['Event A14', 'Event B14', 'Event C14'],
////      _selectedDay.add(Duration(days: 26)): ['Event A14', 'Event B14', 'Event C14'],
//    };
//
//    _selectedEvents = _events[_selectedDay] ?? [];
//
//    _calendarController = CalendarController();
//
//    _animationController = AnimationController(
//      vsync: this,
//      duration: const Duration(milliseconds: 400),
//    );
//
//    _animationController.forward();
//  }
//
//  @override
//  void dispose() {
//    _animationController.dispose();
//    _calendarController.dispose();
//    super.dispose();
//  }
//
//  void _onDaySelected(DateTime day, List events) {
//    print('CALLBACK: _onDaySelected');
//    setState(() {
//      _selectedEvents = events;
//    });
//  }
//
//  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
//    print('CALLBACK: _onVisibleDaysChanged');
//  }
//
//  @override
//  Widget build(BuildContext context) {
//
//    if (moneyList == null) {
//      moneyList = List<Money>();
//      updateListView();
//    }
//
//
//    print('dudung~ $moneyList');
//    return Column(
//      mainAxisSize: MainAxisSize.max,
//      children: <Widget>[
//        // Switch out 2 lines below to play with TableCalendar's settings
//        //-----------------------
//        _buildTableCalendar(),
//        // _buildTableCalendarWithBuilders(),
//        const SizedBox(height: 8.0),
//        _buildButtons(),
//        const SizedBox(height: 8.0),
//        Expanded(child: _buildEventList()),
//      ],
//    );
//  }
//  Widget _buildTableCalendar() {
//    return TableCalendar(
//      calendarController: _calendarController,
//      events: _events,
//      holidays: _holidays,
//      startingDayOfWeek: StartingDayOfWeek.monday,
//      calendarStyle: CalendarStyle(
//        selectedColor: Colors.deepOrange[400],
//        todayColor: Colors.deepOrange[200],
//        markersColor: Colors.brown[700],
//        outsideDaysVisible: false,
//      ),
//      headerStyle: HeaderStyle(
//        formatButtonTextStyle: TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
//        formatButtonDecoration: BoxDecoration(
//          color: Colors.deepOrange[400],
//          borderRadius: BorderRadius.circular(16.0),
//        ),
//      ),
//      onDaySelected: _onDaySelected,
//      onVisibleDaysChanged: _onVisibleDaysChanged,
//    );
//  }
//
//  // More advanced TableCalendar configuration (using Builders & Styles)
//  Widget _buildTableCalendarWithBuilders() {
//    return TableCalendar(
//      locale: 'pl_PL',
//      calendarController: _calendarController,
//      events: _events,
//      holidays: _holidays,
//      initialCalendarFormat: CalendarFormat.month,
//      formatAnimation: FormatAnimation.slide,
//      startingDayOfWeek: StartingDayOfWeek.sunday,
//      availableGestures: AvailableGestures.all,
//      availableCalendarFormats: const {
//        CalendarFormat.month: '',
//        CalendarFormat.week: '',
//      },
//      calendarStyle: CalendarStyle(
//        outsideDaysVisible: false,
//        weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
//        holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
//      ),
//      daysOfWeekStyle: DaysOfWeekStyle(
//        weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
//      ),
//      headerStyle: HeaderStyle(
//        centerHeaderTitle: true,
//        formatButtonVisible: false,
//      ),
//      builders: CalendarBuilders(
//        selectedDayBuilder: (context, date, _) {
//          return FadeTransition(
//            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
//            child: Container(
//              margin: const EdgeInsets.all(4.0),
//              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
//              color: Colors.deepOrange[300],
//              width: 100,
//              height: 100,
//              child: Text(
//                '${date.day}',
//                style: TextStyle().copyWith(fontSize: 16.0),
//              ),
//            ),
//          );
//        },
//        todayDayBuilder: (context, date, _) {
//          return Container(
//            margin: const EdgeInsets.all(4.0),
//            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
//            color: Colors.amber[400],
//            width: 100,
//            height: 100,
//            child: Text(
//              '${date.day}',
//              style: TextStyle().copyWith(fontSize: 16.0),
//            ),
//          );
//        },
//        markersBuilder: (context, date, events, holidays) {
//          final children = <Widget>[];
//
//          if (events.isNotEmpty) {
//            children.add(
//              Positioned(
//                right: 1,
//                bottom: 1,
//                child: _buildEventsMarker(date, events),
//              ),
//            );
//          }
//
//          if (holidays.isNotEmpty) {
//            children.add(
//              Positioned(
//                right: -2,
//                top: -2,
//                child: _buildHolidaysMarker(),
//              ),
//            );
//          }
//
//          return children;
//        },
//      ),
//      onDaySelected: (date, events) {
//        _onDaySelected(date, events);
//        _animationController.forward(from: 0.0);
//      },
//      onVisibleDaysChanged: _onVisibleDaysChanged,
//    );
//  }
//
//  Widget _buildEventsMarker(DateTime date, List events) {
//    return AnimatedContainer(
//      duration: const Duration(milliseconds: 300),
//      decoration: BoxDecoration(
//        shape: BoxShape.rectangle,
//        color: _calendarController.isSelected(date)
//            ? Colors.brown[500]
//            : _calendarController.isToday(date) ? Colors.brown[300] : Colors.blue[400],
//      ),
//      width: 16.0,
//      height: 16.0,
//      child: Center(
//        child: Text(
//          '${events.length}',
//          style: TextStyle().copyWith(
//            color: Colors.white,
//            fontSize: 12.0,
//          ),
//        ),
//      ),
//    );
//  }
//
//  Widget _buildHolidaysMarker() {
//    return Icon(
//      Icons.add_box,
//      size: 20.0,
//      color: Colors.blueGrey[800],
//    );
//  }
//
//  Widget _buildButtons() {
//    return Column(
//      children: <Widget>[
//        Row(
//          mainAxisSize: MainAxisSize.max,
//          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//          children: <Widget>[
//            RaisedButton(
//              child: Text('month'),
//              onPressed: () {
//                setState(() {
//                  _calendarController.setCalendarFormat(CalendarFormat.month);
//                });
//              },
//            ),
//            RaisedButton(
//              child: Text('2 weeks'),
//              onPressed: () {
//                setState(() {
//                  _calendarController.setCalendarFormat(CalendarFormat.twoWeeks);
//                });
//              },
//            ),
//            RaisedButton(
//              child: Text('week'),
//              onPressed: () {
//                setState(() {
//                  _calendarController.setCalendarFormat(CalendarFormat.week);
//                });
//              },
//            ),
//          ],
//        ),
//        const SizedBox(height: 8.0),
//        RaisedButton(
//          child: Text('setDay 18-08-2019'),
//          onPressed: () {
//            _calendarController.setSelectedDay(DateTime(2019, 8, 18), runCallback: true);
//          },
//        ),
//      ],
//    );
//  }
//
//  Widget _buildEventList() {
//    return ListView(
//      children: _selectedEvents
//          .map((event) => Container(
//        decoration: BoxDecoration(
//          border: Border.all(width: 0.8),
//          borderRadius: BorderRadius.circular(12.0),
//        ),
//        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//        child: ListTile(
//          title: Text(event.toString()),
//          onTap: () => print('$event tapped!'),
//        ),
//      ))
//          .toList(),
//    );
//  }
//  void updateListView() {
//    print('gogo');
//    final Future<Database> dbFuture = databaseHelper.initDatabase();
//    dbFuture.then((database) {
//      Future<List<Money>> moneyListFuture = databaseHelper.getMoneyList();
////      getDateAndTotal
//
//      moneyListFuture.then((moneyList) {
//        print('흠 / //  $moneyList');
//        setState(() {
//          this.moneyList = moneyList;
////          this.count = moneyList.length;
//        });
//      });
//    });
//  }
//}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/utils/store.dart';
import 'package:provider/provider.dart';

// ...

class Setting extends StatefulWidget {
//  final format = DateFormat("yyyy-MM-dd");

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  Map nationName = {
    "AE": '아랍에미리트',
    "AU": '호주',
    "BH": '바레인',
    "BN": '브루나이',
    "CA": '캐나다',
    "CH": '스위스',
    "CN": '중국',
    "DK": '덴마크',
    "EU": '유로',
    "GB": '영국',
    "HK": '홍콩',
    "ID": '인도네시아',
    "JP": '일본',
    "KR": '한국',
    "KW": '쿠웨이트',
    "MY": '말레이시아',
    "NO": '노르웨이',
    "NZ": '뉴질랜드',
    "SA": '사우디',
    "SE": '스웨덴',
    "SG": '싱가포르',
    "TH": '태국',
    "US": '미국'
  };
  List nationList = [
    '아랍에미리트',
    '호주',
    '바레인',
    '브루나이',
    '캐나다',
    '스위스',
    '중국',
    '덴마크',
    '유로',
    '영국',
    '홍콩',
    '인도네시아',
    '일본',
    '한국',
    '쿠웨이트',
    '말레이시아',
    '노르웨이',
    '뉴질랜드',
    '사우디',
    '스웨덴',
    '싱가포르',
    '태국',
    '미국'
  ];

  TextEditingController _current = TextEditingController();

  TextEditingController _target = TextEditingController();

  String _cur = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _current.addListener(() {
      setState(() {
        _target.text = _current.text;
      });
    });
    _current.addListener(() {
      setState(() {
        _target.text = _current.text;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _current.dispose();
    _target.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      child: Column(children: <Widget>[
        SizedBox(
          height: 50,
        ),
        Container(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.grey[400])),
          width: width * 0.85,
          height: 150,
          child: Column(
            children: <Widget>[
              Container(
                height: 50,
                child: Row(
//                crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('기준'),
                    DropdownButton<String>(
                      value: Provider.of<Store>(context).getCurrentNation,
                      onChanged: (value) {
                        Provider.of<Store>(context).setCurrentNation(value);
                      },
                      items: nationList.map<DropdownMenuItem<String>>((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              TextField(
                controller: _current,
              ),
              Text(_cur)
            ],
          ),
        ),
        Container(
          decoration:
              BoxDecoration(border: Border.all(color: Colors.grey[400])),
          width: width * 0.85,
          height: 150,
          child: Column(
            children: <Widget>[
              Container(
                height: 50,
                child: Row(
//                crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('타겟'),
                    DropdownButton<String>(
                      value: Provider.of<Store>(context).getTargetNation,
                      onChanged: (value) {
                        Provider.of<Store>(context).setTargetNation(value);
                      },
                      items: nationList.map<DropdownMenuItem<String>>((value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              TextField(
                controller: _target,
              )
            ],
          ),
        ),
      ]),
    );
  }
}
