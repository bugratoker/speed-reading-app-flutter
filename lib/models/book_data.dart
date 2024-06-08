import 'package:flutter_application_2/models/book_view_model.dart';

class BookData {
  final BookView bookView;
  final List<int> pdfBytes;
  
  BookData({required this.bookView, required this.pdfBytes});
}