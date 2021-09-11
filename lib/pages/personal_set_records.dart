import 'package:flutter/material.dart';

class PersonalSetRecords extends StatefulWidget {
  final db;

  const PersonalSetRecords({Key? key, this.db}) : super(key: key);

  @override
  _PersonalSetRecordsState createState() => _PersonalSetRecordsState();
}

class _PersonalSetRecordsState extends State<PersonalSetRecords> {
  Widget buildBody() {
    return Container(
      child: Text('PersonalSetRecords'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: buildBody(),
      ),
    );
  }
}
