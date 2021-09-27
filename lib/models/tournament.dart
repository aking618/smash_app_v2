import 'dart:convert';

class Tournament {
  final int id;
  final String tournamentName;
  final List<String> setLengths;
  final Map<String, dynamic> legalStages;
  final int stockCount;
  final int timeInMinutes;

  Tournament({
    required this.id,
    required this.tournamentName,
    required this.setLengths,
    required this.legalStages,
    required this.stockCount,
    required this.timeInMinutes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tournamentName': tournamentName,
      'setLengths': jsonEncode(setLengths),
      'legalStages': jsonEncode(legalStages),
      'stockCount': stockCount,
      'timeInMinutes': timeInMinutes,
    };
  }

  static Tournament fromMap(Map<String, dynamic> map) {
    return Tournament(
      id: map['id'] as int,
      tournamentName: map['tournamentName'],
      setLengths: map['setLengths'],
      legalStages: map['legalStages'],
      stockCount: map['stockCount'],
      timeInMinutes: map['timeInMinutes'],
    );
  }

  static Tournament fromSqlflite(Map<String, dynamic> map) {
    return Tournament(
      id: map['id'] as int,
      tournamentName: map['tournamentName'],
      setLengths: jsonDecode(map['setLengths']).cast<String>(),
      legalStages: jsonDecode(map['legalStages']).cast<String, dynamic>(),
      stockCount: map['stockCount'],
      timeInMinutes: map['timeInMinutes'],
    );
  }

  static List<Tournament> fromMapList(List<Map<String, dynamic>> mapList) {
    if (mapList == []) return [];
    return List<Tournament>.from(
        mapList.map((map) => Tournament.fromSqlflite(map)));
  }

  @override
  String toString() {
    return 'Tournament{id: $id, tournamentName: $tournamentName, setLengths: $setLengths, legalStages: $legalStages, stockCount: $stockCount, timeInMinutes: $timeInMinutes}';
  }
}
