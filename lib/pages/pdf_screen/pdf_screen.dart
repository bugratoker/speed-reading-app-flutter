import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
class PDFScreen extends StatefulWidget {
  final String path;

  const PDFScreen({super.key, required this.path});

  @override
  // ignore: library_private_types_in_public_api
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfPdfViewer.file(File(widget.path))
    );
  }
}