import 'package:flutter/material.dart';
import 'package:smash_app/constants/background.dart';
import 'package:sqflite/sqflite.dart';

class AddTournament extends StatefulWidget {
  final Database db;
  final Function createTournament;
  const AddTournament(
      {Key? key, required this.db, required this.createTournament})
      : super(key: key);

  @override
  _AddTournamentState createState() => _AddTournamentState();
}

class _AddTournamentState extends State<AddTournament> {
  final _formKey = GlobalKey<FormState>();

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
      onPressed: () {},
    );
  }

  Widget buildForm() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Scaffold(
        body: buildBody(context),
      ),
    );
  }
}
