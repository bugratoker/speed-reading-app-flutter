import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/book_model.dart';
import 'package:flutter_application_2/pages/saved_books/views/book_details_page.dart';
import 'package:flutter_application_2/services/book_service.dart';

class SavedBooksPage extends StatefulWidget {
  const SavedBooksPage({super.key, required this.id});
  final String id;

  @override
  State<SavedBooksPage> createState() => _SavedBooksPageState();
}

class _SavedBooksPageState extends State<SavedBooksPage> {
  List<Book> allBooks = [];
  bool isLoading = true; // Add a loading state
  String? errorMessage; // Add an error message state

  Future<void> _initializeSavedBooks() async {
    try {
      allBooks = await BookService.getAllBooksByUserId(widget.id);
    } catch (e) {
      errorMessage = 'Failed to load books';
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeSavedBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Books'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (errorMessage != null) {
      return Center(child: Text(errorMessage!));
    }
    if (allBooks.isEmpty) {
      return const Center(child: Text('No books available.'));
    }
    return ListView.builder(
      itemCount: allBooks.length,
      itemBuilder: (context, index) {
        final book = allBooks[index];
        final double progress =
            (book.currentChunkIndex / book.totalChunkCount) * 100;
        final String progressText = "${progress.toStringAsFixed(0)}%";

        return Card(
          child: ListTile(
            title:
                Text(book.name, style: Theme.of(context).textTheme.bodyMedium),
            trailing: Text(progressText,
                style: Theme.of(context).textTheme.bodySmall),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      BookDetailsPage(bookId: book.id, bookName: book.name),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
