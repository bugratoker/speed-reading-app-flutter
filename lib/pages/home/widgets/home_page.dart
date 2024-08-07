import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_2/pages/all_books/views/all_books_page.dart';
import 'package:flutter_application_2/pages/copy_paste/views/copy_paste_page.dart';
import 'package:flutter_application_2/pages/saved_books/views/saved_books_page.dart';
import 'package:flutter_application_2/pages/settings/views/setting_page.dart';
import 'package:flutter_application_2/utils/helper_widgets.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../../../utils/file_reader.dart';

class HomePage extends StatefulWidget {
  final String token;
  const HomePage({super.key, required this.token});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String fullName = "";
  String id = "";
  @override
  void initState() {
    super.initState();
    // Decode the JWT token and extract the full name
    Map<String, dynamic> decodedToken = JwtDecoder.decode(widget.token);
    fullName = decodedToken['fullName'];
    id = decodedToken[
        "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          title: Text("Speed Reader",
              style: Theme.of(context).textTheme.displayMedium),
        ),
        body: SingleChildScrollView(
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              addVerticalSpace(60),
              Text("welcome $fullName !",
                  style: Theme.of(context).textTheme.titleLarge),
              addVerticalSpace(90),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 180,
                    height: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        textStyle: const TextStyle(fontSize: 16),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                      ),
                      onPressed: () =>
                          FileReader.pickPDFAndNavigate(context, id),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.picture_as_pdf,
                            size: 40,
                          ), // Replace with your desired icon
                          addVerticalSpace(10), // Space between icon and text
                          const Text('Import PDF',
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                  addHorizontalSpace(10),
                  addVerticalSpace(10), // Add space between buttons
                  SizedBox(
                    width: 180,
                    height: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SavedBooksPage(id: id),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        textStyle: const TextStyle(fontSize: 16),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.book,
                              size: 40), // Replace with your desired icon
                          addVerticalSpace(10), // Space between icon and text
                          const Text(
                            'Imported Books',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              addHorizontalSpace(10),
              addVerticalSpace(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 180,
                    height: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        textStyle: const TextStyle(fontSize: 16),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CopyPastePage(),
                          ),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.content_copy,
                            size: 40,
                          ), // Replace with your desired icon
                          addVerticalSpace(10), // Space between icon and text
                          const Text('Paste Text',
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                  addHorizontalSpace(10),
                  addVerticalSpace(10), // Add space between buttons
                  SizedBox(
                    width: 180,
                    height: 200,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AllBooksPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        textStyle: const TextStyle(fontSize: 16),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.menu_book_rounded,
                              size: 40), // Replace with your desired icon
                          addVerticalSpace(10), // Space between icon and text
                          const Text('All Books',
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        )),
        floatingActionButton: FloatingActionButton(
          onPressed: () => {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SettingsPage()))
          },
          child: const Icon(Icons.settings),
        ));
  }
}
