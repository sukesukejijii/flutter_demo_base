import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:url_launcher/url_launcher.dart';

import 'adaptive.dart';
import 'background.dart';
import 'carousel.dart';
import 'counter.dart';
import 'dark_mode.dart';
import 'rain.dart';
import 'popup.dart';
import 'toast.dart';
import 'write_text.dart';

const imageUrl =
    'https://images.unsplash.com/photo-1577071835592-d5d55ffef660?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1950&q=80';

const urls = {
  'Invoice PDF App': 'https://flutter-pdf-invoice.web.app/',
  'Sticky Note App': 'https://flutter-firebase-note-app.web.app/',
  'Simple Todo App': 'https://fir-web-setup-demo.web.app/',
  'Tic Tac Toe': 'https://flutter-tic-tac-toe-6240d.web.app/',
  'Code Wars Solutions (4~6 kyu)':
      'https://github.com/sukesukejijii/codewars_solutions',
};

const projects = {
  '1.DarkMode Toggle': DarkMode(),
  '2.Adaptive': Adaptive(),
  '3.Popup Dialog': Popup(),
  '4.Toast Message': Toast(),
  '5.Font Size Counter': Counter(),
  '6.Type Writer': WriteText(),
  '7.Rain Animation': Rain(),
  '8.Background Changer': Background(),
  '9.Carousel Photo': Carousel(),
  // TODO: 'Movie': Movie(), staggered, incremental search
  // TODO: 'Audio': Audio(),
};

void _launchURL(String url) async {
  await canLaunch(url) ? launch(url) : throw Exception('Could not launch $url');
}

final pageProvider = StateProvider.autoDispose<Widget>((ref) => DarkMode());

class Home extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Demo'),
        automaticallyImplyLeading: getValueForScreenType(
          context: context,
          desktop: false,
          mobile: true,
        ),
        actions: [
          TextButton(
            onPressed: () => _launchURL(
                'https://github.com/sukesukejijii/flutter_demo_base'),
            child: Image.asset('assets/github.png'),
          ),
        ],
      ),
      drawer: CustomDrawer(getDeviceType(size)),
      body: ScreenTypeLayout(
        mobile: watch(pageProvider).state,
        desktop: Row(
          children: [
            CustomDrawer(getDeviceType(size)),
            Expanded(child: watch(pageProvider).state),
          ],
        ),
      ),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  final DeviceScreenType screenType;
  const CustomDrawer(this.screenType);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      child: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: FlutterLogo(style: FlutterLogoStyle.horizontal),
            ),
            Text(
              'Web Apps, etc',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            for (var service in urls.entries)
              ListTile(
                title: Text(service.key),
                trailing: Icon(Icons.link),
                onTap: () {
                  _launchURL(service.value);
                  if (screenType != DeviceScreenType.desktop)
                    Navigator.pop(context);
                },
              ),
            Divider(height: 30),
            Text(
              'Small demos',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            for (var project in projects.entries)
              ListTile(
                title: Text(
                  project.key,
                  textAlign: TextAlign.start,
                  style: TextStyle(letterSpacing: 3),
                ),
                onTap: () {
                  context.read(pageProvider).state = project.value;
                  if (screenType != DeviceScreenType.desktop)
                    Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }
}
