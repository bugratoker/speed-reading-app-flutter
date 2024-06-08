import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFScreen extends StatefulWidget {
  final List<int> pdfBytes;

  const PDFScreen({super.key, required this.pdfBytes});

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  @override
  Widget build(BuildContext context) {
    Uint8List pdfData = Uint8List.fromList(widget.pdfBytes);
    return Scaffold(
        body: SfPdfViewer.memory(pdfData)// Use the memory constructor
        );
  }
}
