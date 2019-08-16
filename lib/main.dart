import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'src/main_page.dart';
import 'package:provider/provider.dart';
import 'util/store.dart';
import 'package:localstorage/localstorage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final LocalStorage storage = new LocalStorage('trip');

  @override
  Widget build(BuildContext context) {
    var nowNoDash = DateFormat('yyyyMMdd').format(DateTime.now());

    var _today = storage.getItem("use_money");

    if (_today == null) {
      var list = {nowNoDash: []};
      storage.setItem("use_money", list);
    }

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider<Money>(
          builder: (_) => Money(_today, storage), child: MainPage()),
    );
  }
}
