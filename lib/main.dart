import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smash_app/constants/theme.dart';
import 'package:smash_app/pages/home.dart';
import 'package:smash_app/services/db.dart';
import 'package:sqflite/sqflite.dart';

final dbProvider = Provider<Database>((ref) {
  throw Exception('Database not initialized');
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool debugMode = true;
  if (debugMode) Paint.enableDithering = true;

  runApp(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    ),
  );

  final database = await SmashAppDatabase().intializedDB();

  runApp(
    ProviderScope(
      child: MyApp(),
      overrides: [
        dbProvider.overrideWithValue(database),
      ],
    ),
  );
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
