import 'package:flutter/material.dart';
import 'package:smash_app/pages/personal_set_records.dart';
import 'package:smash_app/pages/random_character_generator.dart';
import 'package:smash_app/pages/random_stage_generator.dart';
import 'package:smash_app/pages/tournament_set_assistant.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, Widget> homeBtns = {
    "Random Character Generator": RandomCharacterGenerator(),
    "Random Stage Generator": RandomStageGenerator(),
    "Tournament Set Assistant": TournamentAssistant(),
    "Personal Set Records": PersonalSetRecords(),
  };

  List<Widget> getHomeButtons() {
    return homeBtns.entries.map((entries) {
      String imageUrl = entries.key.replaceAll(" ", "-");
      print(imageUrl);
      // surround with inkwell
      return Container(
          child: Image(
        image: AssetImage("assets/$imageUrl.png"),
      ));
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
    return Scaffold(
      body: buildBody(),
    );
  }
}
