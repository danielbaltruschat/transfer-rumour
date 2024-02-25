import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'team.dart';
import 'player.dart';
import 'queries.dart';

class SearchResults extends StatefulWidget {
  final String query;
  final int initialIndex;
  const SearchResults({required this.query, required this.initialIndex});

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  late int? _currentIndex = widget.initialIndex;

  @override
  Widget build(BuildContext context) {
    final futurePlayers = PlayerWidget.playerWidgetFromJsonList(
        QueryServer.searchPlayers(widget.query));
    final futureTeams = TeamWidget.teamWidgetFromJsonList(
        QueryServer.searchTeams(widget.query));

    return Column(children: [
      Container(
          height: 50,
          child: CupertinoSlidingSegmentedControl(
            thumbColor: Theme.of(context).colorScheme.primary.withOpacity(0.7),
            children: const {
              0: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("Players")), //only need padding on one side
              1: Text("Teams")
            },
            groupValue: _currentIndex,
            onValueChanged: (index) {
              if (_currentIndex != index) {
                setState(() {
                  _currentIndex = index;
                });
              }
            },
          )),
      Expanded(
          child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: _currentIndex == 0
                  ? FutureBuilder(
                      future: futurePlayers,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text("Error"),
                          );
                        } else if (snapshot.hasData) {
                          return ListView(
                            children: snapshot.data!,
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      })
                  : FutureBuilder(
                      future: futureTeams,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text("Error"),
                          );
                        } else if (snapshot.hasData) {
                          return ListView(
                            children: snapshot.data!,
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      })))
    ]);
  }
}

class TransferSearch extends SearchDelegate {
  final _isPlayer = true;

  late int _currentIndex = 0;

  void changeIndex(int index) {
    _currentIndex = index;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    //final futurePlayers = fetchPlayers(query);
    return SearchResults(query: query, initialIndex: _currentIndex);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //final futurePlayers = fetchPlayers(query);
    return SearchResults(query: query, initialIndex: _currentIndex);
  }
}
