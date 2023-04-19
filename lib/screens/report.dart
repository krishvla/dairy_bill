import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:new_dairy_bill/screens/pdf_generator.dart';

class ReportsScreen extends StatefulWidget {
  double calculatedLiters, calculatedBill, calculatedCommission, calculatedFinalBill;
  List<TableRow> table_rows;
  List<Map<String, String>> detailedData;
  String errorsData;

  ReportsScreen(
    this.calculatedLiters, this.calculatedBill, this.calculatedCommission, this.calculatedFinalBill,
      this.table_rows, this.detailedData, this.errorsData, {super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final ScrollController _tablescrollbar = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CupertinoNavigationBar(
        middle: Text('Bill Report'),
      ),
      body: SafeArea(
        child: buildBody(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black38,
        onPressed: (){},
        child: buildPdfGeneratorButton(),
      ),
    );
  }

  Widget buildBody(){
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            buildOverview(),
            buildErrors(),
            buildDetailedReport(),
          ],
        ),
      ),
    );
  }

  Widget buildOverview(){
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              buildChip("Liters", widget.calculatedLiters.toStringAsFixed(3), Colors.white),
              buildChip("Bill", widget.calculatedBill.toStringAsFixed(3), Colors.redAccent)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              buildChip("Commision", widget.calculatedCommission.toStringAsFixed(3), Colors.greenAccent),
              buildChip("Final Bill", widget.calculatedFinalBill.toStringAsFixed(3), Colors.blueAccent)
            ],
          ),
        ],
      ),
    );
  }

  Widget buildChip(title, value, color){
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      padding: const EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 14, 
                  color: Colors.white,
                  ),
                child: Text(title),
              ),
            ],
          ),
          const SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 20, 
                    color: color, 
                    fontWeight: FontWeight.w600),
                  child: Text(value.toString()),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildErrors(){
    if(widget.errorsData.isEmpty || widget.errorsData==""){
      return Container();
    }

    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 10, right: 20, left: 20),
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Scrollbar(
        thumbVisibility: true,
        controller: _tablescrollbar,
        child: SingleChildScrollView(
          child: Text(widget.errorsData + widget.errorsData, style: const TextStyle(color: Colors.redAccent),),
        ),
      ),
    );
  }

  Widget buildDetailedReport(){
    if(widget.table_rows.length == 1){
      return Container();
    }

    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(top: 10, right: 20, left: 20),
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(10),
      ),

      child: Scrollbar(
        thumbVisibility: true,
        controller: _tablescrollbar,
        child: SingleChildScrollView(
          child: buildTable(),
        ),
      ),
    );
  }

  Widget buildTable(){
    return Table(
              border: TableBorder.all(color: Colors.white24, width: 2.5),
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: widget.table_rows,
            );
  }

  Widget buildPdfGeneratorButton(){
    return PdfGenerator(
      widget.calculatedLiters, widget.calculatedBill, 
      widget.calculatedCommission, widget.calculatedFinalBill,
      widget.detailedData,
    );
  }
}