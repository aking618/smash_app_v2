import 'dart:math';

import 'package:flutter/material.dart';
import 'package:smash_app/pages/personal_set_records.dart';
import 'package:smash_app/pages/random_character_generator.dart';
import 'package:smash_app/pages/random_stage_generator.dart';
import 'package:smash_app/pages/tournament_set_assistant.dart';
import 'package:smash_app/services/db.dart';
import 'package:sqflite/sqflite.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var db;
  Map<String, Widget> homeBtns = {};

  @override
  void initState() {
    super.initState();
    initDatabase();
  }

  Future<void> initDatabase() async {
    Database database = await SmashAppDatabase().intializedDB();
    setState(() {
      db = database;
      homeBtns = {
        "Random Character Generator": RandomCharacterGenerator(db: database),
        "Tournament Set Assistant": TournamentAssistant(db: database),
        "Personal Set Records": PersonalSetRecords(db: database),
      };
    });
  }

  List<Widget> getHomeButtons() {
    return homeBtns.entries.map((entries) {
      return ElevatedButton(
        child: Text(entries.key),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
          elevation: MaterialStateProperty.all<double>(8.0),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          textStyle: MaterialStateProperty.all<TextStyle>(
            TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),
        onPressed: () {
          navigateToPage(entries.value);
          ;
        },
      );
    }).toList();
  }

  Widget buildBody() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: getHomeButtons(),
        ),
      ),
    );
  }

  navigateToPage(destination) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => destination));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // smooth dark gradient background
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1A1A1A),
            Color(0xFF2D2D2D),
            Color(0xFF3A3A3A),
            Color(0xFF4F4F4F),
            Color(0xFF636363),
            Color(0xFF7A7A7A),
            Color(0xFF919191),
            Color(0xFFA6A6A6),
            Color(0xFFBBBBBB),
            Color(0xFFD0D0D0),
            Color(0xFFE6E6E6),
            Color(0xFFFBFBFB),
          ],
        ),
      ),
      child: Scaffold(
        body: buildBody(),
      ),
    );
  }
}
