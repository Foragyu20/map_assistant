import 'package:flutter/material.dart';
import 'TFLiteCameraPage.dart';

/*
Author: Christian Forest M. Raguini
Description: I made this app experimentally it may have some bugs and may not be stable on other devices and is also hardware dependent.
*/
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
// defining border radius
  BorderRadius radius = const BorderRadius.only(
    topLeft: Radius.circular(24),
    topRight: Radius.circular(24),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // MaterialApp
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      debugShowCheckedModeBanner: false,
      home: const Scaffold(body: TFLiteCameraPage()),
    );
  }
}
