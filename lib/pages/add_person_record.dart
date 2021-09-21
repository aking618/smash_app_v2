import 'package:flutter/material.dart';
import 'package:smash_app/constants/background.dart';
import 'package:smash_app/models/rcg_character.dart';
import 'package:smash_app/services/db.dart';
import 'package:sqflite/sqflite.dart';

class AddPersonalRecord extends StatefulWidget {
  final Database db;
  const AddPersonalRecord({Key? key, required this.db}) : super(key: key);

  @override
  _AddPersonalRecordState createState() => _AddPersonalRecordState();
}

class _AddPersonalRecordState extends State<AddPersonalRecord> {
  final _formKey = GlobalKey<FormState>();
  List<RCGCharacter> _characters = [];
  List<Widget> _characterDropdowns = [];
  List<RCGCharacter> chosenCharacters = [];
  Map<String, dynamic> entries = {};

  @override
  void initState() {
    super.initState();
    getCharacters();
  }

  Future<void> getCharacters() async {
    final characters = await SmashAppDatabase().getRCGCharacterList(widget.db);
    setState(() {
      _characters = characters.isEmpty ? [] : characters;
    });
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
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              // add personal record
              Navigator.pop(context);
            },
          ),
        ],
      ),
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
            buildWinCountTextField(),
            buildLostCountTextField(),
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
          // save value
        });
  }

  addCharacterToList() {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _characterDropdowns = List.from(_characterDropdowns)
        ..add(characterDropDown(_characterDropdowns.length));
    });
  }

  Widget characterDropDown(length) {
    return DropdownButtonFormField<RCGCharacter>(
      value: entries['character'] ?? _characters[0],
      items: _characters.map((character) {
        return DropdownMenuItem<RCGCharacter>(
          value: character,
          child: Text(character.displayName),
        );
      }).toList(),
    );
  }

  TextFormField buildLostCountTextField() {
    return TextFormField(
      initialValue: '0',
      decoration: InputDecoration(
        hintText: "Losses",
        labelText: 'Lose Count',
      ),
      validator: (value) {
        if (value!.isEmpty) return 'Enter a valid number';
        return null;
      },
      onSaved: (value) {
        // save value
      },
      keyboardType: TextInputType.number,
    );
  }

  TextFormField buildWinCountTextField() {
    return TextFormField(
      initialValue: '0',
      decoration: InputDecoration(
        hintText: "Wins",
        labelText: "Win Count",
      ),
      validator: (value) {
        if (value!.isEmpty) return 'Enter a valid number';
        return null;
      },
      onSaved: (value) {
        // save value
      },
      keyboardType: TextInputType.number,
    );
  }

  Widget buildNotesTextField() {
    return Container();
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
