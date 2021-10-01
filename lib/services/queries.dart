class Queries {
  String getPlayer(String slug) {
    return '''
    query user{
      user {
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
