import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smash_app/constants/background.dart';
import 'package:smash_app/models/user.dart';
import 'package:smash_app/services/providers.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  Widget buildBody(User? _user) {
    if (_user == null) {
      return Center(
        child: Text(
          'Invalid User',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      child: buildUserLayout(_user),
    );
  }

  Widget buildUserLayout(User? _user) {
    String tag = _user!.prefix.isEmpty
        ? _user!.gamerTag
        : "${_user!.prefix} | ${_user!.gamerTag}";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // sized image
        SizedBox(
          height: 100,
          width: 100,
          child: CachedNetworkImage(
            imageUrl: _user!.images[0]['url'],
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.fitWidth,
          ),
        ),
        Text(
          tag,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    User? _user = ref.read(userProvider).state;
    return Background(
      child: Scaffold(
        body: buildBody(_user),
      ),
    );
  }
}
