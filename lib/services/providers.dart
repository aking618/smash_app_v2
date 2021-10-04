import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smash_app/models/user.dart';
import 'package:sqflite/sqflite.dart';

final dbProvider = Provider<Database>((ref) {
  throw Exception('Database not initialized');
});

final sharedPrefsProvider = Provider<SharedPreferences>((ref) {
  throw Exception('SharedPrefs not initialized');
});

final userProvider = StateProvider<User?>((ref) {
  return null;
});
