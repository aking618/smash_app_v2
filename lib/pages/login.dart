import 'package:flutter/material.dart';
import 'package:smash_app/constants/background.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
    // TODO: implement login
    // test network call to retrieve user
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
