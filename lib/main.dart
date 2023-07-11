import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fractal_flutter/fractal_flutter.dart';

import 'app.dart';
import 'models/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Oo8Fractal.initiate();
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  static Oo8Fractal app = Oo8Fractal();
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(context) {
    return MaterialApp(
      title: 'Find8',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
        colorScheme: const ColorScheme.dark(),
        canvasColor: Colors.grey.shade900.withOpacity(0.8),
        fontFamily: 'RobotoMono',
      ),

      //make text white

      themeMode: ThemeMode.dark,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FChangeNotifierProvider.value(
        value: app,
        builder: (ctx, child) => Oo8App(),
      ),
      // home: Listen<Oo8Fractal>(
      //   app,
      //   (ctx, child) => Oo8App(),
      // ),
    );
  }
}
