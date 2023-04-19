import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewer extends StatefulWidget {
  String filePath;
  
  PdfViewer(this.filePath, {super.key});

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  
  @override
Widget build(BuildContext context) {
  return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: const Text('Report Share'),
        trailing: IconButton(
          icon: const Icon(CupertinoIcons.share),
          color: Colors.blueAccent,
          onPressed: (){
            Share.shareFiles([widget.filePath], text: 'Great picture');
          },
        ),
      ),
      body: SafeArea(
        child: buildBody(),
      ),
      floatingActionButton: IconButton(
        icon: const Icon(CupertinoIcons.share),
        color: Colors.blueAccent,
        onPressed: (){
          Share.shareFiles([widget.filePath], text: 'Great picture');
        },
      ),
    );
  }

  Widget buildBody(){
    return Container(
      child: SfPdfViewer.file(
              File(widget.filePath)),
    );
  }
}