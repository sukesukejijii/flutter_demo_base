import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one_hour/icons.dart';

final rainProvider =
    StateProvider.autoDispose<List<SlideTransition>>((ref) => []);

class Rain extends StatefulWidget {
  const Rain();

  @override
  _RainState createState() => _RainState();
}

class _RainState extends State<Rain> with TickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3000),
    );
  }

  @override
  void dispose() {
    //controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<SlideTransition> createRaindrops() {
      final random = Random();

      return List.generate(
        1 + random.nextInt(100),
        (index) {
          final double xBegin = (3 + random.nextInt(75)).toDouble();
          final double xEnd = (xBegin + (random.nextInt(6) - 3)).toDouble();
          final double opacity = random.nextDouble();
          final double size = 12 + (24 * opacity);
          final double yBegin = -((1 - opacity) * 10);

          controller.reset();

          return SlideTransition(
            position: Tween<Offset>(
              begin: Offset(xBegin, yBegin),
              end: Offset(xEnd, 96),
            ).animate(
              CurvedAnimation(parent: controller, curve: Curves.easeInCubic),
            ),
            child: Icon(
              Custom.raindrop,
              color: Colors.lightBlueAccent.withOpacity(opacity),
              size: size,
            ),
          );
        },
      );
    }

    // final future = Future.delayed(Duration(milliseconds: 300), () {
    //   return createRaindrops(10);
    // });

    return Consumer(
      builder: (context, watch, child) => Stack(
        children: [
          Center(
            child: TextButton(
              child: Text(
                'PRESS FOR RAIN',
                style: Theme.of(context).textTheme.headline2,
              ),
              onPressed: () {
                context.read(rainProvider).state = createRaindrops();
                controller.forward();
              },
            ),
          ),
          ...watch(rainProvider).state,
        ],
      ),
    );
  }
}
