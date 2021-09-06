import 'dart:convert';

class Tournament {
  final int id;
  final String tournamentName;
  final List<int> setLengths;
  final Map<String, List<String>> legalStages;
  final int stockCount;
  final int timeInMinutes;
  final Map<String, dynamic> additionalRules;

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
      id: map['id'],
      tournamentName: map['tournamentName'],
      setLengths: jsonDecode(map['setLengths']),
      legalStages: jsonDecode(map['legalStages']),
      stockCount: map['stockCount'],
      timeInMinutes: map['timeInMinutes'],
      additionalRules: jsonDecode(map['additionalRules']),
    );
  }

  static List<Tournament> fromMapList(List<Map<String, dynamic>> mapList) {
    if (mapList == []) return [];
    return List<Tournament>.from(mapList.map((map) => Tournament.fromMap(map)));
  }
}
