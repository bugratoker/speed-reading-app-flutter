import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/services/api_service.dart';

class ChunkModel extends ChangeNotifier {
  List<String> allPdfText;
  late List<String> textChunks;
  late Image image;
  int chunkSize = 150;
  int currentPosition = 0;

  Image get getImage => image;
  String get getText => textChunks[currentPosition];

  ChunkModel({required this.allPdfText}) {
    print(allPdfText.first);
    _splitTextIntoChunks();
  }
  @override
  void dispose() {
    print('ChunkModel disposed');
    super.dispose();
  }

  void _splitTextIntoChunks() {
    textChunks = [];
    final words = allPdfText;
    for (int i = 0; i < words.length - 300; i += chunkSize) {
      final chunk = words.sublist(i, i + chunkSize).join(' ');
      textChunks.add(chunk);
    }
    print(textChunks.first);
    changeImage();
  }

  void changeText() {
    if (currentPosition + 1 < textChunks.length) {
      currentPosition++;
      notifyListeners();
    } else {
      // ignore: avoid_print
      print('No more chunks available.');
    }
    changeImage();
  }

  void changeImage() async {
    var base64image =
        await APIService.generateImage(textChunks[currentPosition]);
    image = Image.memory(base64Decode(base64image));
    notifyListeners();
  }
}
