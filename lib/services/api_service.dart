import "dart:convert";

import "package:dio/dio.dart";

class APIService {
  static Future<String> generateImage(String text) async {
    var summarizedText;
    var imageBase64;
    try {
      
      Response response = await Dio().get(
        'URLHERE',
        queryParameters: {'prompt': text},
      );

      Map<String, dynamic> data = json.decode(response.data);
      summarizedText = data['summarized_text'];
      imageBase64 = data['image'];
    } catch (e) {
      print("Error fetching data: $e");
    }

    return "";
  }
}
