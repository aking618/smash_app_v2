import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RandomCharacterGenerator extends StatefulWidget {
  const RandomCharacterGenerator({Key? key}) : super(key: key);

  @override
  _RandomCharacterGeneratorState createState() =>
      _RandomCharacterGeneratorState();
}

class _RandomCharacterGeneratorState extends State<RandomCharacterGenerator> {
  List<dynamic> options = [];
  String selectedOption = "";
  List<dynamic> filePaths = [];

  String imageUrl = "https://www.smashbros.com/assets_v2/img/fighter/thumb_a/";

  @override
  void initState() {
    super.initState();
    // check if options are saved in local storage

    getOptions();
  }

  Future<void> getOptions() async {
    final result = await retrieveOptions();
    print(result['filePaths']);
    setState(() {
      options = result['displayNames'];
      filePaths = result['filePaths'];
    });
  }

  retrieveOptions() async {
    final result = await http.get(Uri.parse(
        "https://www.smashbros.com/assets_v2/data/fighter.json?_=1630795161823"));
    var body = jsonDecode(result.body);
    var options = body["fighters"];
    // get list of displayNameEn
    var displayNames =
        options.map((e) => e["displayName"]["en_US"] as String).toList();
    // get list of filePath
    var filePath = options.map((e) => e["file"] as String).toList();
    Map<String, dynamic> resultMap = {
      "displayNames": displayNames,
      "filePaths": filePath
    };
    return resultMap;
  }

  Container buildBody() {
    return Container(
        child: Center(
      child: Column(
        children: [
          // add back button
          buildBackButton(),
          buildResult(),
          buildRandomizeButton(),
        ],
      ),
    ));
  }

  Container buildBackButton() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: FlatButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          "Back",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  buildResult() {
    return Column(
      children: [
        buildImage(),
        Text(selectedOption),
      ],
    );
  }

  buildImage() {
    if (selectedOption == "") {
      return Container();
    }

    // cache resulting image to local storage

    return Container(
      child: Image.network(
        imageUrl + filePaths[options.indexOf(selectedOption)] + ".png",
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.3,
        fit: BoxFit.cover,
      ),
    );
  }

  buildRandomizeButton() {
    return TextButton(
      onPressed: () {
        Random rand = new Random();
        setState(() => selectedOption = options[rand.nextInt(options.length)]);
      },
      child: Text(
        "Randomize Character",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: buildBody(),
      ),
    );
  }
}
