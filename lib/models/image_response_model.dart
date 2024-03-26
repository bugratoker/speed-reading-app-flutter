import 'dart:ffi';

class ImageResponseModel{

  final String image;
  final String summarizedText;
  final Float elapsedTime;

  ImageResponseModel({required this.image, required this.summarizedText, required this.elapsedTime});

}