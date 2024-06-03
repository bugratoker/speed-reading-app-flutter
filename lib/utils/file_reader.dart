import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/ChunkModel.dart';
import 'package:flutter_application_2/pages/reading/widgets/reading_page2.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class FileReader {
  static Future<void> pickPDFAndNavigate(BuildContext context) async {
    // Configure the file picker
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (!context.mounted) return;
    if (result != null) {
      // Get the selected file
      PlatformFile file = result.files.first;
      await extractTextFromPDF(file.path!).then((value) {
        final chunkModel = ChunkModel(allPdfText: value);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MultiProvider(
              providers: [
                ChangeNotifierProvider<ChunkModel>(
                  create: (_) => chunkModel,
                ),
              ],
              child: const ReadingPage2(
                title: "Speed Reader",
              ),
            ),
          ),
        );
      });
    } else {
      // User canceled the picker
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No file selected')));
    }
  }

  static Future<List<String>> extractTextFromPDF(String pdfPath) async {
    // Read the file from the file system
    File file = File(pdfPath);
    List<int> bytes = await file.readAsBytes();

    // Load the PDF document
    PdfDocument document = PdfDocument(inputBytes: bytes);

    // Create a text extractor
    PdfTextExtractor extractor = PdfTextExtractor(document);
    String text = extractor.extractText();

    // Split text into words and filter out empty entries
    List<String> words = text.split(RegExp(r'\s+'));
    words.removeWhere((word) => word.isEmpty);
    return words;
  }
}
// async {
//                         await _extractTextFromPDF("ASD").then((value) {
//                           final chunkModel = ChunkModel(allPdfText: value);
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => MultiProvider(
//                                 providers: [
//                                   ChangeNotifierProvider<ChunkModel>(
//                                     create: (_) => chunkModel,
//                                   ),
//                                 ],
//                                 child: const ReadingPage2(
//                                   title: "Speed Reader",
//                                 ),
//                               ),
//                             ),
//                           ).then((_) {
//                             // Dispose of chunkModel when returning from ReadingPage2
//                             chunkModel.dispose();
//                           });
//                         }
//                         );
//                       }