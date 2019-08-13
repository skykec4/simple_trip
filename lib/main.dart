import 'package:flutter/material.dart';
import 'src/main_page.dart';
import 'package:provider/provider.dart';
import 'util/store.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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
