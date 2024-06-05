import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/ChunkModel.dart';
import 'package:flutter_application_2/models/settings_model.dart';
import 'package:flutter_application_2/pages/pdf_screen/pdf_screen.dart';
import 'package:flutter_application_2/services/book_service.dart';
import 'package:provider/provider.dart';

class ReadingPage2 extends StatefulWidget {
  const ReadingPage2({super.key, required this.title});

  final String title;
  @override
  State<ReadingPage2> createState() => _ReadingPage2State();
}

class _ReadingPage2State extends State<ReadingPage2> {
  int _counter = 0;
  String currentWord = "";
  Timer? _timer;
  bool _isRunning = false;
  bool _dontShowImage = true;
  int currentPosition=0;
  String bookId ="";
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
    bookId = chunkModel.bookId;
    double wordsPerMinute = settingsModel.getCurrentSliderValue;
    print("word per min:+${wordsPerMinute}");
    double asMilisecond = ((60 / wordsPerMinute) * 1000);
    int asMillisecondsRounded = asMilisecond.round();

    List<String> words = chunkModel.getText.split(' ');
    print("Milisecond:+${asMillisecondsRounded}");

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
    _updateBookProperties();
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
    return (_dontShowImage)
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              title: Text(widget.title,
                  style: Theme.of(context).textTheme.displayMedium),
              actions: [Switch(value: false, onChanged: (newValue) {})],
            ),

            body: Stack(
              children: [
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
                                const PDFScreen(path: 'assets/sample.pdf'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          // Set square shape
                          borderRadius: BorderRadius.circular(
                              20.0), // Set border radius to 0 for square shape
                        ), // Remove padding
                      ),
                      child: const Center(
                        // Center the Icon within the SizedBox
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
            ),

            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _isRunning ? _stopReading(context) : _startReading(context);
              },
              tooltip: 'Start/Pause',
              child: _isRunning
                  ? const Icon(Icons.pause)
                  : const Icon(Icons.play_arrow),
            ),
            // This trailing comma makes auto-formatting nicer for build methods.
          )
        : GestureDetector(
            onTap: () {
              dontShowImage(context);
            },
            child: context.read<ChunkModel>().getImage,
          );
  }
}
