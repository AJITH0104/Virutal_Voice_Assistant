import 'package:flutter/material.dart';

import 'homepg.dart';
import 'palette.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI',
      theme: ThemeData.light(useMaterial3: true).copyWith(
          scaffoldBackgroundColor: pallete.whiteColor,
          appBarTheme: const AppBarTheme(backgroundColor: pallete.whiteColor)),
      home: const homepg(),
    );
  }
}
