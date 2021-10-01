class User {
  final int userID; // 1234567
  final String slug; // user/abcd1234
  final String discriminator; // abcd1234
  final String genderPronoun; // he/him
  final List<Map<String, dynamic>> images; // [{type: profile, url: ...}, ...]
  final int playerID; // 9876543
  final String gamerTag; // Nebula
  final String prefix; // GOSU

  User({
    required this.userID,
    required this.slug,
    required this.discriminator,
    required this.genderPronoun,
    required this.images,
    required this.playerID,
    required this.gamerTag,
    required this.prefix,
  });

  // static User fromMap(Map<String, dynamic> map) {
  //   return User(...null);
  // }
}
