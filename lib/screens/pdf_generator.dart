import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:new_dairy_bill/screens/pdf_viewer.dart';
import 'package:new_dairy_bill/utils/file_saver_helper.dart';
import 'package:new_dairy_bill/utils/loaders.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfGenerator extends StatefulWidget {
  double calculatedLiters, calculatedBill, calculatedCommission, calculatedFinalBill;
  List<Map<String, String>> detailedData;

  PdfGenerator(
    this.calculatedLiters, this.calculatedBill, this.calculatedCommission, this.calculatedFinalBill,
      this.detailedData, {super.key});

  @override
  State<PdfGenerator> createState() => _PdfGeneratorState();
}

class _PdfGeneratorState extends State<PdfGenerator> {

  @override
  void initState() {
    rippleLoader();
    // TODO: implement initState
    super.initState();
  }
  
  final _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _generatePDF, 
      icon: const Icon(Icons.document_scanner, color: Colors.blueAccent, size: 30,));
  }
  

   _generatePDF() async {
    
    await Permission.storage.request();
    var status = await Permission.storage.status;
    if (status.isDenied) {
      await Permission.storage.request();
    }
    print("****************************************");
    print(status);
    print("****************************************");
    //Create a PDF document.
    final PdfDocument document = PdfDocument();
    //Add page to the PDF
    final PdfPage page = document.pages.add();
    //Get page client size
    final Size pageSize = page.getClientSize();
    //Draw rectangle
    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
        pen: PdfPen(PdfColor(142, 170, 219)));
    //Generate PDF grid.
    final PdfGrid grid = _getGrid();
    //Draw the header section by creating text element
    final PdfLayoutResult result = _drawHeader(page, pageSize, grid);
    //Draw grid
    _drawGrid(page, grid, result);
    //Add invoice footer
    // _drawFooter(page, pageSize);
    //Save and dispose the document.
    final List<int> bytes = await document.save();
    document.dispose();
    //Launch file.
    String filePath = await FileSaveHelper.saveAndLaunchFile(bytes, 'Invoice_${getRandomString(10)}.pdf');
    if(filePath.isEmpty || filePath == ""){
     EasyLoading.showError("Error while Generating PDF");
     return; 
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PdfViewer(
        filePath
      )));
  }

  //Draws the invoice header
  PdfLayoutResult _drawHeader(PdfPage page, Size pageSize, PdfGrid grid) {
    //Draw rectangle
    page.graphics.drawRectangle(
        brush: PdfSolidBrush(PdfColor(91, 126, 215)),
        bounds: Rect.fromLTWH(0, 0, pageSize.width - 115, 90));
    //Draw string
    page.graphics.drawString(
        'INVOICE', PdfStandardFont(PdfFontFamily.helvetica, 30),
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(25, 0, pageSize.width - 115, 90),
        format: PdfStringFormat(lineAlignment: PdfVerticalAlignment.middle));
    page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 90),
        brush: PdfSolidBrush(PdfColor(65, 104, 205)));
    page.graphics.drawString(r'Rs.' + widget.calculatedFinalBill.toStringAsFixed(3),
        PdfStandardFont(PdfFontFamily.helvetica, 18),
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 100),
        brush: PdfBrushes.white,
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.middle));
    final PdfFont contentFont = PdfStandardFont(PdfFontFamily.helvetica, 9);
    //Draw string
    page.graphics.drawString('Amount', contentFont,
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(400, 0, pageSize.width - 400, 33),
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            lineAlignment: PdfVerticalAlignment.bottom));

    const String disclaimer = '** This is System generated Pdf. Please Inform if there are any mis-calculations';
    
    PdfTextElement(text: disclaimer, font: contentFont).draw(
      page: page,
      bounds: Rect.fromLTWH(
        10, 100, contentFont.measureString(disclaimer).width + 30, pageSize.height - 110)
    );
    //Create data foramt and convert it to text.
    final DateFormat format = DateFormat.yMMMMd('en_US');
    final String invoiceNumber = 'Invoice Number: INV${DateTime.now()}';
    final Size contentSize = contentFont.measureString(invoiceNumber);

    PdfTextElement(
      text: invoiceNumber, font: contentFont,
      ).draw(
        page: page,
        bounds: Rect.fromLTWH(pageSize.width - (contentSize.width + 30), 120,
            contentSize.width + 30, pageSize.height - 120));

    final PdfFont overviewFont = PdfStandardFont(PdfFontFamily.helvetica, 14, style: PdfFontStyle.bold);

    String milkText = "Total Milk (ltr) \n${widget.calculatedLiters.toStringAsFixed(3)}";
    final Size milkTextSize = contentFont.measureString(milkText);
    PdfTextElement(
      text: milkText,
      font: overviewFont,
    ).draw(
      page: page,
      bounds: Rect.fromLTWH(10, 140, milkTextSize.width + 60, pageSize.height - 120)
    );

    String billAmount = "Bill (Rs.) \n${widget.calculatedBill.toStringAsFixed(3)}";
    final Size billAmountTextSize = contentFont.measureString(billAmount);
    PdfTextElement(
      text: billAmount,
      font: overviewFont,
    ).draw(
      page: page,
      bounds: Rect.fromLTWH(
        milkTextSize.width + 90 , 140, 
        billAmountTextSize.width + 60, 
        pageSize.height - 120)
    );

    String comissionAmount = "Comm. (Rs.) \n${widget.calculatedCommission.toStringAsFixed(3)}";
    final Size comissionAmountTextSize = contentFont.measureString(comissionAmount);
    PdfTextElement(
      text: comissionAmount,
      font: overviewFont,
    ).draw(
      page: page,
      bounds: Rect.fromLTWH(
        milkTextSize.width + billAmountTextSize.width + 150 , 140, 
        comissionAmountTextSize.width  + 60, 
        pageSize.height - 120)
    );

    String finalAmount = "Final (Rs.) \n${widget.calculatedFinalBill.toStringAsFixed(3)}";
    final Size finalAmountTextSize = contentFont.measureString(finalAmount);
    return PdfTextElement(
      text: finalAmount,
      font: overviewFont,
    ).draw(
      page: page,
      bounds: Rect.fromLTWH(
        milkTextSize.width + billAmountTextSize.width + comissionAmountTextSize.width + 210 , 140, 
        finalAmountTextSize.width  + 60, 
        pageSize.height - 120)
    )!;


  }
  //Draws the grid
  void _drawGrid(PdfPage page, PdfGrid grid, PdfLayoutResult result) {
    Rect? totalPriceCellBounds;
    Rect? quantityCellBounds;
    //Invoke the beginCellLayout event.
    grid.beginCellLayout = (Object sender, PdfGridBeginCellLayoutArgs args) {
      final PdfGrid grid = sender as PdfGrid;
      if (args.cellIndex == grid.columns.count - 1) {
        totalPriceCellBounds = args.bounds;
      } else if (args.cellIndex == grid.columns.count - 2) {
        quantityCellBounds = args.bounds;
      }
    };
    //Draw the PDF grid and get the result.
    result = grid.draw(
        page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 10, 0, 0))!;
    // grid.draw(
    //     page: page, bounds: Rect.fromLTWH(0, result.bounds.bottom + 40, page.size.width * 0.4, 0))!;
    // result = grid.draw(
    //     page: page, bounds: Rect.fromLTWH(page.size.width * 0.4 + 20, result.bounds.bottom + 40, page.size.width * 0.4, 0))!;
  }

  //Draw the invoice footer data.
  void _drawFooter(PdfPage page, Size pageSize) {
    final PdfPen linePen =
        PdfPen(PdfColor(142, 170, 219), dashStyle: PdfDashStyle.custom);
    linePen.dashPattern = <double>[3, 3];
    //Draw line
    page.graphics.drawLine(linePen, Offset(0, pageSize.height - 100),
        Offset(pageSize.width, pageSize.height - 100));
    const String footerContent =
        'This is System generated Pdf. Please Inform if there are any mis-calculations';
    //Added 30 as a margin for the layout
    page.graphics.drawString(
        footerContent, PdfStandardFont(PdfFontFamily.helvetica, 9),
        format: PdfStringFormat(alignment: PdfTextAlignment.right),
        bounds: Rect.fromLTWH(pageSize.width - 30, pageSize.height - 30, 0, 0));
  }

  //Create PDF grid and return
  PdfGrid _getGrid() {
    //Create a PDF grid
    final PdfGrid grid = PdfGrid();
    //Secify the columns count to the grid.
    grid.columns.add(count: 3);
    //Create the header row of the grid.
    final PdfGridRow headerRow = grid.headers.add(1)[0];
    //Set style
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'Milk ( Ltr )';
    headerRow.cells[0].stringFormat.alignment = PdfTextAlignment.center;
    headerRow.cells[1].value = 'FAT ( % )';
    headerRow.cells[2].value = 'Amt ( Rs. )';
    for(int index = 0; index < widget.detailedData.length; index++){
      Map<String, String> currRowData = widget.detailedData[index];
      _addRowData(
        currRowData['milk_qty'].toString(), 
        currRowData['fat'].toString(), 
        currRowData['amt'].toString(), grid);
    }
    grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);
    for (int i = 0; i < headerRow.cells.count; i++) {
      headerRow.cells[i].style.cellPadding =
          PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      
      headerRow.cells[i].style.font = PdfStandardFont(PdfFontFamily.helvetica, 12);
    }
    for (int i = 0; i < grid.rows.count; i++) {
      final PdfGridRow row = grid.rows[i];
      for (int j = 0; j < row.cells.count; j++) {
        final PdfGridCell cell = row.cells[j];
        if (j == 0) {
          cell.stringFormat.alignment = PdfTextAlignment.center;
        }
        cell.style.cellPadding =
            PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
        
        cell.style.font = PdfStandardFont(PdfFontFamily.helvetica, 12);
      }
    }
    return grid;
  }

  //Create and row for the grid.
  void _addRowData(String milk, String fat, String price, PdfGrid grid) {
    final PdfGridRow row = grid.rows.add();
    row.cells[0].value = milk;
    row.cells[1].value = fat;
    row.cells[2].value = price;
  }

  //Get the total amount.
  double _getTotalAmount(PdfGrid grid) {
    double total = 0;
    for (int i = 0; i < grid.rows.count; i++) {
      final String value =
          grid.rows[i].cells[grid.columns.count - 1].value as String;
      total += double.parse(value);
    }
    return total;
  }
}