import 'package:flutter/material.dart';
import 'package:smash_app/constants/background.dart';
import 'package:smash_app/pages/personal_set_records.dart';
import 'package:smash_app/pages/random_character_generator.dart';
import 'package:smash_app/pages/tournament_set_assistant.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, Widget> homeBtns = {};

  @override
  void initState() {
    super.initState();
    homeBtns = {
      'Random Character Generator': RandomCharacterGenerator(),
      'Tournament Set Assistant': TournamentAssistant(),
      'Personal Set Records': PersonalSetRecords(),
    };
  }

  List<Widget> getHomeButtons() {
    return homeBtns.entries.map((entries) {
      return ElevatedButton(
        child: Text(entries.key),
        onPressed: () {
          navigateToPage(entries.value);
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
    return Background(
      child: Scaffold(
        body: buildBody(),
      ),
    );
  }
}
