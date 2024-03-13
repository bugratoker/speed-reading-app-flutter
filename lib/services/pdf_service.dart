import "dart:typed_data";

import "package:flutter/services.dart";
import "package:flutter_application_2/services/api_service.dart";
import "package:syncfusion_flutter_pdf/pdf.dart";

class PDFService {
  
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

  void processPDF(String pdfText) {
    // Split PDF text into chunks of 300 words
    List<String> chunks = splitTextIntoChunks(pdfText, 300);

    // Process each chunk
    chunks.forEach((chunk) async {
      // Summarize the chunk
      String summarizedText = await APIService.summarizeText(chunk);

      // Generate image from summarized text
      String generatedImage = await APIService.generateImage(summarizedText);

      // Do something with the generated image
      // e.g., save it to disk or display it to the user
    });
  }
}
