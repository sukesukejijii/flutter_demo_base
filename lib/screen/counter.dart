import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO: maybe particles

final fontSize = StateProvider.autoDispose<double>((ref) => 24);
final fontOpacity = StateProvider.autoDispose<double>((ref) => 1.0);
final fontColor = StateProvider.autoDispose<int>((ref) => 0);

class Counter extends ConsumerWidget {
  const Counter();

  static const List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.orange,
  ];

  @override
  Widget build(BuildContext context, watch) {
    final double size = watch(fontSize).state;
    final Color color = colors[watch(fontColor).state];

    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment(0, -0.3),
            child: Text(
              'This number represents the font size. The more you click, the more it grows.',
              style: TextStyle(color: color),
            ),
          ),
          Center(
            child: AnimatedDefaultTextStyle(
              child: Text(
                size.toStringAsFixed(0),
                overflow: TextOverflow.fade,
                softWrap: false,
              ),
              style: TextStyle(
                fontSize: size,
                color: color.withOpacity(watch(fontOpacity).state),
              ),
              duration: Duration(milliseconds: 300),
              curve: Curves.bounceOut,
              onEnd: () {
                context.read(fontSize).state = 24;
                context.read(fontOpacity).state = 1;
              },
            ),
          ),
          Align(
            alignment: Alignment(0, 0.5),
            child: IconButton(
              tooltip: 'Press Me',
              icon: Icon(Icons.arrow_upward_rounded),
              color: color,
              iconSize: 60,
              onPressed: () {
                final random = Random();
                final randomFontSize = 45 + random.nextInt(90);
                final radomOpacity = 0.6 * random.nextDouble();
                final randomColor = random.nextInt(5);
                context.read(fontSize).state += randomFontSize;
                context.read(fontOpacity).state =
                    (context.read(fontOpacity).state - radomOpacity)
                        .clamp(0.0, 1.0);
                context.read(fontColor).state = randomColor;
              },
            ),
          ),
        ],
      ),
    );
  }
}
