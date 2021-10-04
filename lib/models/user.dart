import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smash_app/services/providers.dart';

class User {
  final int userID; // 1234567
  final String slug; // user/abcd1234
  final String discriminator; // abcd1234
  final String genderPronoun; // he/him
  final List<dynamic> images; // [{type: profile, url: ...}, ...]
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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userID: json['id'],
      slug: json['slug'],
      discriminator: json['discriminator'],
      genderPronoun: json['genderPronoun'] ?? '',
      images: json['images'],
      playerID: json['player']['id'],
      gamerTag: json['player']['gamerTag'] ?? '',
      prefix: json['player']['prefix'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': userID,
        'slug': slug,
        'discriminator': discriminator,
        'genderPronoun': genderPronoun,
        'images': images,
        'player': {
          'id': playerID,
          'gamerTag': gamerTag,
          'prefix': prefix,
        },
      };

  @override
  String toString() {
    return 'User{userID: $userID, slug: $slug, discriminator: $discriminator, genderPronoun: $genderPronoun, images: $images, playerID: $playerID, gamerTag: $gamerTag, prefix: $prefix}';
  }
}
