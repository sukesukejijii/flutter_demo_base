import 'package:flutter/material.dart';

class Adaptive extends StatelessWidget {
  const Adaptive();

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return Center(
      child: Container(
        width: 450,
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resize this window to show/hide sidebar.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Text('Window height:'),
                Spacer(),
                Text(
                  '${media.size.height.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text('Window width:'),
                Spacer(),
                Text(
                  '${media.size.width.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text('Window orientation:'),
                Spacer(),
                Text(
                  '${media.orientation.toString()}',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text('OS brightness setting:'),
                Spacer(),
                Text(
                  '${media.platformBrightness.toString()}',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
