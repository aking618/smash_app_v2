import 'package:flutter/material.dart';
import 'package:smash_app/models/tournament.dart';

class TournamentScreen extends StatefulWidget {
  final Tournament tournament;
  const TournamentScreen({Key? key, required this.tournament})
      : super(key: key);

  @override
  _TournamentScreenState createState() => _TournamentScreenState();
}

class _TournamentScreenState extends State<TournamentScreen> {
  int player1Score = 0;
  int player2Score = 0;
  List<String> possibleStages = [];
  String? chosenStage;
  int chosenSetLength = 0;
  int strikesRemaining = 0;
  bool choosingStage = true;
  bool playingMatch = false;
  bool striking = false;

  buildBody() {
    return Container(
      child: Column(
        children: [
          buildCurrentScore(),
          buildCurrentStep(),
        ],
      ),
    );
  }

  Widget buildCurrentScore() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$player1Score',
          style: TextStyle(fontSize: 50),
        ),
        Text(
          ' - ',
          style: TextStyle(fontSize: 50),
        ),
        Text(
          '$player2Score',
          style: TextStyle(fontSize: 50),
        ),
      ],
    );
  }

  Widget buildCurrentStep() {
    // choose length at beginning of set
    if (chosenSetLength == 0) {
      return buildChooseSetLengthPropmt();
    }

    // declare winner
    if (player1Score > chosenSetLength / 2 ||
        player2Score > chosenSetLength / 2) {
      return buildWinnerDeclaredPrompt();
    }

    // pick stage
    if (choosingStage) {
      return buildChooseStagePrompt();
    }

    // play match and a player scores a point
    if (playingMatch) {
      return buildPlayMatchPrompt();
    }

    return Container();
  }

  Widget buildChooseSetLengthPropmt() {
    return Column(
      children: <Widget>[
        Text(
          'Choose the length of the set',
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(height: 20),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: widget.tournament.setLengths.map((length) {
              return ElevatedButton(
                child: Text(length.toString()),
                onPressed: () {
                  setState(() {
                    chosenSetLength = int.parse(length);
                  });
                },
              );
            }).toList()),
      ],
    );
  }

  Widget buildChooseStagePrompt() {
    if (player1Score + player2Score == 0 && !striking) {
      setState(() {
        possibleStages = List.from(
            widget.tournament.legalStages['starterStages'].cast<String>());

        strikesRemaining =
            widget.tournament.legalStages['starterStages'].length - 1;
      });
    } else if (!striking) {
      setState(() {
        possibleStages = [
          ...List.from(
              widget.tournament.legalStages['starterStages'].cast<String>()),
          ...List.from(
              widget.tournament.legalStages['counterpickStages'].cast<String>())
        ];

        strikesRemaining = 2;
      });
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            strikesRemaining > 0
                ? 'Strike Stages\nRemaining Strikes: $strikesRemaining'
                : 'Select a Stage',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            children: possibleStages.map((stage) {
              return ElevatedButton(
                child: Text(stage),
                onPressed: () {
                  performStrikeLogic(stage);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget buildPlayMatchPrompt() {
    return Column(
      children: <Widget>[
        Text(
          'Play Match',
          style: TextStyle(fontSize: 20),
        ),
        Text(
          'Stage: $chosenStage',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 20),
        Text('Select Winner of Match'),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              child: Text('Player 1'),
              onPressed: () {
                promptUserToConfirmPlayerChoice(0);
              },
            ),
            SizedBox(width: 20),
            ElevatedButton(
              child: Text('Player 2'),
              onPressed: () {
                promptUserToConfirmPlayerChoice(1);
              },
            ),
          ],
        ),
      ],
    );
  }

  performStrikeLogic(String stage) {
    if (strikesRemaining > 0) {
      setState(() {
        striking = true;
        possibleStages.remove(stage);
        strikesRemaining--;
      });
    }

    if (strikesRemaining == 0) {
      setState(() {
        strikesRemaining--;
      });
      return;
    }

    if (strikesRemaining == -1) {
      setState(() {
        chosenStage = stage;
        striking = false;
        choosingStage = false;
        playingMatch = true;
      });
    }
  }

  promptUserToConfirmPlayerChoice(int player) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Player Choice'),
          content: Text('Are you sure you want to choose this player?'),
          actions: <Widget>[
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                if (player == 0) {
                  setState(() {
                    player1Score++;
                  });
                } else {
                  setState(() {
                    player2Score++;
                  });
                }
                Navigator.of(context).pop();
                setState(() {
                  playingMatch = false;
                  choosingStage = true;
                });
              },
            ),
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildWinnerDeclaredPrompt() {
    return Container(
      child: Column(
        children: [
          Text(
            player1Score > player2Score ? 'Player 1 Wins!' : 'Player 2 Wins!',
            style: TextStyle(fontSize: 20),
          ),
          buildResetButton(),
        ],
      ),
    );
  }

  Widget buildResetButton() {
    return ElevatedButton(
      child: Text('Reset'),
      onPressed: () {
        buildResetDialog();
      },
    );
  }

  Future<dynamic> buildResetDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Reset'),
          content: Text('Are you sure you want to start another set?'),
          actions: <Widget>[
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                resetState();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void resetState() {
    return setState(() {
      player1Score = 0;
      player2Score = 0;
      chosenSetLength = 0;
      chosenStage = '';
      playingMatch = false;
      choosingStage = true;
      striking = false;
      strikesRemaining = 0;
      possibleStages = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.tournament.tournamentName} Set'),
      ),
      body: buildBody(),
    );
  }
}
