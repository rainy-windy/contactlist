import 'dart:io';

import 'package:flutter/material.dart';

class SliverBar extends StatelessWidget {
  const SliverBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: false,
      snap: false,
      floating: false,
      collapsedHeight: 60,
      backgroundColor: Theme.of(context).primaryColor,
      shadowColor: Theme.of(context).primaryColorDark,
      automaticallyImplyLeading: false,
      elevation: 8.0,
      forceElevated: true,
      actions: Platform.isIOS
          ? [
              IconButton(
                  onPressed: () => Navigator.of(context).pushNamed('/edit', arguments: null),
                  icon: const Icon(
                    Icons.add,
                    color: Colors.black,
                  ))
            ]
          : [],
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Stack(
          fit: StackFit.loose,
          children: <Widget>[
            RichText(
              text: TextSpan(
                text: 'Contact ',
                style: TextStyle(
                  fontSize: 24,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 5
                    ..color = Theme.of(context).primaryColorDark,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: ' List',
                    style: TextStyle(
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 5
                        ..color = Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                text: 'Contact  List',
                style: TextStyle(
                  fontSize: 24,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
