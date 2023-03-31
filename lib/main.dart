import 'package:flutter/material.dart';
import 'package:new_dairy_bill/screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Milk Dairy',
      theme: ThemeData.dark(),
      home: HomePage(),
    );
  }
}
