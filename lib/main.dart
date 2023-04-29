///import 'dart:io';
//import 'package:sqlite3/open.dart';

import 'package:data8/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'models/app.dart';
import 'services/logger.dart';

void main() {
  runApp(
    ProviderScope(
      observers: [Logger()],
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  // This widget is the root of your application.
  @override
  Widget build(ctx, ref) {
    return MaterialApp(
      title: 'Find8',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
        colorScheme: ColorScheme.dark(),
      ),

      //make text white

      themeMode: ThemeMode.dark,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Oo8App(),
    );
  }
}
