import 'package:path/path.dart';
import 'package:smash_app/models/player_record.dart';
import 'package:smash_app/models/rcg_character.dart';
import 'package:smash_app/models/rsg_stage.dart';
import 'package:smash_app/models/tournament.dart';
import 'package:sqflite/sqflite.dart';

class SmashAppDatabase {
  intializedDB() async {
    print('initializing database');
    return openDatabase(
      join(await getDatabasesPath(), 'smash_app.db'),
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE rcg_character(
          id integer primary key autoincrement,
          displayName text not null,
          filePath text not null
        )
        ''');
        await db.execute('''
        CREATE TABLE rsg_stage(
          id integer primary key autoincrement,
          stageName text not null,
          filePath text not null
        )
        ''');
        await db.execute('''
        CREATE TABLE tournament(
          id integer primary key autoincrement,
          tournamentName text not null,
          setLengths text not null,
          legalStages text not null,
          stockCount integer not null,
          timeInMinutes integer not null
        )
        ''');
        await db.execute('''
        CREATE TABLE player_record(
          id integer primary key autoincrement,
          playerTag text not null,
          characters text not null,
          notes text not null,
          wins integer not null,
          losses integer not null
        )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute('''
        DROP TABLE IF EXISTS rcg_character
        ''');
        await db.execute('''
        DROP TABLE IF EXISTS rsg_stage
        ''');
        await db.execute('''
        DROP TABLE IF EXISTS tournament
        ''');
        await db.execute('''
        DROP TABLE IF EXISTS player_record
        ''');
        await db.execute('''
        CREATE TABLE rcg_character(
          id integer primary key autoincrement,
          displayName text not null,
          filePath text not null
        )
        ''');
        await db.execute('''
        CREATE TABLE rsg_stage(
          id integer primary key autoincrement,
          stageName text not null,
          filePath text not null
        )
        ''');
        await db.execute('''
        CREATE TABLE tournament(
          id integer primary key autoincrement,
          tournamentName text not null,
          setLengths text not null,
          legalStages text not null,
          stockCount integer not null,
          timeInMinutes integer not null
        )
        ''');
        await db.execute('''
        CREATE TABLE player_record(
          id integer primary key autoincrement,
          playerTag text not null,
          characters text not null,
          notes text not null,
          wins integer not null,
          losses integer not null
        )
        ''');
      },
      version: 5,
    );
  }

  /// RCG Character

  Future<void> insertRCGCharacterList(
      Database db, List<RCGCharacter> rcgCharacterList) async {
    for (RCGCharacter rcgCharacter in rcgCharacterList) {
      await db.insert(
        'rcg_character',
        rcgCharacter.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    print('inserted rcg character list');
  }

  Future<List<RCGCharacter>> getRCGCharacterList(Database db) async {
    final List<Map<String, dynamic>> maps = await db.query('rcg_character');
    return RCGCharacter.fromMapList(maps);
  }

  Future<void> updateRCGCharacterList(
      Database db, List<RCGCharacter> rcgCharacterList) async {
    for (RCGCharacter rcgCharacter in rcgCharacterList) {
      await db.update(
        'rcg_character',
        rcgCharacter.toMap(),
        where: 'id = ?',
        whereArgs: [rcgCharacter.id],
      );
    }
  }

  Future<void> deleteRCGCharacterList(Database db) async {
    await db.delete('rcg_character');
  }

  Future<void> deleteRCGCharacter(Database db, int id) async {
    await db.delete(
      'rcg_character',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Tournament

  Future<void> insertTournament(Database db, Tournament tournament) async {
    await db.insert(
      'tournament',
      tournament.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('inserted tournament');
  }

  Future<List<Tournament>> getTournamentList(Database db) async {
    final List<Map<String, dynamic>> maps = await db.query('tournament');
    return Tournament.fromMapList(maps);
  }

  Future<void> updateTournament(Database db, Tournament tournament) async {
    await db.update(
      'tournament',
      tournament.toMap(),
      where: 'id = ?',
      whereArgs: [tournament.id],
    );
  }

  Future<void> deleteTournament(Database db, int id) async {
    await db.delete(
      'tournament',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// RSG Stage

  Future<void> insertRSGStageList(
      Database db, List<RSGStage> rsgStageList) async {
    for (RSGStage rsgStage in rsgStageList) {
      await db.insert(
        'rsg_stage',
        rsgStage.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    print('inserted rsg stage list');
  }

  Future<List<RSGStage>> getRSGStageList(Database db) async {
    final List<Map<String, dynamic>> maps = await db.query('rsg_stage');
    return RSGStage.fromMapList(maps);
  }

  Future<void> updateRSGStageList(
      Database db, List<RSGStage> rsgStageList) async {
    for (RSGStage rsgStage in rsgStageList) {
      await db.update(
        'rsg_stage',
        rsgStage.toMap(),
        where: 'id = ?',
        whereArgs: [rsgStage.id],
      );
    }
  }

  Future<void> deleteRSGStageList(Database db) async {
    await db.delete('rsg_stage');
  }

  Future<void> deleteRSGStage(Database db, int id) async {
    await db.delete(
      'rsg_stage',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Player Record

  Future<void> insertPlayerRecord(
      Database db, PlayerRecord playerRecord) async {
    await db.insert(
      'player_record',
      playerRecord.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('inserted player record');
  }

  Future<List<PlayerRecord>> getPlayerRecordList(Database db) async {
    final List<Map<String, dynamic>> maps = await db.query('player_record');
    return PlayerRecord.fromMapList(maps);
  }

  Future<void> updatePlayerRecord(
      Database db, PlayerRecord playerRecord) async {
    await db.update(
      'player_record',
      playerRecord.toMap(),
      where: 'id = ?',
      whereArgs: [playerRecord.id],
    );
  }

  Future<void> deletePlayerRecord(Database db, int id) async {
    await db.delete(
      'player_record',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
