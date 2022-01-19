import 'package:flutter/material.dart';

class Gesture extends StatelessWidget {

  Gesture({required this.caption, required this.colourStart, required this.colourEnd, required this.icon, this.stretch = 64.0, Key? key}) : super(key: key);

  final String caption;
  final Color colourStart;
  final Color colourEnd;
  final Icon icon;
  double stretch;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 250),
      // curve: Curves.fastOutSlowIn,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        height: stretch,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          gradient: LinearGradient(
            colors: [colourStart, colourEnd.withOpacity(0.85)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.05, 1],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,
            Text(caption, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),)
          ],
        )
      );
  }
}