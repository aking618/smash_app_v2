import 'package:flutter/material.dart';
import 'package:smash_app/constants/background.dart';
import 'package:smash_app/constants/constants.dart';
import 'package:smash_app/models/player_record.dart';
import 'package:smash_app/pages/add_person_record.dart';
import 'package:smash_app/services/db.dart';

class PersonalSetRecords extends StatefulWidget {
  final db;

  const PersonalSetRecords({Key? key, this.db}) : super(key: key);

  @override
  _PersonalSetRecordsState createState() => _PersonalSetRecordsState();
}

class _PersonalSetRecordsState extends State<PersonalSetRecords> {
  final _formKey = GlobalKey<FormState>();
  String? _searchText;
  List<PlayerRecord> _records = [];
  List<PlayerRecord> _filteredRecords = [];

  @override
  void initState() {
    super.initState();
    _searchText = '';
    getRecords();
  }

  Future<void> getRecords() async {
    var records = await SmashAppDatabase().getPlayerRecordList(widget.db);
    records.isEmpty
        ? print('No records found')
        : setState(() {
            _records = records;
            _filteredRecords = records;
          });
  }

  Widget buildBody() {
    return Container(
      child: Column(
        children: [
          buildHeader(),
          buildSearchBar(),
          buildList(),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //back button
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Text(
            'Personal Set Records',
            style: TextStyle(fontSize: 20),
          ),
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () {
              // show help dialog
            },
          ),
        ],
      ),
    );
  }

  Widget buildSearchBar() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: 'Search by Player Tag',
          prefixIcon: Icon(Icons.search),
        ),
        onChanged: (text) {
          setState(() {
            _searchText = text;
            _filteredRecords = _records.where((record) {
              // ignore case
              var tag = record.playerTag.toLowerCase();
              var searchText = _searchText!.toLowerCase();
              return tag.contains(searchText);
            }).toList();
          });
        },
      ),
    );
  }

  Widget buildList() {
    return Expanded(
      child: _filteredRecords.isEmpty
          ? Text("No Records")
          : ListView.builder(
              itemCount: _filteredRecords.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_filteredRecords[index].playerTag),
                  onTap: () {
                    // editRecord(_filteredRecords[index]);
                  },
                );
              },
            ),
    );
  }

  Widget buildFAB() {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddPersonalRecord(db: widget.db)),
        ).then((value) async {
          await getRecords();
        });
      },
    );
  }

  Widget buildAddRecord() {
    // move this to a new page
    return Container(
      padding: EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Player Tag',
              ),
              onSaved: (tag) {
                // save tag
              },
              validator: (tag) {
                if (tag!.isEmpty)
                  return 'Player Tag cannot be empty';
                else
                  return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Scaffold(
        body: buildBody(),
        floatingActionButton: buildFAB(),
      ),
    );
  }
}
