import 'package:flutter/material.dart';

class Gesture extends StatelessWidget {

  const Gesture({required this.caption, required this.colourStart, required this.colourEnd, required this.icon, Key? key}) : super(key: key);

  final String caption;
  final Color colourStart;
  final Color colourEnd;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        height: 64,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          gradient: LinearGradient(
            colors: [
              colourStart,
              colourEnd.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.1, 1],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,
            Text(caption)
          ],
        )
      );
  }
}