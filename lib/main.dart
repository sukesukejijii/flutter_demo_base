import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screen/home.dart';

void main() {
  runApp(ProviderScope(child: App()));
}

final isDark = StateProvider.autoDispose<bool>((ref) => false);

class App extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        primaryColor: Colors.pink,
        accentColor: Colors.indigo,
        brightness: watch(isDark).state ? Brightness.dark : Brightness.light,
      ),
      home: Home(),
    );
  }
}
