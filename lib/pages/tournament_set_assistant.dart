import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smash_app/constants/background.dart';
import 'package:smash_app/constants/constants.dart';
import 'package:smash_app/main.dart';
import 'package:smash_app/models/tournament.dart';
import 'package:smash_app/pages/add_tournament.dart';
import 'package:smash_app/pages/tournament_screen.dart';
import 'package:smash_app/services/db.dart';
import 'package:sqflite/sqflite.dart';

class TournamentAssistant extends ConsumerStatefulWidget {
  const TournamentAssistant({Key? key}) : super(key: key);

  @override
  _TournamentAssistantState createState() => _TournamentAssistantState();
}

class _TournamentAssistantState extends ConsumerState<TournamentAssistant> {
  late Database _db;
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
    _db = ref.read(dbProvider);
    loadTournaments();
  }

  Future<void> loadTournaments() async {
    final tournaments = await SmashAppDatabase().getTournamentList(_db);
    if (tournaments.isEmpty) {
      print('No tournaments found');
      return;
    }

    setState(() {
      this.tournaments = tournaments;
      selectedTournament = tournaments.first;
    });
  }

  buildBody() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          buildHeader(),
          ...buildTASOptions(),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Text(
            'Tournament Assistant',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () {
              print('Help');
            },
          ),
        ],
      ),
    );
  }

  buildTASOptions() {
    return [
      tournaments.isEmpty ? Container() : buildTourneySelector(),
      tournaments.isEmpty ? Container() : buildDisplaySelectedTourney(),
      ElevatedButton(
        child: Text('Create New Tournament'),
        onPressed: () {
          // showDialogForNewTournament();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddTournament(db: _db, createTournament: createNewTournament),
            ),
          );
        },
      ),
    ];
  }

  Row buildTourneySelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          'Select a Created Tournament',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
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
              child: Text(
                tournament.tournamentName,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  showDialogForNewTournament() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return buildDialogContent();
      },
    );
  }

  StatefulBuilder buildDialogContent() {
    return StatefulBuilder(
      builder: (context, StateSetter setState) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Text(
                'Create New Tournament',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              buildNewTournamentForm(setState),
              buildFormActions(context),
            ],
          ),
        );
      },
    );
  }

  Row buildFormActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(
            'Create',
            style: TextStyle(
              color: Colors.green,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
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
  }

  Form buildNewTournamentForm(setState) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
      onSaved: (value) =>
          setState(() => tournamentData['setLengths'] = value!.split(', ')),
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
      onSaved: (value) =>
          setState(() => tournamentData['timeInMinutes'] = int.parse(value!)),
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
      onSaved: (value) =>
          setState(() => tournamentData['stockCount'] = int.parse(value!)),
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
      onSaved: (value) =>
          setState(() => tournamentData['tournamentName'] = value),
    );
  }

  ElevatedButton addCounterpickStageBtn(setState) {
    return ElevatedButton(
      child: Text('Add Counterpick Stage'),
      onPressed: () {
        FocusScope.of(context).requestFocus(FocusNode());
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
        FocusScope.of(context).requestFocus(FocusNode());
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
        FocusScope.of(context).requestFocus(FocusNode());
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

    await SmashAppDatabase().insertTournament(_db, tournament);

    setState(() {
      tournaments = List.from(tournaments)..add(tournament);
      selectedTournament = tournament;
    });

    resetForm();
  }

  Column buildDisplaySelectedTourney() {
    return Column(
      children: [
        Text(
          'Tap to begin set:',
          style: TextStyle(fontSize: 20),
        ),
        InkWell(
          onTap: () {
            // ayren king is the best fiance I love you. aDo you lov3e me??
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TournamentScreen(
                  tournament: selectedTournament!,
                ),
              ),
            );
          },
          child: Card(
            child: Column(
              children: buildTourneyContent(),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> buildTourneyContent() {
    List<Widget> content = [
      ListTile(
        title: Text(
          selectedTournament!.tournamentName,
          style: TextStyle(fontSize: 20),
        ),
        subtitle: buildTourneyInfoText(),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return buildTourneyDeletionDialog(context);
              },
            );
          },
        ),
      ),
    ];

    return content;
  }

  AlertDialog buildTourneyDeletionDialog(BuildContext context) {
    return AlertDialog(
      title: Text('Delete Tournament'),
      content: Text(
          'Are you sure you want to delete ${selectedTournament!.tournamentName}?'),
      actions: <Widget>[
        ElevatedButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: Text('Delete'),
          // make elevated button red
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.red),
          ),
          onPressed: () async {
            Navigator.of(context).pop();
            await deleteTournament();
          },
        ),
      ],
    );
  }

  Future<void> deleteTournament() async {
    await SmashAppDatabase().deleteTournament(_db, selectedTournament!.id);
    setState(() {
      tournaments = List.from(tournaments)..remove(selectedTournament);
      selectedTournament = tournaments.isNotEmpty ? tournaments[0] : null;
    });
  }

  Text buildTourneyInfoText() {
    return Text(
      '''
    Stock Count: ${selectedTournament!.stockCount}
    Set Lengths : ${selectedTournament!.setLengths}
    Time Limit  : ${selectedTournament!.timeInMinutes} minutes
    Legal Stages: 
       Starter: ${selectedTournament!.legalStages['starterStages']}
       Counterpick : ${selectedTournament!.legalStages['counterpickStages']}
    Additional Rules: ${selectedTournament!.additionalRules}
    ''',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: Colors.grey[700],
      ),
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
      child: Background(
        child: Scaffold(
          body: buildBody(),
        ),
      ),
    );
  }
}
