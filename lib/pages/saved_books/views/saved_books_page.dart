import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/book_model.dart';
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
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
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
        return Card(
          child: ListTile(
            title: Text(book.name),
            onTap: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => BookDetailsPage(bookId: book.id),
              //   ),
              // );
            },
          ),
        );
      },
    );
  }
}
