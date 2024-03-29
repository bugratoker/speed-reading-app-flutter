import 'package:flutter/material.dart';

class SingleSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const SingleSection({
    Key? key,
    required this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title.toUpperCase(),
            style: Theme.of(context)
                .textTheme
                .displayMedium
                ?.copyWith(fontSize: 25),
          ),
        ),
        Container(
          width: double.infinity,
          color: Colors.white24,
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}
