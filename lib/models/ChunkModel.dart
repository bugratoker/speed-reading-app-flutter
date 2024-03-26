import 'package:flutter/material.dart';

class ChunkModel extends ChangeNotifier {

  List<String> allPdfText;
  late List<String> textChunks;
  late String imagePath;
  int chunkSize = 50;
  int currentPosition = 0;

  String get getText => textChunks[currentPosition];

  ChunkModel( {required this.allPdfText}) {
    print(allPdfText.first);
    _splitTextIntoChunks();
  }

  void _splitTextIntoChunks() {
    textChunks = [];
    final words = allPdfText;
    for (int i = 0; i < words.length-300; i += chunkSize) {

      final chunk = words.sublist(i, i + chunkSize).join(' ');
      textChunks.add(chunk);
    }
    print(textChunks.first);
  }

  void changeText() {
    if (currentPosition + 1 < textChunks.length) {
      currentPosition++;
      notifyListeners();
    } else {
      // ignore: avoid_print
      print('No more chunks available.');
    }
  }
}
