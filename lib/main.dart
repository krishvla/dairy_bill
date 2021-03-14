import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:miilk_dairy_bill/nav.dart';
import 'package:miilk_dairy_bill/screens/home.dart';

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
      builder: EasyLoading.init(),
    );
  }
}
