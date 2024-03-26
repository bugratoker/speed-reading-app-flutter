import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/models/ChunkModel.dart';
import 'package:flutter_application_2/pages/reading/widgets/reading_page.dart';
import 'package:flutter_application_2/pages/reading/widgets/reading_page2.dart';
import 'package:flutter_application_2/utils/helper_widgets.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
/*
    Future<File> fromAsset(String asset, String filename) async {
    Completer<File> completer = Completer();
    try {
      //var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }
*/
  Future<List<int>> _readDocumentData(String name) async {
    final ByteData data = await rootBundle.load('assets/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  Future<List<String>> _extractTextFromPDF(String pdfPath) async {
    PdfDocument document =
        PdfDocument(inputBytes: await _readDocumentData('sample.pdf'));

    //Create a new instance of the PdfTextExtractor.
    PdfTextExtractor extractor = PdfTextExtractor(document);
    String text = extractor.extractText();
    // Split the input string based on one or more whitespace characters
    List<String> words = text.split(RegExp(r'\s+'));

    // Remove empty strings resulting from consecutive spaces
    words.removeWhere((word) => word.isEmpty);

    //List<String> first500Words = words.take(500).toList();
    return words;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text("Speed Reader",
            style: Theme.of(context).textTheme.displayMedium),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await _extractTextFromPDF("ASD").then((value) {
                  final chunkModel = ChunkModel(allPdfText: value);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                        create: (context) => chunkModel,
                        child: const ReadingPage2(
                            title: "Speed Reader"), // Removed const here
                      ),
                    ),
                  );
                });
              },
              child: const Text('Import PDF'),
            ),
            addVerticalSpace(30),
            ElevatedButton(
              onPressed: () async {
                await _extractTextFromPDF("ASD").then((value) => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const ReadingPage(title: "Speed Reader"))));
              },
              child: const Text('Read Daily News'),
            ),
            addVerticalSpace(30),
            ElevatedButton(
              onPressed: () async {
                await _extractTextFromPDF("ASD").then((value) => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const ReadingPage(title: "Speed Reader"))));
              },
              child: const Text('Read Saved Books'),
            ),
            addVerticalSpace(30),
            ElevatedButton(
              onPressed: () async {
                await _extractTextFromPDF("ASD").then((value) => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const ReadingPage(title: "Speed Reader"))));
              },
              child: const Text('Read text'),
            )
          ],
        ),
      ),
    );
  }
}
