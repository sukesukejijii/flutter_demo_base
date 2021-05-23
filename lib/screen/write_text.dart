import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// TODO: user context refresh

class Quote extends StateNotifier<String> {
  Quote() : super('');

  Future<void> getQuote() async {
    final dio = Dio();
    final response =
        await dio.get('https://www.breakingbadapi.com/api/quote/random');

    if (response.statusCode != 200) {
      throw Exception('Connection Failed');
    }

    final data = response.data as List<dynamic>;
    final quote = data.first['quote'] as String;
    state = quote;
  }
}

final quoteProvider = StateNotifierProvider<Quote, String>((ref) => Quote());

final textStreamProvider = StreamProvider.autoDispose<String>((ref) {
  final Stream<String> stream = () async* {
    await ref.read(quoteProvider.notifier).getQuote();
    final text = ref.watch(quoteProvider);

    for (var i = 0; i < text.length; i++) {
      if (i == 0) await Future.delayed(Duration(seconds: 1));

      yield text.substring(0, i + 1);

      await Future.delayed(Duration(milliseconds: 60));

      if (i == text.length - 1) {
        await Future.delayed(Duration(seconds: 1));
        yield '';
        await Future.delayed(Duration(seconds: 1));
        i = 0;
      }
    }
  }();

  return stream;
});

class WriteText extends StatelessWidget {
  const WriteText();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer(
        builder: (context, watch, child) {
          return watch(textStreamProvider).when(
            data: (output) => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 600,
                  padding: EdgeInsets.symmetric(vertical: 90, horizontal: 30),
                  alignment: Alignment.topLeft,
                  child: Text(
                    output,
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
                Spacer(flex: 2),
                TextButton.icon(
                  onPressed: context.read(quoteProvider.notifier).getQuote,
                  icon: Icon(Icons.message),
                  label: Text('Change Quote'),
                ),
                Spacer(flex: 1),
              ],
            ),
            error: (error, stackTrace) => throw error,
            loading: () {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const LinearProgressIndicator(),
                  const SizedBox(height: 30),
                  const Text('Fetching random quote from breakingbadapi.com'),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
