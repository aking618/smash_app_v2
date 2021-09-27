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
            },
          ),
          Text(
            widget.tournament.tournamentName,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
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
            Text('${widget.tournament.legalStages['starterStages']}'),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Counterpick Stages', style: TextStyle(fontSize: 16)),
            Text('${widget.tournament.legalStages['counterpickStages']}'),
          ],
        ),
      ],
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
