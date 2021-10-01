import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:smash_app/constants/background.dart';
import 'package:smash_app/services/providers.dart';
import 'package:smash_app/models/rcg_character.dart';
import 'package:smash_app/services/db.dart';
import 'package:sqflite/sqflite.dart';

class RandomCharacterGenerator extends ConsumerStatefulWidget {
  const RandomCharacterGenerator({Key? key}) : super(key: key);

  @override
  _RandomCharacterGeneratorState createState() =>
      _RandomCharacterGeneratorState();
}

class _RandomCharacterGeneratorState
    extends ConsumerState<RandomCharacterGenerator> {
  List<RCGCharacter> characters = [];
  RCGCharacter? selectedCharacter;

  String imageUrl = "https://www.smashbros.com/assets_v2/img/fighter/thumb_a/";

  @override
  void initState() {
    super.initState();
    getOptions();
  }

  Future<void> getOptions() async {
    final Database db = ref.read(dbProvider);
    var rcgCharacterList = await SmashAppDatabase().getRCGCharacterList(db);
    if (rcgCharacterList.length == 0) {
      print("No RCG Characters found");
      final result = await retrieveOptions();
      // map result to a list of RCGCharacter objects
      List<RCGCharacter> characters = [];
      for (var i = 0; i < result["displayNames"].length; i++) {
        characters.add(RCGCharacter.fromMap({
          "id": i + 1,
          "displayName": result["displayNames"][i],
          "filePath": result["filePaths"][i],
        }));
      }
      // TODO: sort list alphabetically
      await SmashAppDatabase().insertRCGCharacterList(db, characters);
      setState(() {
        this.characters = characters;
      });
    } else {
      print("RCG Characters found");
      setState(() {
        this.characters = rcgCharacterList;
      });
    }
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
          buildHeader(),
          buildResult(),
          buildRandomizeButton(),
        ],
      ),
    ));
  }

  Widget buildHeader() {
    return Container(
      padding: EdgeInsets.all(10),
      // back button and title with title centered
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Text(
            "Random Character Generator",
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  buildResult() {
    return Column(
      children: [
        buildImage(),
        Text(
          selectedCharacter?.displayName ?? "",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  buildImage() {
    if (selectedCharacter == null) {
      return Container();
    }

    // cache resulting image to local storage
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
      ),
      child: CachedNetworkImage(
        placeholder: (context, url) => CircularProgressIndicator(),
        imageUrl: imageUrl + selectedCharacter!.filePath + ".png",
        errorWidget: (context, url, error) => Icon(Icons.error),
        fit: BoxFit.cover,
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.3,
      ),
    );
  }

  buildRandomizeButton() {
    return ElevatedButton(
      onPressed: () {
        Random rand = new Random();
        setState(() =>
            selectedCharacter = characters[rand.nextInt(characters.length)]);
      },
      child: Text(
        "Randomize Character",
      ),
    );
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
