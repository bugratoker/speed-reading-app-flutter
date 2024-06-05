import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/ChunkModel.dart';
import 'package:flutter_application_2/models/book_view_model.dart';
import 'package:flutter_application_2/pages/reading/widgets/reading_page2.dart';
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
  bool isLoading = true; // Add a loading state
  @override
  void initState() {
    super.initState();
    _initalizeSelectedBook();
  }

  Future<void> _initalizeSelectedBook() async {
    try {
      book = await BookService.getBookById(widget.bookId);
    } catch (e) {
      return;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ChangeNotifierProvider<ChunkModel>(
        create: (_) => ChunkModel(
            allPdfText: book.pdfContent,
            currentPosition: book.currentChunkIndex,
            bookId: widget.bookId),
        child: ReadingPage2(
          title: book.name,
        ));
  }
}
