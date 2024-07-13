import "dart:convert";
import "dart:io";
import "package:dio/dio.dart";
import "package:flutter_application_2/models/book_data.dart";
import "package:flutter_application_2/models/book_model.dart";
import "package:flutter_application_2/models/book_view_model.dart";
import "package:flutter_application_2/utils/file_reader.dart";
import "package:flutter_application_2/values/app_strings.dart";
class BookService {
  static String portNumber = AppStrings.portNumber;
  static String jwt = AppStrings.jwt;
  static Future<List<Book>> getAllBooksByUserId(String userId) async {
    try {
      Response response = await Dio().get(
          'https://10.0.2.2:$portNumber/v1/books',
          options: Options(headers: {
            'accept': "application/json",
            'Authorization': "Bearer $jwt"
          }),
          queryParameters: {'userId': userId});
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
  static Future<String> savePDF(
      List<int> pdfBytes, String pdfName, String userId) async {

    int totalChunkCount = await FileReader.getChunkCount(fileBytes: pdfBytes);
    // Convert to base64 string
    String base64Pdf = base64Encode(pdfBytes);
    // Create request body
    Map<String, dynamic> requestBody = {
      "name": pdfName,
      "currentChunkIndex": 0,
      "wordIndex": 0,
      "userId": userId,
      "pdfContent": base64Pdf,
      "totalChunkCount":totalChunkCount
    };
    // Send POST request
    try {
      Response response = await Dio().post(
          'https://10.0.2.2:$portNumber/v1/books',
          options: Options(headers: {
            'accept': "application/json",
            'Authorization': "Bearer $jwt"
          }),
          data: requestBody);
      if (response.statusCode == 200) {
        // Handle response
        print('PDF uploaded successfully');
        return response.data;
      } else {
        // Handle error
        print(
            'Failed to upload PDF: ${response.statusCode} - ${response.statusMessage}');
            return "";
      }
    } catch (e) {
      print('Failed to upload PDF: $e');
      return "";
    }
  }
  static Future<BookData> getBookById(String bookId) async {
    try {
      Response response = await Dio().get(
          'https://10.0.2.2:$portNumber/v1/books/$bookId',
          options: Options(headers: {
            'accept': "application/json",
            'Authorization': "Bearer $jwt"
          }));
      if (response.statusCode == 200) {
        String data = response.data["pdfContent"];
        List<int> bytes = base64Decode(data);

        List<String> allWords =
            await FileReader.extractTextFromPDF(fileBytes: bytes);
        BookView book = BookView(
            id: bookId,
            name: response.data["name"],
            currentChunkIndex: response.data["currentChunkIndex"],
            totalChunkCount: response.data["totalChunkCount"],
            wordIndex: response.data["wordIndex"],
            pdfContent: allWords);
        BookData bookData = BookData(bookView: book, pdfBytes: bytes);
        return bookData;
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception();
    }
  }
  static Future<void> updateBookProperties(
      String bookId,int currentChunkIndex, int wordIndex) async {
    try {
      Response response = await Dio().put(
        'https://10.0.2.2:$portNumber/v1/books',
        options: Options(headers: {
          'accept': "application/json",
          'Authorization': "Bearer $jwt"
        }),
        data: {
          "id": bookId,
          "currentChunkIndex": currentChunkIndex,
          "wordIndex": wordIndex
        },
      );
      // ignore: avoid_print
      print('Book properties updated: ${response.data}');
    } catch (e) {
      // ignore: avoid_print
      print('Failed to update book properties: $e');
    }
  }
  static Future<bool> deleteBookById(String bookId) async {
    try {
      Response response = await Dio().delete(
          'https://10.0.2.2:$portNumber/v1/books',
          options: Options(headers: {
            'accept': "application/json",
            'Authorization': "Bearer $jwt"
          }),
          queryParameters: {'id': bookId});
      if (response.statusCode == 200) {
        await Future.delayed(const Duration(seconds: 1));
        return true;
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception();
    }
  }
}