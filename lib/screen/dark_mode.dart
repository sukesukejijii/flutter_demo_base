import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';

class DarkMode extends ConsumerWidget {
  const DarkMode();

  @override
  Widget build(BuildContext context, watch) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (event) {
        if (event.isKeyPressed(LogicalKeyboardKey.space))
          context.read(isDark).state = !context.read(isDark).state;
      },
      child: Center(
        child: Container(
          width: 450,
          child: CheckboxListTile(
            value: watch(isDark).state,
            onChanged: (value) => context.read(isDark).state = value,
            autofocus: true,
            title: Text('Apply Dark Mode to Entire App'),
            selected: true,
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: Colors.pink,
          ),
        ),
      ),
    );
  }
}
