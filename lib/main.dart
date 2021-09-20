import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smash_app/pages/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Paint.enableDithering = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smash App',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        textTheme: GoogleFonts.firaSansTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Home(),
    );
  }
}
