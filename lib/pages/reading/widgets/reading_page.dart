import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/pdf_screen/pdf_screen.dart';

class ReadingPage extends StatefulWidget {
  const ReadingPage({super.key, required this.title, required this.text});

  final String title;
  final List<String> text;

  @override
  State<ReadingPage> createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  int _counter = 0;
  String currentWord = "";
  Timer? _timer;
  bool _isRunning = false;

  void _startReading() {
    setState(() {
      if (_isRunning) {
        // if it runs (True) and you press stop
        _timer?.cancel();
        _isRunning = false;
      } else {
        _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
          setState(() {
            if (_counter >= widget.text.length) {
              _counter = 0;
            }
            currentWord = widget.text[_counter];
            _counter++;
          });
        });
        _isRunning = true;
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Text(currentWord,
                    style: Theme.of(context).textTheme.displayMedium)
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startReading,
        tooltip: 'Start/Pause',
        child:
            _isRunning ? const Icon(Icons.pause) : const Icon(Icons.play_arrow),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
