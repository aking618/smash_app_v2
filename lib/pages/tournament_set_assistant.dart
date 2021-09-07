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
  List<Widget> additionalRulesFormFields = [];
  List<Widget> counterpickStagesFormFields = [];
  List<String> starterStages = [];
  List<String> counterpickStages = [];
  List<String> additionalRules = [];

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
          showDialogForNewTournament();
        },
      ),
      printSelectedTournamentBtn(),
    ];
  }

  Row buildTourneySelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('Select a Created Tournament'),
        DropdownButton<String>(
          value: selectedTournament?.tournamentName ??
              tournaments[0].tournamentName,
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
        return buildDialogContent();
      },
    );
  }

  StatefulBuilder buildDialogContent() {
    return StatefulBuilder(
      builder: (context, StateSetter setState) {
        return AlertDialog(
          title: Text('Create New Tournament'),
          content: buildNewTournamentForm(setState),
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
                  _formKey.currentState!.save();
                  Navigator.of(context).pop();
                  createNewTournament();
                }
              },
            ),
          ],
        );
      },
    );
  }

  buildNewTournamentForm(setState) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            tournamentNameFormField(setState),
            stockCountFormField(setState),
            matchTimeFormField(setState),
            setLengthFormField(setState),
            ...starterStagesFormFields,
            addStarterStageBtn(setState),
            ...counterpickStagesFormFields,
            addCounterpickStageBtn(setState),
            ...additionalRulesFormFields,
            addAdditionalRuleBtn(setState),
          ],
        ),
      ),
    );
  }

  TextFormField setLengthFormField(setState) {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Set Lengths (ex. "3, 5")'),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a set length';
        }
        if (value.split(', ').length > 2) {
          return 'Please enter up to 2 set lengths';
        }
        if (value.split(', ').any((length) => int.tryParse(length) == null)) {
          return 'Please enter valid set lengths';
        }
        return null;
      },
      onChanged: (value) =>
          setState(() => tournamentData['setLengths'] = value.split(', ')),
    );
  }

  TextFormField matchTimeFormField(setState) {
    return TextFormField(
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
      onChanged: (value) =>
          setState(() => tournamentData['timeInMinutes'] = int.parse(value)),
    );
  }

  TextFormField stockCountFormField(setState) {
    return TextFormField(
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
      onChanged: (value) =>
          setState(() => tournamentData['stockCount'] = int.parse(value)),
    );
  }

  TextFormField tournamentNameFormField(setState) {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Tournament Name'),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a tournament name';
        }
        return null;
      },
      onChanged: (value) =>
          setState(() => tournamentData['tournamentName'] = value),
    );
  }

  ElevatedButton addCounterpickStageBtn(setState) {
    return ElevatedButton(
      child: Text('Add Counterpick Stage'),
      onPressed: () {
        setState(() {
          counterpickStagesFormFields = List.from(counterpickStagesFormFields)
            ..add(counterpickStageDropdownForm(
                counterpickStagesFormFields.length));
        });
      },
    );
  }

  ElevatedButton addStarterStageBtn(setState) {
    return ElevatedButton(
      child: Text('Add Starter Stage'),
      onPressed: () {
        setState(() {
          starterStagesFormFields = List.from(starterStagesFormFields)
            ..add(stageDropdownForm(starterStagesFormFields.length));
        });
      },
    );
  }

  ElevatedButton addAdditionalRuleBtn(setState) {
    return ElevatedButton(
      child: Text('Add Additional Rule'),
      onPressed: () {
        setState(() {
          additionalRulesFormFields = List.from(additionalRulesFormFields)
            ..add(additionalRuleTextField(additionalRulesFormFields.length));
        });
      },
    );
  }

  DropdownButtonFormField<String> stageDropdownForm(length) {
    return DropdownButtonFormField(
      decoration: InputDecoration(labelText: 'Starter Stage ${length + 1}'),
      value: tournamentData['stage'] ?? stageNameList[0],
      onChanged: (value) {
        FocusScope.of(context).requestFocus(FocusNode());
        setState(() => starterStages.add(value!));
      },
      items: stageNameList.map((stage) {
        return DropdownMenuItem<String>(
          value: stage,
          child: Text(stage),
        );
      }).toList(),
    );
  }

  DropdownButtonFormField<String> counterpickStageDropdownForm(length) {
    return DropdownButtonFormField(
      decoration: InputDecoration(labelText: 'Counterpick Stage ${length + 1}'),
      value: tournamentData['stage'] ?? stageNameList[0],
      onChanged: (value) {
        FocusScope.of(context).requestFocus(FocusNode());
        setState(() => counterpickStages.add(value!));
      },
      items: stageNameList.map((stage) {
        return DropdownMenuItem<String>(
          value: stage,
          child: Text(stage),
        );
      }).toList(),
    );
  }

  TextFormField additionalRuleTextField(length) {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Additional Rule ${length + 1}'),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter an additional rule';
        }
        return null;
      },
      onSaved: (value) => setState(() {
        if (!additionalRules.contains(value)) {
          additionalRules.add(value!);
        }
      }),
    );
  }

  Future<void> createNewTournament() async {
    Map<String, dynamic> legalStages = {
      'starterStages': starterStages,
      'counterpickStages': counterpickStages
    };
    setState(() {
      tournamentData['id'] = tournaments.length + 1;
      tournamentData['legalStages'] = legalStages;
      tournamentData['additionalRules'] = additionalRules;
    });

    Tournament tournament = Tournament.fromMap(tournamentData);

    await SmashAppDatabase().insertTournament(widget.db, tournament);

    setState(() {
      tournaments = List.from(tournaments)..add(tournament);
    });

    resetForm();
  }

  ElevatedButton printSelectedTournamentBtn() {
    return ElevatedButton(
      child: Text('Print Selected Tournament'),
      onPressed: () {
        if (selectedTournament != null)
          print(selectedTournament.toString());
        else
          print('No tournament selected');
      },
    );
  }

  resetForm() {
    setState(() {
      tournamentData = {};
      starterStages = [];
      counterpickStages = [];
      additionalRules = [];
      starterStagesFormFields = [];
      counterpickStagesFormFields = [];
      additionalRulesFormFields = [];
    });
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
