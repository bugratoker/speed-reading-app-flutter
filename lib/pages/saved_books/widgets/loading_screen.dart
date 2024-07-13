import 'package:flutter/material.dart';
import 'dart:async';

class PrettyLoadingScreen extends StatefulWidget {
  const PrettyLoadingScreen({super.key});

  @override
  State<PrettyLoadingScreen> createState() => _PrettyLoadingScreenState();
}

class _PrettyLoadingScreenState extends State<PrettyLoadingScreen> {
  late Timer _timer;
  int _index = 0;
  final String _loadingText = "Book is downloading..";

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      setState(() {
        _index = (_index + 1) % (_loadingText.length + 1);
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text("Speed Reader",
            style: Theme.of(context).textTheme.displayMedium),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 5, 138, 246)),
              strokeWidth: 6.0,
            ),
            const SizedBox(height: 20),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Text(
                _loadingText.substring(0, _index),
                key: ValueKey<int>(_index),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
