import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/ChunkModel.dart';
import 'package:flutter_application_2/models/settings_model.dart';
import 'package:flutter_application_2/pages/pdf_screen/pdf_screen.dart';
import 'package:flutter_application_2/services/book_service.dart';
import 'package:provider/provider.dart';

class ReadingPage2 extends StatefulWidget {
  const ReadingPage2(
      {super.key, required this.title, this.pdfBytes, this.dontShowPdf});

  final String title;
  final List<int>? pdfBytes;
  final bool? dontShowPdf;
  @override
  State<ReadingPage2> createState() => _ReadingPage2State();
}

class _ReadingPage2State extends State<ReadingPage2> {
  int _counter = 0;
  String currentWord = "";
  Timer? _timer;
  bool _isRunning = false;
  bool _dontShowImage = true;
  int currentPosition = 0;
  String bookId = "";

  //int _milisec = 200;
  @override
  void initState() {
    super.initState();
    //_startReading(context);
  }

  void _stopReading(BuildContext context) {
    setState(() {
      _timer?.cancel();
      _isRunning = false;
    });
  }

  void _startReading(BuildContext context) {
    final chunkModel = context.read<ChunkModel>();
    final settingsModel = context.read<SettingsModel>();
    currentPosition = chunkModel.currentPosition;
    setState(() {
      bookId = chunkModel.bookId;
    });
    double wordsPerMinute = settingsModel.getCurrentSliderValue;
    double asMilisecond = ((60 / wordsPerMinute) * 1000);
    int asMillisecondsRounded = asMilisecond.round();
    List<String> words = chunkModel.getText.split(' ');

    _timer =
        Timer.periodic(Duration(milliseconds: asMillisecondsRounded), (timer) {
      setState(() {
        if (_counter >= words.length) {
          _dontShowImage = false;
          _counter = 0;
          currentWord = "";
          _stopReading(context);
          chunkModel.changeText();
        } else {
          _isRunning = true;
          currentWord = words[_counter];
          _counter++;
        }
      });
    });
  }

  Future<void> _updateBookProperties() async {
    // For now it is just 0 for simplicity
    int wordIndex = 0;
    await BookService.updateBookProperties(bookId, currentPosition, wordIndex);
  }

  @override
  void dispose() {
    _timer?.cancel();
    if (bookId != "-1") {
      _updateBookProperties();
    }
    super.dispose();
  }

  void dontShowImage(BuildContext context) {
    setState(() {
      _dontShowImage = !_dontShowImage;
      _isRunning = !_isRunning;
      _startReading(context);
    });
  }

  Widget _buildRichText(String word, BuildContext context) {
    if (word.isEmpty) return Container();

    // Determine the center index
    int centerIndex = (word.length / 2).floor();

    // Split the word into three parts
    String beforeCenter = word.substring(0, centerIndex);
    String centerLetter = word[centerIndex];
    String afterCenter = word.substring(centerIndex + 1);

    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.displayMedium,
        children: [
          TextSpan(text: beforeCenter),
          TextSpan(
              text: centerLetter, style: const TextStyle(color: Colors.red)),
          TextSpan(text: afterCenter),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text(widget.title,
            style: Theme.of(context).textTheme.displayMedium),
      ),
      body: (_dontShowImage)
          ? Stack(
              children: [
                if (widget.dontShowPdf != true)
                  Positioned(
                    top: 20.0,
                    right: 10.0,
                    child: SizedBox(
                      width: 50.0,
                      height: 50.0,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PDFScreen(pdfBytes: widget.pdfBytes!),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20.0), // Set border radius
                          ),
                        ),
                        child: const Center(
                          child: Icon(Icons.menu_book_sharp),
                        ),
                      ),
                    ),
                  ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildRichText(currentWord, context),
                    ],
                  ),
                ),
              ],
            )
          : Stack(
              children: [
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 18.0, right: 18.0, bottom: 185.0),
                    child: context.read<ChunkModel>().getImage,
                  ),
                ),
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      dontShowImage(context);
                    },
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 80.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    color: Colors.white.withOpacity(0.3),
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      context.read<ChunkModel>().getSummarizedText!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ],
            ),

      floatingActionButton: _dontShowImage
          ? FloatingActionButton(
              onPressed: () {
                _isRunning ? _stopReading(context) : _startReading(context);
              },
              tooltip: 'Start/Pause',
              child: _isRunning
                  ? const Icon(Icons.pause)
                  : const Icon(Icons.play_arrow),
            )
          : null,
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
