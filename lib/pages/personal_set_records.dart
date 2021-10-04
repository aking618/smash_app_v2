import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smash_app/constants/background.dart';
import 'package:smash_app/constants/player_card.dart';
import 'package:smash_app/dialogs/dialog_page_enum.dart';
import 'package:smash_app/dialogs/help_dialog.dart';
import 'package:smash_app/models/user.dart';
import 'package:smash_app/services/providers.dart';
import 'package:smash_app/models/player_record.dart';
import 'package:smash_app/pages/add_person_record.dart';
import 'package:smash_app/services/db.dart';
import 'package:smash_app/toasts/custom_toast.dart';
import 'package:sqflite/sqflite.dart';

class PersonalSetRecords extends ConsumerStatefulWidget {
  const PersonalSetRecords({Key? key}) : super(key: key);

  @override
  _PersonalSetRecordsState createState() => _PersonalSetRecordsState();
}

class _PersonalSetRecordsState extends ConsumerState<PersonalSetRecords> {
  final _formKey = GlobalKey<FormState>();
  String? _searchText;
  List<PlayerRecord> _records = [];
  List<PlayerRecord> _filteredRecords = [];
  late Database db;

  @override
  void initState() {
    super.initState();
    _searchText = '';
    db = ref.read(dbProvider);

    getRecords();
  }

  Future<void> getRecords() async {
    var records = await SmashAppDatabase().getPlayerRecordList(db);
    records.isEmpty
        ? resetState()
        : setState(() {
            _records = records;
            _filteredRecords = records;
          });
  }

  void resetState() {
    print('No records found');
    setState(() {
      _records = [];
      _filteredRecords = [];
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
              CustomDialog()
                  .showHelpDialog(context, DialogPage.personal_set_records);
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
                return PlayerCard(
                    playerRecord: _filteredRecords[index],
                    removeRecord: removeRecord);
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
              builder: (context) => AddPersonalRecord(
                    playerId: _records.length + 1,
                  )),
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

  Future<void> removeRecord(int id) async {
    await SmashAppDatabase().deletePlayerRecord(db, id);
    await getRecords();
  }

  @override
  Widget build(BuildContext context) {
    User? user = ref.watch(userProvider).state;
    CustomToast().show(user.toString(), ToastType.info);

    return Background(
      child: Scaffold(
        body: buildBody(),
        floatingActionButton: buildFAB(),
      ),
    );
  }
}
