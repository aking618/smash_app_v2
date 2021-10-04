import 'dart:convert';

import 'package:smash_app/models/user.dart';
import 'package:http/http.dart' as http;

class Queries {
  String getPlayer(String slug) {
    return '''
    query user{
      user(slug: "$slug") {
        id
        slug
        discriminator
        genderPronoun
        images {
          type
          url
        }
        player {
          id
          gamerTag
          prefix
        }
      }
    }
    ''';
  }
}

class SmashggApi {
  final Uri baseUrl = Uri.parse('https://api.smash.gg/gql/alpha');
  final String autherization = 'Bearer 97f95303965bc5182e03797f7943332c';
  final contentType = 'application/json';

  Future<User?> getUser(String slug) async {
    final response = await http.post(
      baseUrl,
      headers: {
        'Authorization': autherization,
        'Content-Type': contentType,
      },
      body: json.encode({
        'query': Queries().getPlayer(slug),
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final user = data['data']['user'];
      if (user != null) {
        return User.fromJson(user);
      } else {
        return null;
      }
    } else {
      throw Exception('Failed to load user');
    }
  }
}
