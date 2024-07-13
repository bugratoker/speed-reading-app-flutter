
import "package:dio/dio.dart";

class APIService {
  static Future<Map<String, dynamic>> generateImage(String text) async {
    //var summarizedText;
    String imageBase64 = "";
    String summarizedText="";
    try {
      Response response = await Dio().get(
        'http://10.0.2.2:8000/',
        queryParameters: {'prompt': text},
      );
      print("Response data: ${response.data}");
      //Map<String, dynamic> data = json.decode(response.data);
      imageBase64 = response.data['image'];
      summarizedText = response.data['summarizedText'];
      //summarizedText = response.data['summarizedText'];
    } catch (e) {
      //print("Error fetching data: $e");
    }
    return {"image":imageBase64,"summarizedText":summarizedText};
  }
}
