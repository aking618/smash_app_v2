import 'package:flutter/material.dart';
import 'package:smash_app/constants/theme.dart';
import 'package:smash_app/pages/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool debugMode = true;
  if (debugMode) Paint.enableDithering = true;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smash App',
      theme: appTheme(context),
      home: Home(),
    );
  }
}
