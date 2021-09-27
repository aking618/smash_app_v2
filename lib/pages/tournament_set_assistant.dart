import 'package:flutter/material.dart';
import 'package:smash_app/constants/background.dart';
import 'package:smash_app/constants/constants.dart';
import 'package:smash_app/constants/tournament_card.dart';
import 'package:smash_app/models/tournament.dart';
import 'package:smash_app/pages/add_tournament.dart';
import 'package:smash_app/pages/tournament_screen.dart';
import 'package:smash_app/services/db.dart';

class TournamentAssistant extends StatefulWidget {
  final db;
  const TournamentAssistant({Key? key, this.db}) : super(key: key);

  @override
  _TournamentAssistantState createState() => _TournamentAssistantState();
}

class _TournamentAssistantState extends State<TournamentAssistant> {
  String? _searchText;
  List<Tournament> tournaments = [];
  List<Tournament> filteredTournaments = [];

  @override
  void initState() {
    super.initState();
    _searchText = '';
    loadTournaments();
  }

  Future<void> loadTournaments() async {
    final tournaments = await SmashAppDatabase().getTournamentList(widget.db);
    tournaments.isEmpty
        ? resetState()
        : setState(() {
            this.tournaments = tournaments;
            filteredTournaments = tournaments;
          });
  }

  void resetState() {
    setState(() {
      tournaments = [];
      filteredTournaments = [];
    });
  }

  buildBody() {
    return Container(
      child: Column(
        children: [
          buildHeader(),
          buildSearchBar(),
          buildTournamentList(),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Text(
            'Tournament Assistant',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () {
              print('Help');
            },
          ),
        ],
      ),
    );
  }

  Widget buildSearchBar() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search by Tournament Name',
          prefixIcon: Icon(Icons.search),
        ),
        onChanged: (text) {
          setState(() {
            _searchText = text;
            filteredTournaments = tournaments.where((tournament) {
              var name = tournament.tournamentName.toLowerCase();
              var searchText = _searchText!.toLowerCase();
              return name.contains(searchText);
            }).toList();
          });
        },
      ),
    );
  }

  Widget buildTournamentList() {
    return Expanded(
      child: filteredTournaments.isEmpty
          ? Text('No tournaments found')
          : ListView.builder(
              itemCount: filteredTournaments.length,
              itemBuilder: (context, index) {
                // TODO: make tournament card widget
                return TournamentCard(
                  tournament: filteredTournaments[index],
                  deleteTournament: deleteTournament,
                );
              },
            ),
    );
  }

  Future<void> createNewTournament(Map<String, dynamic> tourneyMap) async {
    tourneyMap['id'] = tournaments.length + 1;

    Tournament tournament = Tournament.fromMap(tourneyMap);

    await SmashAppDatabase().insertTournament(widget.db, tournament);

    setState(() {
      tournaments = List.from(tournaments)..add(tournament);
      filteredTournaments = List.from(filteredTournaments)..add(tournament);
    });
  }

  Future<void> deleteTournament(Tournament tournament) async {
    await SmashAppDatabase().deleteTournament(widget.db, tournament.id);

    setState(() {
      tournaments = List.from(tournaments)..remove(tournament);
      filteredTournaments = List.from(filteredTournaments)..remove(tournament);
    });
  }

  // TODO: build FAB to add tournament
  Widget buildFloatingActionButton() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Background(
        child: Scaffold(
          body: buildBody(),
          floatingActionButton: buildFAB(),
        ),
      ),
    );
  }
}
