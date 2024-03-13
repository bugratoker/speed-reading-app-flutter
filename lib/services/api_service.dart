class APIService {
 static Future<String> summarizeText(String text) async {
    var response = await http.post(
      Uri.parse('YOUR_SUMMARIZATION_API_ENDPOINT'),
      body: {'text': text},
    );
    return response.body;
  }

  static Future<String> generateImage(String text) async {
    var response = await http.post(
      Uri.parse('YOUR_IMAGE_GENERATION_API_ENDPOINT'),
      body: {'text': text},
    );
    return response.body;
  }
}
