import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/book_model.dart';
import 'package:flutter_application_2/pages/saved_books/views/book_details_page.dart';
import 'package:flutter_application_2/services/book_service.dart';

class AllBooksPage extends StatefulWidget {
  const AllBooksPage({super.key});

  @override
  State<AllBooksPage> createState() => _AllBooksPageState();
}

class _AllBooksPageState extends State<AllBooksPage> {
  List<Book> allBooks = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeSavedBooks();
  }

  Future<void> _initializeSavedBooks() async {
    try {
      allBooks = await BookService.getAllBooksByUserId("8a0f98f3-d545-4879-b40a-461eec711957");
      // Mock data setup or service call
    } catch (e) {
      errorMessage = 'Failed to load books';
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Books'),
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

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Two items per row
        childAspectRatio: 1.0, // Makes each item square
      ),
      itemCount: allBooks.length,
      itemBuilder: (context, index) {
        final book = allBooks[index];
        final double progress = (book.currentChunkIndex / book.totalChunkCount) * 100;
        final String progressText = "${progress.toStringAsFixed(0)}%";

        return Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Ink.image(
                image: AssetImage('assets/images/${book.id}.jpg'), // Adjust this line
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
              Container(
                color: Colors.black.withOpacity(0.5),
                child: ListTile(
                  title: Text(book.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text(progressText, style: const TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BookDetailsPage(bookId: book.id, bookName: book.name),
                    ));
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
