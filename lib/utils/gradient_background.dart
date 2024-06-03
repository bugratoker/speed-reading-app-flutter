import 'package:flutter/material.dart';


class GradientBackground extends StatelessWidget {
  GradientBackground({
    required this.children,
    super.key,
  });
  static const Color darkBlue = Color.fromARGB(255, 71, 149, 222);
  static const Color darkerBlue = Color.fromARGB(255, 82, 147, 208);
  static const Color darkestBlue = Color.fromARGB(255, 40, 87, 139);

  final List<Color> colors =[
    darkBlue,
    darkerBlue,
    darkestBlue,
  ];
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(gradient: LinearGradient(colors: colors)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...children,
          ],
        ),
      ),
    );
  }
}