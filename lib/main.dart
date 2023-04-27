import 'package:drugstore/database/drug_manager.dart';
import 'package:drugstore/views/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';

import 'database/media_manager.dart';
import 'database/mocks/drug_mocks.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // debugPaintSizeEnabled = true;
  // debugPaintPointersEnabled = true;
  setWindowMinSize(const Size(800, 600));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    DrugManager.init();
    MediaManager.init();
    return MaterialApp(
      title: 'Drug store',
      theme: ThemeData(
        primarySwatch: const MaterialColor(
          0xFF3F51B5,
          <int, Color>{
            50: Color(0xFFE8EAF6),
            100: Color(0xFFC5CAE9),
            200: Color(0xFF9FA8DA),
            300: Color(0xFF7986CB),
            400: Color(0xFF5C6BC0),
            500: Color(0xFF3F51B5),
            600: Color(0xFF3949AB),
            700: Color(0xFF303F9F),
            800: Color(0xFF283593),
            900: Color(0xFF1A237E),
          },
        ),
        // hide app bar
        appBarTheme: const AppBarTheme(
          elevation: 0.0,
        ),
        // primaryColor: const Color(0xFF000000),
        // primaryColorDark: const Color(0xFF000000),
        // primaryColorLight: const Color(0xFF000000),
        // accentColor: const Color(0xFF000000),
        // backgroundColor: const Color(0xFF000000),
        // scaffoldBackgroundColor: const Color(0xFF000000),
      ),
      home: HomePage(title: 'Dorivor o\'simliklar'),
    );
  }
}
