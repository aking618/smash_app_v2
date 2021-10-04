import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smash_app/constants/background.dart';
import 'package:smash_app/models/user.dart';
import 'package:smash_app/pages/home.dart';
import 'package:smash_app/services/providers.dart';
import 'package:smash_app/services/queries.dart';
import 'package:smash_app/toasts/custom_toast.dart';
import 'package:http/http.dart' as http;

class Login extends ConsumerStatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  TextEditingController _userSlugController = TextEditingController();
  bool _isLoading = false;
  String? serverResponse;

  @override
  initState() {
    super.initState();
    checkIfLoggedIn();
  }

  @override
  void dispose() {
    _userSlugController.dispose();
    super.dispose();
  }

  Future<void> checkIfLoggedIn() async {
    final prefs = ref.read(sharedPrefsProvider);
    String userString = prefs.getString('user') ?? '';
    User? user =
        userString.isNotEmpty ? User.fromJson(jsonDecode(userString)) : null;
    if (user != null) {
      ref.read(userProvider).state = user;
      CustomToast().show("Logged In", ToastType.success);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    }
  }

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
    User? user = await getUserFromSmashAPI();
    if (user == null) {
      CustomToast()
          .show("Smash GG user not found. Check user input", ToastType.error);
      return;
    }

    ref.read(userProvider).state = user;

    CustomToast().show("Smash GG user found!", ToastType.success);

    await saveUserToPreferences(user)
        ? CustomToast().show("User info saved", ToastType.success)
        : CustomToast()
            .show("Unable to save user info. Try again later", ToastType.error);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }

  Future<User?> getUserFromSmashAPI() async {
    return await SmashggApi().getUser(_userSlugController.text);
  }

  Future<bool> saveUserToPreferences(User user) {
    SharedPreferences prefs = ref.read(sharedPrefsProvider);
    return prefs.setString("user", jsonEncode(user.toJson()));
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
