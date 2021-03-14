import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:miilk_dairy_bill/utils/loaders.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';

class GeneratedForm extends StatefulWidget {
  int days;
  final double commission, liter_price;
  // final String username;
  GeneratedForm(this.days, this.commission, this.liter_price);
  @override
  _GeneratedFormState createState() => _GeneratedFormState();
}

class _GeneratedFormState extends State<GeneratedForm> {
  final _formKey = GlobalKey<FormState>();
  int currDays;
  Map<int, double> litersData = new Map();
  Map<int, double> fatData = new Map();
  String errorsData;
  double calculatedLiters,
      calculatedBill,
      calculatedCommission,
      calculatedFinalBill,
      priceValue;

  @override
  void initState() {
    // TODO: implement initState
    currDays = widget.days;
    priceValue = widget.liter_price / 10;
    calculatedLiters = 0;
    calculatedBill = 0;
    calculatedCommission = 0;
    calculatedFinalBill = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: builtContent(),
      ),
    );
  }

  manageLoader(day) {
    if (day == 0) {
      rippleLoader();
      EasyLoading.show(status: 'Generating Form..');
      return;
    }
    if (day == widget.days - 1) {
      EasyLoading.dismiss();
      return;
    }
    return;
  }

  showAlertDialog(
      BuildContext context, liters, bill, commision, finalBill, errors) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Calculated Results:"),
      content: Container(
        child: Column(
          children: <Widget>[
            // Display Toatl Liters
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Total Liters'),
                  Text(
                    liters.toStringAsFixed(3),
                  )
                ],
              ),
            ),
            // Display Total Bill
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[Text('Bill'), Text(bill.toStringAsFixed(3))],
              ),
            ),
            // Display Total Commision
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Commission'),
                  Text(commision.toStringAsFixed(3))
                ],
              ),
            ),
            // Display FInal Amount
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Final Bill '),
                  Text(finalBill.toStringAsFixed(3))
                ],
              ),
            ),
            // Display Errors
            errorsData == ''
                ? Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(bottom: 10, top: 20),
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('No Errors... '),
                  )
                : Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(bottom: 10),
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('Errors: '),
                  ),
            errorsData == ''
                ? Container()
                : Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(bottom: 10),
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SingleChildScrollView(
                      child: Text(errorsData),
                    ),
                  )
          ],
        ),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  generateBill() {
    rippleLoader();
    EasyLoading.show(status: 'Calculating Bill...');
    print(litersData);
    print(fatData);
    setState(() {
      errorsData = '';
    });
    calculatedBill = 0;
    calculatedLiters = 0;
    priceValue = widget.liter_price / 10;
    for (int i = 0; i < widget.days; i++) {
      if (litersData[i] != null && fatData[i] != null) {
        calculatedBill += litersData[i] * fatData[i] * priceValue;
        calculatedLiters += litersData[i];
      }
      if (litersData[i] == null) {
        errorsData += 'Data - ' + (i + 1).toString() + ' Liters Not Added.\n\n';
      }
      if (fatData[i] == null) {
        errorsData += 'Data - ' + (i + 1).toString() + ' FAT(%) Not Added.\n\n';
      }
    }
    calculatedCommission = calculatedBill * widget.commission / 100;
    calculatedFinalBill = calculatedBill - calculatedCommission;

    print("Total Liters - $calculatedLiters");
    print("Bill - $calculatedBill");
    print("Commission - $calculatedCommission");
    print("Final AMount - $calculatedFinalBill");

    showAlertDialog(context, calculatedLiters, calculatedBill,
        calculatedCommission, calculatedFinalBill, errorsData);

    EasyLoading.dismiss();
  }

  Widget builtContent() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Container(
                  height: MediaQuery.of(context).size.height - 330,
                  padding: EdgeInsets.only(top: 10),
                  child: StaggeredGridView.countBuilder(
                    crossAxisCount: 1,
                    crossAxisSpacing: 20,
                    itemCount: widget.days,
                    itemBuilder: (context, index) {
                      return buildForm(index);
                    },
                    staggeredTileBuilder: (index) => StaggeredTile.fit(1),
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  _formKey.currentState.reset();
                },
                child: Container(
                  height: 49,
                  width: (MediaQuery.of(context).size.width - 50) * 0.5,
                  padding: EdgeInsets.only(left: 20, right: 20),
                  margin: EdgeInsets.only(left: 10, top: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.redAccent),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Clear',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.clear,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  // rippleLoader();
                  generateBill();
                },
                child: Container(
                  height: 49,
                  width: (MediaQuery.of(context).size.width - 50) * 0.5,
                  padding: EdgeInsets.only(left: 20, right: 20),
                  margin: EdgeInsets.only(left: 10, top: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black38),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Generate Bill',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildForm(day) {
    // manageLoader(day);
    return Container(
      child: Column(
        children: <Widget>[
          Text('Data - ' + (day + 1).toString()),
          Row(
            children: <Widget>[
              Container(
                margin:
                    EdgeInsets.only(top: 5, right: 20, left: 20, bottom: 20),
                child: Row(
                  children: [
                    Container(
                      width: (MediaQuery.of(context).size.width - 50) / 2,
                      padding: EdgeInsets.only(left: 20, right: 20),
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        initialValue: null,
                        // controller: inputController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {
                          litersData.addAll({
                            day: double.parse(
                                value.replaceAll(new RegExp(r"\s+"), ""))
                          });
                          print("Liters - $value");
                          // print(litersData);
                        },
                        buildCounter: (context,
                            {int currentLength,
                            bool isFocused,
                            int maxLength}) {
                          if (currentLength == 0) {
                            litersData.addAll({day: null});
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: "Liters",
                            suffixIcon: Icon(
                              Icons.confirmation_number,
                              color: Colors.white,
                            ),
                            labelStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none),
                      ),
                    ),
                    Container(
                      width: (MediaQuery.of(context).size.width - 50) / 2,
                      padding: EdgeInsets.only(left: 20, right: 20),
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        initialValue: null,
                        // controller: inputController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        onChanged: (value) {
                          fatData.addAll({
                            day: double.parse(
                                value.replaceAll(new RegExp(r"\s+"), ""))
                          });
                          print("FAT  - $value");
                        },
                        buildCounter: (context,
                            {int currentLength,
                            bool isFocused,
                            int maxLength}) {
                          if (currentLength == 0) {
                            fatData.addAll({day: null});
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: "FAT (%)",
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
            ],
          )
        ],
      ),
    );
  }
}
