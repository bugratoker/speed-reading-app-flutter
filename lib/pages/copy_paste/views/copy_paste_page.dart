import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/ChunkModel.dart';
import 'package:flutter_application_2/pages/reading/widgets/reading_page2.dart';
import 'package:provider/provider.dart';

class CopyPastePage extends StatefulWidget {
  const CopyPastePage({super.key});

  @override
  State<CopyPastePage> createState() => _CopyPastePageState();
}

class _CopyPastePageState extends State<CopyPastePage> {
  final TextEditingController textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Copy Paste'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(
                  FocusNode()); // Unfocus text field when tapping outside
              print("unfocussss");
            },
            child: Container(
              color: Colors
                  .transparent, // Ensures the GestureDetector captures taps
            ),
          ),
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height /
                    3, // 1/3 of the screen height
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  focusNode: focusNode,
                  controller: textEditingController,
                  keyboardType: TextInputType.multiline,
                  maxLines:
                      null, // Allows the TextField to grow vertically inside the container
                  expands: true, // Ensures the TextField fills the Container
                  decoration: InputDecoration(
                    hintText: 'Paste your text here',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[
                        200], // Light gray color for the text field background
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width -
                      40, // Adjust width to consider padding
                  child: ElevatedButton(
                    onPressed: () {
                      // Unfocus the text field
                      FocusScope.of(context).unfocus();

                      // Split text into words and filter out empty entries
                      List<String> words =
                          textEditingController.text.split(RegExp(r'\s+'));
                      words.removeWhere((word) => word.isEmpty);
                      ChunkModel chunkModel = ChunkModel(
                          allPdfText: words, currentPosition: 0, bookId: "-1");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ChangeNotifierProvider<ChunkModel>(
                                  create: (_) => chunkModel,
                                  child:
                                      const ReadingPage2(title: "Speed Reader",dontShowPdf: true),
                                )),
                      );
                      print('Text: ${textEditingController.text}');
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
