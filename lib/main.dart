import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smash_app/constants/theme.dart';
import 'package:smash_app/models/user.dart';
import 'package:smash_app/pages/home.dart';
import 'package:smash_app/pages/login.dart';
import 'package:smash_app/services/db.dart';
import 'package:smash_app/services/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool debugMode = true;
  if (debugMode) Paint.enableDithering = true;

  final database = await SmashAppDatabase().intializedDB();
  final sharedPrefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      child: MyApp(),
      overrides: [
        dbProvider.overrideWithValue(database),
        sharedPrefsProvider.overrideWithValue(sharedPrefs),
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
      home: Login(),
    );
  }
}
