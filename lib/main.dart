import 'package:flutter/material.dart';
import 'src/main_page.dart';
import 'package:provider/provider.dart';
import 'util/store.dart';
import  'package:localstorage/localstorage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final LocalStorage storage = new LocalStorage('trip');

  @override
  Widget build(BuildContext context) {

    storage.setItem('use_money',{
      "00000000" : []
    });

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider<Money>(
          builder: (_) => Money(), child: MainPage()),
    );
  }
}
