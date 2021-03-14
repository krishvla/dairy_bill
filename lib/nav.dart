import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:miilk_dairy_bill/screens/home.dart';
import 'package:miilk_dairy_bill/screens/bills_list.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;
  List<Widget> _WidgetScreens = <Widget>[
    HomePage(),
    BillsPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: _WidgetScreens.elementAt(currentIndex),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: currentIndex,
        onItemSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              textAlign: TextAlign.center,
              icon: Icon(Icons.home),
              title: Text('Home'),
              activeColor: Color.fromARGB(255, 2, 170, 176),
              inactiveColor: Colors.black),
          BottomNavyBarItem(
              textAlign: TextAlign.center,
              icon: Icon(Icons.account_balance_wallet_rounded),
              title: Text('Bills'),
              activeColor: Color.fromARGB(255, 2, 170, 176),
              inactiveColor: Colors.black),
        ],
      ),
    );
  }
}
