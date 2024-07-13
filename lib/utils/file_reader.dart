import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/models/ChunkModel.dart';
import 'package:flutter_application_2/pages/reading/widgets/reading_page2.dart';
import 'package:flutter_application_2/services/book_service.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class FileReader {
  static Future<void> pickPDFAndNavigate(
      BuildContext context, String id) async {
    String userId = id;
    int? pageNumber;
    List<int> newBytes;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (!context.mounted) return;
    pageNumber = await _askForPageNumber(context);

    if (!context.mounted) return;
    if (result != null && pageNumber!=null) {
      PlatformFile file = result.files.first;

      File pdfFile = File(file.path!);
      List<int> bytes = await pdfFile.readAsBytes();

      // Load the PDF document
      PdfDocument document = PdfDocument(inputBytes: bytes);

      // Remove pages before the specified startPage
      for (int i = pageNumber - 2; i >= 0; i--) {
        document.pages.removeAt(0);
      }
      newBytes = document.saveSync();
      document.dispose();
      // Extract text (or prepare PDF content)
      await extractTextFromPDF(fileBytes: newBytes).then((pdfContent) async {
        // Ask for PDF name
        String? pdfName = await _askForPDFName(context);

        if (pdfName != null && pdfName.isNotEmpty && pageNumber != null) {
          // Here you would typically send the PDF content and name to your server
          String bookId =
              await BookService.savePDF(newBytes, pdfName, userId);

          // Continue with your existing flow
          final chunkModel = ChunkModel(
              allPdfText: pdfContent, currentPosition: 0, bookId: bookId);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MultiProvider(
                providers: [
                  ChangeNotifierProvider<ChunkModel>(
                    create: (_) => chunkModel,
                  ),
                ],
                child: ReadingPage2(title: "Speed Reader",pdfBytes:newBytes),
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('PDF naming cancelled')));
        }
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No file selected')));
    }
  }

  static Future<List<String>> extractTextFromPDF(
      {String? pdfPath, List<int>? fileBytes}) async {
    List<int> bytes;

    if (fileBytes != null) {
      // Read bytes from the File
      bytes = fileBytes;
    } else if (pdfPath != null) {
      // Read bytes from the file path
      File file = File(pdfPath);
      bytes = await file.readAsBytes();
    } else {
      throw ArgumentError('Either pdfPath or pdfFile must be provided');
    }

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

  static Future<int> getChunkCount({List<int>? fileBytes}) async {
    // Load the PDF document
    PdfDocument document = PdfDocument(inputBytes: fileBytes);

    // Create a text extractor
    PdfTextExtractor extractor = PdfTextExtractor(document);
    String text = extractor.extractText();

    // Split text into words and filter out empty entries
    List<String> words = text.split(RegExp(r'\s+'));
    words.removeWhere((word) => word.isEmpty);
    int chunkCount = (words.length / 150).ceil();
    return chunkCount;
  }

  static Future<String?> _askForPDFName(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController _nameController = TextEditingController();
        return AlertDialog(
          title: const Text('Name Your PDF'),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(hintText: "Enter PDF name"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(_nameController.text);
              },
            ),
          ],
        );
      },
    );
  }

  static Future<int?> _askForPageNumber(BuildContext context) async {
    return showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController _pageNumberController = TextEditingController();
        return AlertDialog(
          title: const Text('Enter page number'),
          content: TextField(
            controller: _pageNumberController,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            decoration: const InputDecoration(
                hintText: "to avoid reading unnecessary text"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                int? pageNumber = int.tryParse(_pageNumberController.text);
                Navigator.of(context).pop(pageNumber);
              },
            ),
          ],
        );
      },
    );
  }
}
