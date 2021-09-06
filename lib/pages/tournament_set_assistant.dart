import 'package:flutter/material.dart';
import 'package:smash_app/constants/constants.dart';
import 'package:smash_app/models/tournament.dart';
import 'package:smash_app/services/db.dart';

class TournamentAssistant extends StatefulWidget {
  final db;
  const TournamentAssistant({Key? key, this.db}) : super(key: key);

  @override
  _TournamentAssistantState createState() => _TournamentAssistantState();
}

class _TournamentAssistantState extends State<TournamentAssistant> {
  Tournament? selectedTournament;
  List<Tournament> tournaments = [];
  Map<String, dynamic> tournamentData = {};
  final _formKey = GlobalKey<FormState>();
  List<Widget> starterStagesFormFields = [];

  @override
  void initState() {
    super.initState();
    loadTournaments();
  }

  Future<void> loadTournaments() async {
    final tournaments = await SmashAppDatabase().getTournamentList(widget.db);
    if (tournaments.isEmpty) print('No tournaments found');

    setState(() {
      this.tournaments = tournaments;
    });
  }

  buildBody() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: buildTASOptions(),
        ),
      ),
    );
  }

  buildTASOptions() {
    return [
      tournaments.isEmpty ? Container() : buildTourneySelector(),
      ElevatedButton(
        child: Text('Create New Tournament'),
        onPressed: () {
          // show dialog for creating new tournament
          showDialogForNewTournament();
        },
      ),
    ];
  }

  Row buildTourneySelector() {
    return Row(
      children: [
        Text('Select a Created Tournament'),
        DropdownButton<String>(
          value: selectedTournament?.tournamentName ?? 'Select a tournament',
          icon: Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.deepPurple),
          underline: Container(
            height: 2,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (value) {
            setState(() => selectedTournament = tournaments.firstWhere(
                (tournament) => tournament.tournamentName == value));
          },
          items: tournaments.map<DropdownMenuItem<String>>((tournament) {
            return DropdownMenuItem<String>(
              value: tournament.tournamentName,
              child: Text(tournament.tournamentName),
            );
          }).toList(),
        ),
      ],
    );
  }

  showDialogForNewTournament() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create New Tournament'),
          content: buildNewTournamentForm(),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Create'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.of(context).pop();
                  // createNewTournament();
                }
              },
            ),
          ],
        );
      },
    );
  }

  buildNewTournamentForm() {
    // TODO: figure out to add dropdown fields dynamically
    // TODO: add those dropdown values to the tournamentData map
    // TODO: implement counterpick stages and add those to the tournamentData map
    // TODO: save the tournamentData map to the database
    // TODO: add the tournament to the tournaments list
    // TODO: update the tournament selector dropdown

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Tournament Name'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a tournament name';
                }
                return null;
              },
              onSaved: (value) =>
                  setState(() => tournamentData['tournamentName'] = value),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Stock Count'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a stock count';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
              onSaved: (value) => setState(
                  () => tournamentData['stockCount'] = int.parse(value!)),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Match Time (minutes)'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a match time';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
              onSaved: (value) => setState(
                  () => tournamentData['timeInMinutes'] = int.parse(value!)),
            ),
            TextFormField(
              decoration:
                  InputDecoration(labelText: 'Set Lengths (ex. "3, 5")'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a set length';
                }
                if (value!.split(',').length > 2) {
                  return 'Please enter up to 2 set lengths';
                }
                if (value!
                    .split(',')
                    .any((length) => int.tryParse(length) == null)) {
                  return 'Please enter valid set lengths';
                }
                return null;
              },
              onSaved: (value) => setState(
                  () => tournamentData['setLengths'] = value!.split(',')),
            ),
            // add all of starterStagesFormFields to the form even if the values change
            ...starterStagesFormFields,

            // add button to add another stage
            ElevatedButton(
              child: Text('Add Starter Stage'),
              onPressed: () {
                setState(() {
                  starterStagesFormFields = List.from(starterStagesFormFields)
                    ..add(stageDropdownForm(starterStagesFormFields.length));
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  DropdownButtonFormField<Object> stageDropdownForm(length) {
    return DropdownButtonFormField(
      decoration: InputDecoration(labelText: 'Stage ${length + 1}'),
      value: tournamentData['stage1'] ?? stageNameList[0],
      onChanged: (value) => setState(() => tournamentData['stage1'] = value),
      items: stageNameList.map((stage) {
        return DropdownMenuItem<String>(
          value: stage,
          child: Text(stage),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Tournament Assistant'),
        ),
        body: buildBody(),
      ),
    );
  }
}
