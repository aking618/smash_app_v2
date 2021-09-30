import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

final dbProvider = Provider<Database>((ref) {
  throw Exception('Database not initialized');
});
