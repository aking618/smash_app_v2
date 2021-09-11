class RSGStage {
  final int id;
  final String stageName;
  final String filePath;

  RSGStage({
    required this.id,
    required this.stageName,
    required this.filePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'stageName': stageName,
      'filePath': filePath,
    };
  }

  @override
  String toString() {
    return 'RSGStage{id: $id, stageName: $stageName, filePath: $filePath}';
  }

  static RSGStage fromMap(Map<String, dynamic> map) {
    return RSGStage(
      id: map['id'],
      stageName: map['stageName'],
      filePath: map['filePath'],
    );
  }

  static List<RSGStage> fromMapList(dynamic mapList) {
    if (mapList == []) return [];

    return List.of(mapList).map((map) => RSGStage.fromMap(map)).toList();
  }
}
