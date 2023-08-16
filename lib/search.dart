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
  late int currentIndex = widget.initialIndex;

  @override
  Widget build(BuildContext context) {
    final futurePlayers = PlayerWidget.playerWidgetFromJsonList(
        QueryServer.searchPlayers(widget.query));
    final futureTeams = TeamWidget.teamWidgetFromJsonList(
        QueryServer.searchTeams(widget.query));

    // final futurePlayers = Future.value([
    //   PlayerWidget.fromData(
    //       playerName: "Lionel Messi",
    //       playerImage:
    //           "https://img.a.transfermarkt.technology/portrait/header/28003-1690045464.jpg?lm=1",
    //       playerID: 1,
    //       teamName: "Inter Miami CF",
    //       teamImage:
    //           "https://tmssl.akamaized.net/images/wappen/head/69261.png?lm=1573561237"),
    //   PlayerWidget.fromData(
    //       playerName: "Cristiano Ronaldo",
    //       playerImage:
    //           "https://img.a.transfermarkt.technology/portrait/header/8198-1685035469.png?lm=1",
    //       playerID: 2,
    //       teamName: "Al-Nassr FC",
    //       teamImage:
    //           "https://tmssl.akamaized.net/images/wappen/head/18544.png?lm=1683310728"),
    //   PlayerWidget.fromData(
    //       playerName: "Neymar",
    //       playerImage:
    //           "https://img.a.transfermarkt.technology/portrait/header/68290-1669394812.jpg?lm=1",
    //       playerID: 3,
    //       teamName: "Paris Saint-Germain",
    //       teamImage:
    //           "https://tmssl.akamaized.net/images/wappen/head/583.png?lm=1522312728"),
    // ]);

    // final futureTeams = Future.value([
    //   TeamWidget.fromData(
    //       teamID: 1,
    //       teamName: "Inter Miami CF",
    //       teamImage:
    //           "https://tmssl.akamaized.net/images/wappen/head/69261.png?lm=1573561237"),
    //   TeamWidget.fromData(
    //       teamID: 2,
    //       teamName: "Al-Nassr FC",
    //       teamImage:
    //           "https://tmssl.akamaized.net/images/wappen/head/18544.png?lm=1683310728"),
    //   TeamWidget.fromData(
    //       teamID: 3,
    //       teamName: "Paris Saint-Germain",
    //       teamImage:
    //           "https://tmssl.akamaized.net/images/wappen/head/583.png?lm=1522312728"),
    // ]);

    List<bool> isPlayerBoolList = [true, false];

    return Column(children: [
      Container(
          height: 50,
          child: ToggleButtons(
              children: const [Text("Players"), Text("Teams")],
              isSelected: [currentIndex == 0, currentIndex == 1],
              onPressed: (index) {
                if (currentIndex != index) {
                  setState(() {
                    currentIndex = index;
                  });
                }
              },
              borderRadius: BorderRadius.circular(5),
              constraints: const BoxConstraints(
                minHeight: 40.0,
                minWidth: 80.0,
              ))),
      Expanded(
          child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: isPlayerBoolList[currentIndex]
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
  final isPlayer = true;

  late int currentIndex = 0;

  void changeIndex(int index) {
    currentIndex = index;
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
    return SearchResults(query: query, initialIndex: currentIndex);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //final futurePlayers = fetchPlayers(query);
    return SearchResults(query: query, initialIndex: currentIndex);
  }
}
