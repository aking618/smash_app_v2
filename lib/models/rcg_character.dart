class RCGCharacter {
  final int id;
  final String displayName;
  final String filePath;

  RCGCharacter({
    required this.id,
    required this.displayName,
    required this.filePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'displayName': displayName,
      'filePath': filePath,
    };
  }

  @override
  String toString() {
    return 'RCGCharacter{id: $id, displayName: $displayName, filePath: $filePath}';
  }

  static RCGCharacter fromMap(Map<String, dynamic> map) {
    return RCGCharacter(
      id: map['id'],
      displayName: map['displayName'],
      filePath: map['filePath'],
    );
  }

  static List<RCGCharacter> fromMapList(List<Map<String, dynamic>> mapList) {
    if (mapList == []) return [];

    return List.of(mapList).map((map) => RCGCharacter.fromMap(map)).toList();
  }
}
