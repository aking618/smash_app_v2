import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:smash_app/constants/background.dart';
import 'package:smash_app/constants/constants.dart';
import 'package:smash_app/models/tournament.dart';
import 'package:smash_app/services/db.dart';
import 'package:smash_app/services/providers.dart';
import 'package:smash_app/toasts/custom_toast.dart';
import 'package:sqflite/sqflite.dart';

class AddTournament extends ConsumerStatefulWidget {
  final int tournamentId;
  const AddTournament({
    Key? key,
    required this.tournamentId,
  }) : super(key: key);

  @override
  _AddTournamentState createState() => _AddTournamentState();
}

class _AddTournamentState extends ConsumerState<AddTournament> {
  final _formKey = GlobalKey<FormState>();
  List<Widget> starterStages = [];
  List<Widget> counterpickStages = [];
  List<String> chosenStarters = [];
  List<String> chosenCounterpicks = [];
  Map<String, dynamic> tournamentData = {
    'id': null,
    'tournamentName': '',
    'setLengths': [],
    'legalStages': {},
    'stockCount': 0,
    'timeInMinutes': 0,
  };
  late Database db;

  @override
  void initState() {
    super.initState();
    db = ref.read(dbProvider);
    tournamentData['id'] = widget.tournamentId;
  }

  Widget buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            buildHeader(),
            buildForm(),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Text(
            'Add Tournament',
            style: TextStyle(fontSize: 20),
          ),
          buildValidateAndSaveTournamentButton(),
        ],
      ),
    );
  }

  Widget buildValidateAndSaveTournamentButton() {
    return IconButton(
      icon: Icon(Icons.check),
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();

          if (chosenStarters.isEmpty || chosenCounterpicks.isEmpty) {
            CustomToast().show(
              "Please select at least one starter and one counterpick",
              ToastType.error,
            );
            return;
          }

          setState(() {
            tournamentData['legalStages'] = {
              'starterStages': chosenStarters,
              'counterpickStages': chosenCounterpicks,
            };
          });

          Tournament tournament = Tournament.fromMap(tournamentData);
          await SmashAppDatabase().insertTournament(db, tournament);

          CustomToast().show("Tournament added", ToastType.success);

          Navigator.pop(context);
        }
      },
    );
  }

  Widget buildForm() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildNameField(),
            buildMatchInfoRow(),
            buildStageSelectSectionHeader(),
            Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Text(
                "Starter Stages",
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
            starterStages.isEmpty
                ? Text("Press the + to add starter stage(s)")
                : Container(),
            ...starterStages,
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Text(
                "Counterpick Stages",
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
            counterpickStages.isEmpty
                ? Text("Press the + to add counterpick stage(s)")
                : Container(),
            ...counterpickStages,
          ],
        ),
      ),
    );
  }

  Widget buildNameField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Tournament Name',
        hintText: 'Monday Mayhem',
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a tournament name';
        }
        return null;
      },
      onSaved: (value) {
        setState(() {
          tournamentData['tournamentName'] = value;
        });
      },
    );
  }

  Widget buildMatchInfoRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        buildMatchInfoField('Stock Count', 'stockCount'),
        buildMatchInfoField('Set Length', 'setLengths'),
        buildMatchInfoField('Time', 'timeInMinutes'),
      ],
    );
  }

  Widget buildMatchInfoField(String label, String field) {
    return Container(
      width: MediaQuery.of(context).size.width / 4,
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          hintText: getHint(field),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter a value';
          }
          if (field == 'setLengths') {
            if (value.split(',').length != 2) {
              return 'Please enter two values separated by a comma';
            }
            // check if set lengths are numbers
            if (int.tryParse(value.split(',')[0]) == null ||
                int.tryParse(value.split(',')[1]) == null) {
              return 'Please enter two numbers separated by a comma';
            }
          }
          return null;
        },
        onSaved: (value) {
          if (field == 'setLengths') {
            setState(() {
              tournamentData[field] = value!.split(',');
            });
          } else {
            setState(() {
              tournamentData[field] = int.parse(value!);
            });
          }
        },
      ),
    );
  }

  String getHint(String field) {
    switch (field) {
      case 'stockCount':
        return '3';
      case 'setLengths':
        return '3,3';
      case 'timeInMinutes':
        return '7';
      default:
        return '';
    }
  }

  Widget buildStageSelectSectionHeader() {
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      child: Text(
        'Stages:',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget stageSelector(String label, int length) {
    return Container(
      margin: EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width / 1.75,
            child: DropdownButtonFormField<String>(
              value: null,
              isExpanded: true,
              onChanged: (value) {
                FocusScope.of(context).requestFocus(FocusNode());
                switch (label) {
                  case 'Starter Stage':
                    if (!starterStages.contains(value)) {
                      setState(() {
                        chosenStarters.add(value!);
                      });
                    }
                    break;
                  case 'Counterpick Stage':
                    if (!counterpickStages.contains(value)) {
                      setState(() {
                        chosenCounterpicks.add(value!);
                      });
                    }
                    break;
                }
              },
              items: stageNameList.map((stage) {
                return DropdownMenuItem<String>(
                  value: stage,
                  child: Text(
                    stage,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFAB() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      visible: true,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          child: Icon(Icons.add_alert),
          backgroundColor: Colors.green,
          onTap: () {
            setState(() {
              starterStages
                  .add(stageSelector('Starter Stage', starterStages.length));
            });
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
          onTap: () {
            setState(() {
              counterpickStages.add(
                  stageSelector('Counterpick Stage', counterpickStages.length));
            });
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Scaffold(
        body: buildBody(context),
        floatingActionButton: buildFAB(),
      ),
    );
  }
}
