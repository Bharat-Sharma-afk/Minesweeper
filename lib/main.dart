import 'package:flutter/material.dart';
import './splashscreen.dart';

void main() {
  runApp(MineApp());
}

class MineApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        home: Material(child: SplashScreen()));
  }
}

//color: Color(0x2C4EA5),