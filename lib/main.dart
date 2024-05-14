import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pulsefeed/screens/Splashscreen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    // Make the status bar transparent
    statusBarColor: Colors.transparent,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'PulseFeed',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Splashscreen(),
        debugShowCheckedModeBanner: false);
  }
}
