import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/pdf_screen/pdf_screen.dart';
class ReadingPage3 extends StatelessWidget {
  final String filePath;

  const ReadingPage3({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reading Page"),
      ),
      body: Center(
        child: PDFScreen(path: filePath),
      ),
    );
  }
}