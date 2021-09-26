import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smash_app/constants/background.dart';
import 'package:smash_app/models/player_record.dart';
import 'package:smash_app/models/rcg_character.dart';
import 'package:smash_app/services/db.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class AddPersonalRecord extends StatefulWidget {
  final Database db;
  final int playerId;
  const AddPersonalRecord({Key? key, required this.db, required this.playerId})
      : super(key: key);

  @override
  _AddPersonalRecordState createState() => _AddPersonalRecordState();
}

class _AddPersonalRecordState extends State<AddPersonalRecord> {
  final _formKey = GlobalKey<FormState>();
  List<RCGCharacter> _characters = [];
  List<Widget> _characterDropdowns = [];
  List<RCGCharacter> chosenCharacters = [];
  Map<String, dynamic> entries = {
    'playerTag': '',
    'wins': 0,
    'losses': 0,
    'notes': '',
    'characters': [],
  };

  @override
  void initState() {
    super.initState();
    getCharacters();
  }

  Future<void> getCharacters() async {
    var rcgCharacterList =
        await SmashAppDatabase().getRCGCharacterList(widget.db);
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
      await SmashAppDatabase().insertRCGCharacterList(widget.db, characters);
      setState(() {
        _characters = characters;
      });
    } else {
      print("RCG Characters found");
      setState(() {
        _characters = rcgCharacterList;
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

  Widget buildBody(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          buildHeader(),
          buildForm(),
        ],
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
            'Add Personal Record',
            style: TextStyle(fontSize: 20),
          ),
          buildValidateAndBuildRecordBtn(),
        ],
      ),
    );
  }

  IconButton buildValidateAndBuildRecordBtn() {
    return IconButton(
      icon: Icon(Icons.check),
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();

          if (chosenCharacters.length == 0) {
            Fluttertoast.showToast(
              msg: "Please select at least one character",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );

            return;
          }

          setState(() {
            entries['id'] = widget.playerId;
            entries['characters'] = chosenCharacters;
          });

          PlayerRecord playerRecord = PlayerRecord.fromMap(entries);
          await SmashAppDatabase().insertPlayerRecord(widget.db, playerRecord);
          Navigator.pop(context);
        }
      },
    );
  }

  Widget buildForm() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            buildPlayerTagTextField(),
            // row with lost and won
            buildSetRow(),
            buildNotesTextField(),
            buildCharacterSectionHeader(),
            _characterDropdowns.isEmpty
                ? Text("Click the + to add characters")
                : Container(),
            ..._characterDropdowns,
          ],
        ),
      ),
    );
  }

  Widget buildPlayerTagTextField() {
    return TextFormField(
        decoration: InputDecoration(
          hintText: "Player Tag",
          labelText: 'Player Tag',
        ),
        validator: (value) {
          if (value!.isEmpty) return 'Player Tag is required';
          return null;
        },
        onSaved: (value) {
          setState(() {
            entries['playerTag'] = value;
          });
        });
  }

  addCharacterToList() {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _characterDropdowns = List.from(_characterDropdowns)
        ..add(characterDropDown(_characterDropdowns.length));
    });
  }

  Widget buildSetRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        buildWonTextField(),
        buildLostTextField(),
      ],
    );
  }

  Widget characterDropDown(length) {
    // row with character dropdown and remove button
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.5,
          child: DropdownButtonFormField<RCGCharacter>(
            decoration: InputDecoration(
              labelText: 'Character',
            ),
            value: null,
            items: _characters
                .map((character) => DropdownMenuItem<RCGCharacter>(
                    value: character,
                    child: Text(
                      character.displayName,
                    )))
                .toList(),
            onChanged: (value) {
              if (!chosenCharacters.contains(value)) {
                setState(() {
                  chosenCharacters.add(value!);
                });
                print(chosenCharacters);
              }
            },
            validator: (value) {
              if (value == null) return 'Character is required';
              return null;
            },
          ),
        ),
        // remove button with icon and "remove character" text
        Column(
          children: [
            Text(
              "Remove Character",
              style: TextStyle(fontSize: 12, color: Colors.red),
            ),
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                // remove this dropdown from the list
                setState(() {
                  _characterDropdowns = List.from(_characterDropdowns)
                    ..removeAt(length);
                  chosenCharacters.removeAt(length);
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget buildLostTextField() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      child: TextFormField(
        decoration: InputDecoration(
          hintText: "Lost",
          labelText: 'Lost',
        ),
        initialValue: '0',
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value!.isEmpty || int.tryParse(value) == null)
            return 'Lost is required and must be a valid number';
          return null;
        },
        onSaved: (value) {
          entries['lost'] = int.tryParse(value!);
        },
      ),
    );
  }

  Widget buildWonTextField() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      child: TextFormField(
        decoration: InputDecoration(
          hintText: "Won",
          labelText: 'Won',
        ),
        initialValue: '0',
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value!.isEmpty || int.tryParse(value) == null)
            return 'Won is required and must be a valid number';
          return null;
        },
        onSaved: (value) {
          setState(() {
            entries['won'] = int.tryParse(value!);
          });
        },
      ),
    );
  }

  Widget buildNotesTextField() {
    // multi line text field
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: TextFormField(
        maxLines: null,
        decoration: InputDecoration(
          hintText: "Notes",
          labelText: 'Notes',
        ),
        validator: (value) {
          if (value!.isEmpty) return 'Notes is required';
          return null;
        },
        onSaved: (value) {
          setState(() {
            entries['notes'] = value;
          });
        },
      ),
    );
  }

  Widget buildCharacterSectionHeader() {
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      child: Text("Characters:"),
    );
  }

  FloatingActionButton buildFAB() {
    return FloatingActionButton(
      onPressed: () async {
        addCharacterToList();
      },
      // add icon  and text
      child: Icon(Icons.add),
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
