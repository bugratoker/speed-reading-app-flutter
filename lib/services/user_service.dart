import "dart:convert";
import "package:dio/dio.dart";
import "package:flutter_application_2/values/app_strings.dart";

class UserService {
  static String tenantValue = 'root';
  static String portNumber = AppStrings.portNumber;
  static Future<Map<String, dynamic>> logIn(
      Map<String, dynamic> requestBody) async {
    try {
      Response response = await Dio().post('https://10.0.2.2:$portNumber/tokens',
          options: Options(headers: {
            'tenant': tenantValue,
            'accept': "application/json",
            'Content-Type': "application/json"
          }),
          data: jsonEncode(requestBody));
      print("Response token: ${response.data}");
      if (response.statusCode == 200) {
        String token = response.data['token'];
        AppStrings.jwt= token;
        print("Response token: ${response.data['token']}");
        return {"response": true, "token": token};
      } else {
        return {"response": false, "token": ""};
      }
    } catch (e) {
      print("Error fetching data: $e");
      return {"response": false, "token": ""};
    }
  }

  static Future<Map<String, dynamic>> register(
      Map<String, dynamic> requestBody) async {
    try {
      Response response = await Dio().post('https://10.0.2.2:$portNumber/users/self-register',
          options: Options(headers: {
            'tenant': tenantValue,
            'accept': "application/json",
            'Content-Type': "application/json"
          }),
          data: jsonEncode(requestBody));
      if (response.statusCode == 200) {
        
        
        return {"response": true};
      } else {
        return {"response": false};
      }
    } catch (e) {
      print("Error fetching data: $e");
      return {"response": false};
    }
  }
}
