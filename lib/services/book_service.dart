import "package:dio/dio.dart";
import "package:flutter_application_2/models/book_model.dart";
import "package:flutter_application_2/values/app_strings.dart";

class BookService {
  static String portNumber = AppStrings.portNumber;
  static String jwt =AppStrings.jwt;
  static Future<List<Book>> getAllBooksByUserId(
      String userId) async {
    try {
      Response response =
          await Dio().get('https://10.0.2.2:$portNumber/v1/books',
              options: Options(headers: {
                'accept': "application/json",
                'Authorization':"Bearer $jwt"
              }),
              queryParameters: {
                'userId': "a6788324-b344-4991-aa12-0d7d1b885fcc"
              }
              );
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        List<Book> books = data.map((json) => Book.fromJson(json)).toList();
        return books;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
