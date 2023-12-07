import 'package:flutter/material.dart';
import 'transfer.dart';
import 'player.dart';
import 'team.dart';
import 'queries.dart';

class FavouriteTeams extends StatelessWidget {
  const FavouriteTeams({super.key});

  @override
  Widget build(BuildContext context) {
    final Future<List<String>> favouriteTeams =
        QueryLocal.getFavourites("favourite_teams");
    return FutureBuilder(
      future: favouriteTeams,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.length == 0) {
            return Center(
              child: Text("No favourite teams"),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final teamInfo =
                  QueryServer.getTeamInfoByTeamID(snapshot.data![index]);
              return FutureBuilder(
                future: teamInfo,
                builder: (context, teamSnapshot) {
                  if (teamSnapshot.hasData) {
                    return TeamWidget.fromData(
                      teamName: teamSnapshot.data!['team_name'],
                      teamImage: teamSnapshot.data!['logo_image'],
                      teamID: teamSnapshot.data!['team_id'],
                    );
                  } else if (teamSnapshot.hasError) {
                    return Text("${teamSnapshot.error}");
                  }
                  return CircularProgressIndicator();
                },
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }
}

class FavouritePlayers extends StatelessWidget {
  const FavouritePlayers({super.key});

  @override
  Widget build(BuildContext context) {
    final Future<List<String>> favouritePlayers =
        QueryLocal.getFavourites("favourite_players");
    return FutureBuilder(
      future: favouritePlayers,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.length == 0) {
            return Center(
              child: Text("No favourite players"),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return FutureBuilder(
                future:
                    QueryServer.getPlayerInfoByPlayerID(snapshot.data![index]),
                builder: (context, playerSnapshot) {
                  if (playerSnapshot.hasData) {
                    return PlayerWidget.fromData(
                      playerName: playerSnapshot.data!['player_name'],
                      playerImage: playerSnapshot.data!['player_image'],
                      playerID: playerSnapshot.data!['player_id'],
                      teamName: playerSnapshot.data!['current_team_name'],
                      teamImage: playerSnapshot.data!['current_team_logo'],
                      nationFlag: playerSnapshot.data!['nation_flag_image'],
                      nationName: playerSnapshot.data!['nation_name'],
                      marketValue: playerSnapshot.data!['market_value'],
                      playerPosition: playerSnapshot.data!['player_position'],
                      age: playerSnapshot.data!['age'],
                    );
                  } else if (playerSnapshot.hasError) {
                    return Text("${playerSnapshot.error}");
                  }
                  return CircularProgressIndicator();
                },
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }
}

class FavouriteTransfers extends StatelessWidget {
  const FavouriteTransfers({super.key});

  @override
  Widget build(BuildContext context) {
    final Future<List<String>> favouriteTransfers =
        QueryLocal.getFavourites("favourite_transfers");
    return FutureBuilder(
      future: favouriteTransfers,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.length == 0) {
            return Center(
              child: Text("No favourite transfers"),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return FutureBuilder(
                future:
                    QueryServer.getTransferByTransferID(snapshot.data![index]),
                //Future.value(demoTransfersJson[0]),
                builder: (context, transferSnapshot) {
                  if (transferSnapshot.hasData) {
                    return TransferWidget(
                        transfer: Transfer.fromJson(transferSnapshot.data!));
                  } else if (transferSnapshot.hasError) {
                    return Text("${transferSnapshot.error}");
                  }
                  return CircularProgressIndicator();
                },
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }
}

class FavouritesBody extends StatefulWidget {
  @override
  _FavouritesBodyState createState() => _FavouritesBodyState();
}

class _FavouritesBodyState extends State<FavouritesBody> {
  //FavouritesBody({super.key});
  late int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ToggleButtons(
          children: const [Text("Transfers"), Text("Players"), Text("Teams")],
          isSelected: [currentIndex == 0, currentIndex == 1, currentIndex == 2],
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
          )),
      Expanded(
          child: AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child: currentIndex == 0
                  ? FavouriteTransfers()
                  : currentIndex == 1
                      ? FavouritePlayers()
                      : FavouriteTeams()))
    ]);
  }
}
