import 'dart:convert';

class Tournament {
  final int id;
  final String tournamentName;
  final List<String> setLengths;
  final Map<String, dynamic> legalStages;
  final int stockCount;
  final int timeInMinutes;
  final List<String> additionalRules;

  Tournament({
    required this.id,
    required this.tournamentName,
    required this.setLengths,
    required this.legalStages,
    required this.stockCount,
    required this.timeInMinutes,
    required this.additionalRules,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tournamentName': tournamentName,
      'setLengths': jsonEncode(setLengths),
      'legalStages': jsonEncode(legalStages),
      'stockCount': stockCount,
      'timeInMinutes': timeInMinutes,
      'additionalRules': jsonEncode(additionalRules),
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
      additionalRules: map['additionalRules'],
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
      additionalRules: jsonDecode(map['additionalRules']).cast<String>(),
    );
  }

  static List<Tournament> fromMapList(List<Map<String, dynamic>> mapList) {
    if (mapList == []) return [];
    return List<Tournament>.from(
        mapList.map((map) => Tournament.fromSqlflite(map)));
  }

  @override
  String toString() {
    return 'Tournament{id: $id, tournamentName: $tournamentName, setLengths: $setLengths, legalStages: $legalStages, stockCount: $stockCount, timeInMinutes: $timeInMinutes, additionalRules: $additionalRules}';
  }
}
