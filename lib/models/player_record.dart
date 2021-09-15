import 'dart:convert';

import 'package:smash_app/models/rcg_character.dart';

class PlayerRecord {
  final int id;
  final String playerTag;
  final List<RCGCharacter> characters;
  final String notes;
  final int wins;
  final int losses;

  PlayerRecord({
    required this.id,
    required this.playerTag,
    required this.characters,
    required this.notes,
    required this.wins,
    required this.losses,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'playerTag': playerTag,
      'characters': jsonEncode(characters.map((c) => c.toMap()).toList()),
      'notes': notes,
      'wins': wins,
      'losses': losses,
    };
  }

  static PlayerRecord fromMap(Map<String, dynamic> map) {
    return PlayerRecord(
      id: map['id'],
      playerTag: map['playerTag'],
      characters: jsonDecode(map['characters'])
          .map<RCGCharacter>((c) => RCGCharacter.fromMap(c))
          .toList(),
      notes: map['notes'],
      wins: map['wins'],
      losses: map['losses'],
    );
  }

  static List<PlayerRecord> fromMapList(List<dynamic> mapList) {
    if (mapList.isEmpty) return [];
    return List<PlayerRecord>.from(mapList.map((m) => fromMap(m)));
  }

  @override
  String toString() {
    return 'PlayerRecord{id: $id, playerTag: $playerTag, characters: $characters, notes: $notes, wins: $wins, losses: $losses}';
  }
}
