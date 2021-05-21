import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:responsive_builder/responsive_builder.dart';

final pressedProvider = StateProvider.autoDispose<int>((ref) => 1);

class Toast extends ConsumerWidget {
  const Toast();

  @override
  Widget build(BuildContext context, watch) {
    final String now = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final int pressed = watch(pressedProvider).state;
    final SnackBar snackBar = SnackBar(
        margin: EdgeInsets.fromLTRB(
          getValueForScreenType(context: context, desktop: 315, mobile: 15),
          5,
          15,
          10,
        ),
        action: SnackBarAction(
          textColor: Colors.grey,
          label: 'Click to dismiss',
          onPressed: () {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
          },
        ),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        content: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(fontSize: 18, color: Colors.grey),
            text: 'Today is ',
            children: [
              TextSpan(
                text: '$now',
                style:
                    TextStyle(color: Colors.pink, fontWeight: FontWeight.bold),
              ),
              TextSpan(text: ' and you pressed the button '),
              TextSpan(
                text: '$pressed',
                style:
                    TextStyle(color: Colors.pink, fontWeight: FontWeight.bold),
              ),
              TextSpan(text: pressed == 1 ? ' time.' : ' times.'),
            ],
          ),
        ),
        // Text(
        //   'Today is $now and you pressed the button $pressed' +
        //       (pressed == 1 ? ' time.' : ' times.'),
        //   textAlign: TextAlign.center,
        //   style: TextStyle(fontSize: 18),
        // ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ));

    return Center(
      child: ElevatedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          context.read(pressedProvider).state++;
        },
        icon: Icon(Icons.messenger_sharp),
        label: Text('Show Toast'),
        style: ElevatedButton.styleFrom(padding: EdgeInsets.all(15)),
      ),
    );
  }
}
