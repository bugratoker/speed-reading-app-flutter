import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/ChunkModel.dart';
import 'package:flutter_application_2/pages/pdf_screen/pdf_screen.dart';
import 'package:provider/provider.dart';

class ReadingPage extends StatefulWidget {
  const ReadingPage({super.key, required this.title});

  final String title;

  @override
  State<ReadingPage> createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  int _counter = 0;
  String currentWord = "";
  Timer? _timer;
  bool _isRunning = false;
  bool _dontShowImage = true;
  @override
  void initState() {
    super.initState();
    _startReading(context);
  }
  void _startReading(BuildContext context) {
    setState(() {
      final chunkModel = context.read<ChunkModel>();
      List<String> words = chunkModel.getText.split(' ');
      print(words);
      if (_isRunning) {
        // if it runs (True) and you press stop
        _timer?.cancel();
        _isRunning = false;
      } 
      else {
        _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
          
          setState(() {
            if (_counter >= words.length) {
              _counter = 0;
              chunkModel.changeText();
              _dontShowImage = false;
              _isRunning=!_isRunning;
              //_startReading(context);
            }

            currentWord = words[_counter];
            _counter++;
          });
        });
        //_isRunning = true;
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
    return _dontShowImage ? Scaffold(
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
                          style: Theme.of(context).textTheme.displayMedium),
                    ],
                  ),
                ),
              ],
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _startReading(context);
        },
        tooltip: 'Start/Pause',
        child:
            _isRunning ? const Icon(Icons.pause) : const Icon(Icons.play_arrow),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    ) 
             :  GestureDetector(
              onTap: () {
                dontShowImage();
              },
              child: Image.network('https://picsum.photos/250?image=9'),
            )
    
    ;
  }
  
  void dontShowImage() {

    setState(() {
      _dontShowImage = !_dontShowImage;
      _isRunning =!_isRunning;
    });
  }
}
