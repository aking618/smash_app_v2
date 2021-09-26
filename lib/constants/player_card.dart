import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:smash_app/models/player_record.dart';
import 'package:smash_app/pages/player_page.dart';
import 'package:smash_app/services/db.dart';
import 'package:sqflite/sqflite.dart';

class PlayerCard extends StatefulWidget {
  PlayerRecord playerRecord;
  final Future<void> Function(int id) removeRecord;
  PlayerCard({Key? key, required this.playerRecord, required this.removeRecord})
      : super(key: key);

  @override
  _PlayerCardState createState() => _PlayerCardState();
}

class _PlayerCardState extends State<PlayerCard> {
  String imageUrl = "https://www.smashbros.com/assets_v2/img/fighter/thumb_a/";

  Widget buildPlayerTag() {
    return Text(
      widget.playerRecord.playerTag,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget buildCharacters() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: widget.playerRecord.characters.map((character) {
          return Container(
            child: Column(
              children: <Widget>[
                CircleAvatar(
                  child: CachedNetworkImage(
                    placeholder: (context, url) => CircularProgressIndicator(),
                    imageUrl: imageUrl + character.filePath + ".png",
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                  ),
                ),
                Text(character.displayName),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget buildSetCount() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          Text(
            "Set Count",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${widget.playerRecord.wins} - ${widget.playerRecord.losses}',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNotes() {
    return Container(
        margin: EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Text(
              "Notes",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.playerRecord.notes,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ));
  }

  Align buildDeleteButton() {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
          icon: Icon(Icons.delete_forever_outlined),
          onPressed: () {
            showDeleteModal();
          }),
    );
  }

  void showDeleteModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Player Record?"),
          content: Text(
              "Are you sure you want to delete this player record? This action is permanent."),
          actions: buildDeleteDialogOptions(),
        );
      },
    );
  }

  List<Widget> buildDeleteDialogOptions() {
    return [
      TextButton(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      TextButton(
        child: Text("Delete"),
        onPressed: () async {
          await widget.removeRecord(widget.playerRecord.id);
          Navigator.of(context).pop();
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Card(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Column(
                  children: <Widget>[
                    buildPlayerTag(),
                    buildCharacters(),
                    buildSetCount(),
                    buildNotes(),
                  ],
                ),
                buildDeleteButton(),
              ],
            ),
          ),
        ),
        onTap: () {
          //TODO: Add functionality to open player profile
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlayerPage(
                playerRecord: widget.playerRecord,
                onUpdate: updatePlayerRecord,
              ),
            ),
          );
        });
  }

  void updatePlayerRecord(PlayerRecord playerRecord) {
    setState(() {
      widget.playerRecord = playerRecord;
    });
  }
}
