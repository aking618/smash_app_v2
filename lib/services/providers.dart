import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

final dbProvider = Provider<Database>((ref) {
  throw Exception('Database not initialized');
});

final clientProvider = Provider<ValueNotifier<GraphQLClient>>((ref) {
  throw Exception('Client not initialized');
});

final sharedPrefsProvider = Provider<SharedPreferences>((ref) {
  throw Exception('SharedPrefs not initialized');
});

// final userProvider = Provider<>((ref) {
//   throw Exception('User not initialized');
// });
