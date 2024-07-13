import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/book_model.dart';
import 'package:flutter_application_2/pages/saved_books/views/book_details_page.dart';
import 'package:flutter_application_2/services/book_service.dart';
import 'package:flutter_application_2/utils/helper_widgets.dart';

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
  bool deletedBook = false;

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
        title: const Text('Imported Books'),
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
          color: const Color.fromARGB(255, 192, 210, 236).withOpacity(1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Set the border radius
            side: const BorderSide(
                color: Color.fromARGB(255, 255, 255, 255),
                width: 2), // Define the border style
          ),
          child: ListTile(
            title:
                Text(book.name, style: Theme.of(context).textTheme.bodyMedium),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(progressText,
                    style: Theme.of(context).textTheme.bodySmall),
                IconButton(
                  icon: const Icon(Icons.delete,
                      color: Colors.red, size: 23), // Red delete button
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, book);
                  },
                ),
              ],
            ),
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

  void _showDeleteConfirmationDialog(BuildContext context, Book book) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Delete Book',
            style: TextStyle(color: Colors.red),
          ),
          content: Text(
            'Are you sure you want to delete "${book.name}"?',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                // Call the endpoint to delete the book
                _deleteBook(context, book);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteBook(BuildContext context, Book book) async {
    // Implement your delete functionality here
    print("Deleting book: ${book.name}");
    bool result = await BookService.deleteBookById(book.id);
    if (result) {
      if (mounted) {
        setState(() {
          allBooks.remove(book);
          deletedBook = true;
        });
      }
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    print("sNack bar");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(
            top: 10.0, left: 10.0, right: 10.0, bottom: 20.0),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
