import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

const String initialPhoto =
    'https://images.unsplash.com/photo-1506372023823-741c83b836fe?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&w=1080&q=80';
final String apiKey = DotEnv.env['UNSPLASH_API_KEY'];

final colorProvider = StateProvider.autoDispose<Color>((ref) => Colors.white);
final photoProvider = StateProvider.autoDispose<String>((ref) => initialPhoto);

class Background extends ConsumerWidget {
  const Background();

  @override
  Widget build(BuildContext context, watch) {
    final controller = TextEditingController();

    Future<void> getPhoto(String query) async {
      final Dio dio = Dio();
      final Response response = await dio.get(
          'https://api.unsplash.com/photos/random?client_id=$apiKey&query=$query&orientation=landscape');
      final Map<String, dynamic> data = response.statusCode == 200
          ? response.data
          : throw Exception('Something went wrong');
      final String photo = data['urls']['regular'];
      context.read(photoProvider).state = photo;
    }

    void changeColor() {
      final random = Random();
      final red = random.nextInt(255);
      final green = random.nextInt(255);
      final blue = random.nextInt(255);
      context.read(colorProvider).state = Color.fromRGBO(red, green, blue, 1);
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          watch(photoProvider).state,
          repeat: ImageRepeat.repeat,
          colorBlendMode: BlendMode.colorBurn,
          color: watch(colorProvider).state,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Search by a single word and hit enter.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 6),
            Container(
              width: 400,
              child: TextField(
                controller: controller,
                style: TextStyle(
                  color: Colors.pink.withOpacity(0.9),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 5,
                ),
                textAlign: TextAlign.center,
                autofocus: true,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.6),
                  hintText: 'search',
                  border: InputBorder.none,
                ),
                onSubmitted: (text) async {
                  await getPhoto(text);
                },
              ),
            ),
            SizedBox(height: 18),
            ElevatedButton(
              child: Text('Change Photo'),
              style: ElevatedButton.styleFrom(
                primary: Colors.black.withOpacity(0.5),
              ),
              onPressed: () async {
                final text = controller.text;
                await getPhoto(text);
              },
            ),
            SizedBox(height: 18),
            ElevatedButton(
              child: Text('Change Color'),
              style: ElevatedButton.styleFrom(
                primary: Colors.black.withOpacity(0.5),
              ),
              onPressed: changeColor,
            ),
          ],
        ),
      ],
    );
  }
}
