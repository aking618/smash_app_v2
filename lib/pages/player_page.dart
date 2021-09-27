import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smash_app/constants/background.dart';
import 'package:smash_app/services/providers.dart';
import 'package:smash_app/models/player_record.dart';
import 'package:smash_app/services/db.dart';
import 'package:sqflite/sqflite.dart';

// ignore: must_be_immutable
class PlayerPage extends ConsumerStatefulWidget {
  PlayerRecord playerRecord;
  Function onUpdate;
  PlayerPage({Key? key, required this.playerRecord, required this.onUpdate})
      : super(key: key);

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends ConsumerState<PlayerPage> {
  late Database db;
  String imageUrl = "https://www.smashbros.com/assets_v2/img/fighter/thumb_a/";
  TextEditingController _playerTagController = TextEditingController();
  TextEditingController _notesController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    db = ref.read(dbProvider);
    _playerTagController.text = widget.playerRecord.playerTag;
    _notesController.text = widget.playerRecord.notes;
  }

  @override
  void dispose() {
    _playerTagController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Widget buildBody() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            buildBackButton(),
            buildPlayerTag(),
            buildHorizontalDivider(),
            buildSetCount(),
            buildHorizontalDivider(),
            buildCharacterList(),
            buildHorizontalDivider(),
            buildNotes(),
          ],
        ),
      ),
    );
  }

  Widget buildBackButton() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget buildPlayerTag() {
    return Container(
      child: _isEditing
          ? TextField(
              controller: _playerTagController,
              decoration: InputDecoration(
                labelText: "Player Tag",
                border: OutlineInputBorder(),
              ),
            )
          : Text(
              widget.playerRecord.playerTag,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
    );
  }

  Widget buildHorizontalDivider() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Divider(
        color: Colors.black,
        height: 1,
      ),
    );
  }

  Widget buildSetCount() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            "Set Count: ${widget.playerRecord.wins} - ${widget.playerRecord.losses}",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          buildAddIconButton(),
          buildSubIconButton(),
          buildResetIconButton(),
        ],
      ),
    );
  }

  Column buildSubIconButton() {
    return Column(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: () async {
            await updatePlayerLoss();
          },
        ),
        Text("Add Loss"),
      ],
    );
  }

  Column buildAddIconButton() {
    return Column(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () async {
            await updatePlayerWin();
          },
        ),
        Text("Add Win"),
      ],
    );
  }

  Column buildResetIconButton() {
    return Column(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () async {
            await updatePlayerReset();
          },
        ),
        Text("Reset"),
      ],
    );
  }

  Widget buildCharacterList() {
    return Container(
        margin: EdgeInsets.only(top: 20), child: buildCharacterCards());
  }

  Widget buildCharacterCards() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: widget.playerRecord.characters.map((character) {
        return Container(
          width: MediaQuery.of(context).size.width *
              0.9 /
              widget.playerRecord.characters.length,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              CachedNetworkImage(
                imageUrl: imageUrl + character.filePath + ".png",
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              Text(
                character.displayName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget buildNotes() {
    return Container(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      margin: EdgeInsets.only(top: 20),
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
        color: Colors.black87,
      ),
      child: _isEditing
          ? TextField(
              controller: _notesController,
              maxLines: null,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Notes",
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Notes:",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.playerRecord.notes,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
    );
  }

  FloatingActionButton getFAB() {
    return _isEditing
        ? FloatingActionButton(
            child: Icon(Icons.check),
            onPressed: () async {
              await updatePlayerRecord();
            },
          )
        : FloatingActionButton(
            child: Icon(Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = true;
              });
            },
          );
  }

  Future<void> updatePlayerRecord() async {
    if (_playerTagController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Player Tag cannot be empty",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    if (_notesController.text.isEmpty) {
      _notesController.text = "";
    }

    PlayerRecord updatedPlayerRecord = PlayerRecord(
      playerTag: _playerTagController.text,
      notes: _notesController.text,
      characters: widget.playerRecord.characters,
      wins: widget.playerRecord.wins,
      losses: widget.playerRecord.losses,
      id: widget.playerRecord.id,
    );
    await SmashAppDatabase().updatePlayerRecord(db, updatedPlayerRecord);

    widget.onUpdate(updatedPlayerRecord);

    setState(() {
      _isEditing = false;
      widget.playerRecord = updatedPlayerRecord;
    });
  }

  Future<void> updatePlayerLoss() async {
    PlayerRecord updatedPlayerRecord = PlayerRecord(
      playerTag: _playerTagController.text,
      notes: _notesController.text,
      characters: widget.playerRecord.characters,
      wins: widget.playerRecord.wins,
      losses: widget.playerRecord.losses + 1,
      id: widget.playerRecord.id,
    );
    await SmashAppDatabase().updatePlayerRecord(db, updatedPlayerRecord);

    widget.onUpdate(updatedPlayerRecord);

    setState(() {
      widget.playerRecord = updatedPlayerRecord;
    });
  }

  Future<void> updatePlayerWin() async {
    PlayerRecord updatedPlayerRecord = PlayerRecord(
      playerTag: _playerTagController.text,
      notes: _notesController.text,
      characters: widget.playerRecord.characters,
      wins: widget.playerRecord.wins + 1,
      losses: widget.playerRecord.losses,
      id: widget.playerRecord.id,
    );
    await SmashAppDatabase().updatePlayerRecord(db, updatedPlayerRecord);

    widget.onUpdate(updatedPlayerRecord);

    setState(() {
      widget.playerRecord = updatedPlayerRecord;
    });
  }

  Future<void> updatePlayerReset() async {
    PlayerRecord updatedPlayerRecord = PlayerRecord(
      playerTag: _playerTagController.text,
      notes: _notesController.text,
      characters: widget.playerRecord.characters,
      wins: 0,
      losses: 0,
      id: widget.playerRecord.id,
    );
    await SmashAppDatabase().updatePlayerRecord(db, updatedPlayerRecord);

    widget.onUpdate(updatedPlayerRecord);

    setState(() {
      widget.playerRecord = updatedPlayerRecord;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Scaffold(
        body: buildBody(),
        floatingActionButton: getFAB(),
      ),
    );
  }
}
