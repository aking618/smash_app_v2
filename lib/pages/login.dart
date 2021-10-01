import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smash_app/constants/background.dart';
import 'package:smash_app/services/providers.dart';
import 'package:smash_app/services/queries.dart';
import 'package:smash_app/toasts/custom_toast.dart';

class Login extends ConsumerStatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  TextEditingController _userSlugController = TextEditingController();
  bool _isLoading = false;
  String? serverResponse;

  Widget buildBody() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildSlugField(),
          buildServerResponse(),
        ],
      ),
    );
  }

  Column buildSlugField() {
    return Column(
      children: [
        TextField(
          controller: _userSlugController,
          decoration: InputDecoration(
            labelText: 'User Slug',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () async {
            setState(() {
              _isLoading = true;
            });
            await _login();
            setState(() {
              _isLoading = false;
            });
          },
          child: Text('Login'),
        ),
      ],
    );
  }

  Column buildServerResponse() {
    return Column(
      children: [
        serverResponse == null ? Container() : Text(serverResponse!),
        SizedBox(height: 16),
        _isLoading ? CircularProgressIndicator() : Container()
      ],
    );
  }

  Future<void> _login() async {
    var data = await getUserFromSmashAPI();

    data!.forEach((key, value) => print("$key : $value"));

    if (data['data']['user'] == null) {
      CustomToast()
          .show("Smash GG user not found. Check user input", ToastType.error);
      return;
    }

    CustomToast().show("Smash GG user found!", ToastType.success);

    await saveUserSlugToPreferences(data['data']['user']['discriminator'])
        ? CustomToast().show("User info saved", ToastType.success)
        : CustomToast()
            .show("Unable to save user info. Try again later", ToastType.error);
  }

  Future<Map<String, dynamic>?> getUserFromSmashAPI() async {
    GraphQLClient client = ref.read(clientProvider).value;
    var response = await client.query(
      QueryOptions(
        document: gql(Queries().getPlayer(_userSlugController.text)),
      ),
    );

    return response.data;
  }

  Future<bool> saveUserSlugToPreferences(String slug) {
    SharedPreferences prefs = ref.read(sharedPrefsProvider);
    return prefs.setString("userSlug", slug);
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Scaffold(
        body: buildBody(),
      ),
    );
  }
}
