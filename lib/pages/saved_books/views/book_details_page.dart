import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/ChunkModel.dart';
import 'package:flutter_application_2/models/book_data.dart';
import 'package:flutter_application_2/models/book_view_model.dart';
import 'package:flutter_application_2/pages/reading/widgets/reading_page2.dart';
import 'package:flutter_application_2/pages/saved_books/widgets/loading_screen.dart';
import 'package:flutter_application_2/services/book_service.dart';
import 'package:provider/provider.dart';

class BookDetailsPage extends StatefulWidget {
  const BookDetailsPage(
      {super.key, required this.bookId, required this.bookName});
  final String bookId;
  final String bookName;

  @override
  State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  late BookView book;
  late BookData bookData;
  bool isLoading = true; // Add a loading state
  bool _disposed = false;
  @override
  void initState() {
    super.initState();
    _initalizeSelectedBook();
  }

  @override
  void dispose() {
    // ignore: avoid_print
    print('Bookdetails page disposed');
    _disposed = true;
     // Set the disposed flag to true
    super.dispose();
  }

  Future<void> _initalizeSelectedBook() async {
    try {
      bookData = await BookService.getBookById(widget.bookId);
      if (!_disposed) {
        book = bookData.bookView;
      } else {
        return;
      }
    } catch (e) {
      return;
    } finally {
      if (!_disposed) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const PrettyLoadingScreen();
    }

    return ChangeNotifierProvider<ChunkModel>(
        create: (_) => ChunkModel(
            allPdfText: book.pdfContent,
            currentPosition: book.currentChunkIndex,
            bookId: widget.bookId),
        child: ReadingPage2(
          title: book.name,
          pdfBytes: bookData.pdfBytes,
        ));
  }
}
