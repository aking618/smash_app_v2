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
  // add clickablelistwheelscrollview
  //

  List<String> homeBtnLabels = [
    "Random Character Generator",
    "Random Stage Generator",
    "Tournament Set Assistant",
    "Personal Set Records",
  ];

  List<Widget> homeBtnDestinations = [
    RandomCharacterGenerator(),
    RandomStageGenerator(),
    TournamentAssistant(),
    PersonalSetRecords(),
  ];

  List<Widget> getHomeButtons() {
    return List.generate(
        homeBtnLabels.length,
        (index) => Container(
              color: Colors.amber,
              child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => homeBtnDestinations[index]));
                  },
                  child: Text(homeBtnLabels[index])),
            ));
  }

  Widget buildBody() {
    // a container that contains listwheel scrollview of buttons
    return Container(
      child: ListWheelScrollView(
        itemExtent: 200,
        diameterRatio: 1.5,
        offAxisFraction: -0.5,
        magnification: 2,
        children: getHomeButtons(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
    );
  }
}
