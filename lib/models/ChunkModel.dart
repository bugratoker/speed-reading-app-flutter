import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/services/api_service.dart';

class ChunkModel extends ChangeNotifier {
  List<String> allPdfText;
  late List<String> textChunks;
  Image? image;
  late String bookId;
  int chunkSize = 150;
  int currentPosition = 0;
  bool _disposed = false; // Flag to track if the model has been disposed
  Image? get getImage => image;
  String get getText => textChunks[currentPosition];

  ChunkModel(
      {required this.allPdfText,
      required this.currentPosition,
      required this.bookId}) {
    print(allPdfText.first);
    _splitTextIntoChunks();
  }
  @override
  void dispose() {
    // ignore: avoid_print
    print('ChunkModel disposed');
    _disposed = true; // Set the disposed flag to true
    super.dispose();
  }

  void _splitTextIntoChunks() {
    textChunks = [];
    final words = allPdfText;

    for (int i = 0; i < words.length; i += chunkSize) {
      int endIndex = i + chunkSize;
      if (endIndex > words.length) {
        endIndex = words.length;
      }
      final chunk = words.sublist(i, endIndex).join(' ');
      textChunks.add(chunk);
    }
    //if (words.length < 200) {return;}
    changeImage();
  }

  void changeText() {
    if (_disposed) return; // Check if the model has been disposed
    if (currentPosition + 1 < textChunks.length) {
      currentPosition++;
      if (!_disposed) {
        // Check again before notifying listeners
        notifyListeners();
      }
    } else {
      // ignore: avoid_print
      print('No more chunks available.');
    }
    if (!_disposed) {
      // Ensure not disposed before proceeding to change the image
      if(getText.split(' ').length<150){return;}
      changeImage();
    }
  }

  void changeImage() async {
    var base64image =
        await APIService.generateImage(textChunks[currentPosition]);
    if (_disposed) return; // Check if disposed before updating the UI

    image = Image.memory(base64Decode(base64image));
    if (!_disposed) {
      // Double-check in case the model was disposed during image processing
      notifyListeners();
    }
  }
}
