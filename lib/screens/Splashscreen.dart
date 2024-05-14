import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pulsefeed/navigation.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNav()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
            child: Text(
      'PulseFeed',
      style: TextStyle(
          color: Colors.black, fontSize: 32, fontWeight: FontWeight.w800),
    )));
  }
}
