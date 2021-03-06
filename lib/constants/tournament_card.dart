import 'package:flutter/material.dart';
import 'package:smash_app/models/tournament.dart';
import 'package:smash_app/pages/tournament_screen.dart';

class TournamentCard extends StatefulWidget {
  final Tournament tournament;
  final Function deleteTournament;
  const TournamentCard(
      {Key? key, required this.tournament, required this.deleteTournament})
      : super(key: key);

  @override
  _TournamentCardState createState() => _TournamentCardState();
}

class _TournamentCardState extends State<TournamentCard> {
  Widget buildTournamentHeaderRow() {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // TODO: implement edit tournament
              // Naviage to edit tournament screen
              // and populate with tournament data
            },
          ),
          RichText(
            text: TextSpan(
              text: '${widget.tournament.tournamentName}',
              style: TextStyle(
                fontSize: 20.0,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              // TODO: implement delete tournament
              await widget.deleteTournament(widget.tournament);
            },
          ),
        ],
      ),
    );
  }

  Widget buildMatchInfo() {
    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Stock Count', style: TextStyle(fontSize: 16)),
              Text('${widget.tournament.stockCount}'),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Time', style: TextStyle(fontSize: 16)),
              Text('${widget.tournament.timeInMinutes}'),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Set Lengths', style: TextStyle(fontSize: 16)),
              Text('${widget.tournament.setLengths}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildStages() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Starter Stages', style: TextStyle(fontSize: 16)),
            ...widget.tournament.legalStages['starterStages'].map((stage) {
              return Text(
                " - " + stage,
                overflow: TextOverflow.ellipsis,
              );
            }).toList(),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Counterpick Stages', style: TextStyle(fontSize: 16)),
            ...widget.tournament.legalStages['counterpickStages'].map((stage) {
              return Text(
                " - " + stage,
                overflow: TextOverflow.ellipsis,
              );
            }).toList(),
          ],
        ),
      ],
    );
  }

  Widget buildHorizontalDivider(double margin) {
    return Container(
      margin: EdgeInsets.only(bottom: margin),
      child: Divider(
        color: Colors.white70,
        height: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              buildTournamentHeaderRow(),
              buildMatchInfo(),
              buildHorizontalDivider(4.0),
              buildStages(),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                TournamentScreen(tournament: widget.tournament),
          ),
        );
      },
    );
  }
}
