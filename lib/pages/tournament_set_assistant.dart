import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smash_app/constants/background.dart';
import 'package:smash_app/constants/tournament_card.dart';
import 'package:smash_app/dialogs/dialog_page_enum.dart';
import 'package:smash_app/dialogs/help_dialog.dart';
import 'package:smash_app/pages/add_tournament.dart';
import 'package:smash_app/services/providers.dart';
import 'package:smash_app/models/tournament.dart';
import 'package:smash_app/services/db.dart';
import 'package:sqflite/sqflite.dart';

class TournamentAssistant extends ConsumerStatefulWidget {
  const TournamentAssistant({Key? key}) : super(key: key);

  @override
  _TournamentAssistantState createState() => _TournamentAssistantState();
}

class _TournamentAssistantState extends ConsumerState<TournamentAssistant> {
  late Database _db;
  Tournament? selectedTournament;
  List<Tournament> tournaments = [];
  String? _searchText;
  List<Tournament> filteredTournaments = [];

  @override
  void initState() {
    super.initState();
    _searchText = '';
    _db = ref.read(dbProvider);
    loadTournaments();
  }

  Future<void> loadTournaments() async {
    final tournaments = await SmashAppDatabase().getTournamentList(_db);
    if (tournaments.isEmpty) {
      print('No tournaments found');
      return;
    }
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
              CustomDialog()
                  .showHelpDialog(context, DialogPage.tournament_set_assistant);
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
                return TournamentCard(
                  tournament: filteredTournaments[index],
                  deleteTournament: deleteTournament,
                );
              },
            ),
    );
  }

  Future<void> deleteTournament(Tournament tournament) async {
    await SmashAppDatabase().deleteTournament(_db, tournament.id);

    setState(() {
      tournaments = List.from(tournaments)..remove(tournament);
      filteredTournaments = List.from(filteredTournaments)..remove(tournament);
    });
  }

  // TODO: build FAB to add tournament
  Widget buildFAB() {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTournament(
                tournamentId: tournaments.length + 1,
              ),
            )).then((tourneyMap) async {
          await loadTournaments();
        });
      },
    );
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
