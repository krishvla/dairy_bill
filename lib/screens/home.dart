import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:new_dairy_bill/screens/generated_form.dart';
import 'package:new_dairy_bill/utils/loaders.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int days = 0;
  late double commision, liter_price;
  // String username;
  bool gotDays = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/background3.png"), fit: BoxFit.cover)),
      child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
          child: buildHomeScreen(),

        ),
    );
  }

  Widget buildHomeScreen(){
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Milk Dairy Bill"),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin:
                    EdgeInsets.only(top: 5, right: 20, left: 20, bottom: 20),
                child: Row(
                  children: [
                    Container(
                      width: (MediaQuery.of(context).size.width - 50) * 0.45,
                      padding: EdgeInsets.only(left: 20, right: 20),
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {
                          days = int.parse(value);
                          // setState(() {
                          //   days = int.parse(value);
                          // });
                        },
                        decoration: InputDecoration(
                            labelText: "Days",
                            suffixIcon: Icon(
                              Icons.confirmation_number,
                              color: Colors.white,
                            ),
                            labelStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none),
                      ),
                    ),
                    Container(
                      width: (MediaQuery.of(context).size.width - 50) * 0.55,
                      padding: EdgeInsets.only(left: 20, right: 20),
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {
                          setState(() {
                            commision = double.parse(value);
                          });
                        },
                        decoration: InputDecoration(
                            labelText: "Commission",
                            suffixIcon: Icon(
                              Icons.integration_instructions,
                              color: Colors.white,
                            ),
                            labelStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(top: 5, right: 20, left: 20, bottom: 20),
                child: Row(
                  children: [
                    Container(
                      width: (MediaQuery.of(context).size.width - 50) * 0.75,
                      padding: EdgeInsets.only(left: 20, right: 20),
                      // margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        onChanged: (value) {
                          setState(() {
                            liter_price = double.parse(value);
                          });
                        },
                        decoration: InputDecoration(
                            labelText: "Price Per Liter Rs.",
                            suffixIcon: Icon(
                              Icons.money,
                              color: Colors.white,
                              size: 40,
                            ),
                            labelStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none),
                      ),
                    ),
                    Container(
                      width: (MediaQuery.of(context).size.width - 50) * 0.25,
                      padding: EdgeInsets.only(left: 20, right: 20),
                      margin: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.next_plan,
                          color: Colors.white,
                        ),
                        iconSize: 35,
                        onPressed: () {
                          rippleLoader();
                          // if (username == '' || username == null || username.isEmpty) {
                          //   EasyLoading.showError('Please Enter Username');
                          // } else
                          if (days == null || days < 1 || days > 30) {
                            EasyLoading.showError(
                                'Please Enter Days in between 1 to 15');
                          } else if (commision == null ||
                              commision < 0 ||
                              commision > 100) {
                            EasyLoading.showError(
                                'Please Enter Commission in between 1 to 100');
                          } else if (liter_price == null || liter_price < 10) {
                            EasyLoading.showError(
                                'Please Enter Liter Price Greater than 10');
                          } else {
                            setState(() {
                              gotDays = true;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              gotDays
                  ? Container(
                      margin: const EdgeInsets.all(5),
                      child: GeneratedForm(days, commision, liter_price),
                    )
                  : Container()
            ],
          ),
        )),
      );
  }
}
