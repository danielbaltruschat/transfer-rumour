import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'transfer.dart';
import 'player.dart';
import 'team.dart';
import 'queries.dart';
import 'priority_queue.dart';

Future<Widget> getTransferWidget(transferID) async {
  try {
    final transfer = Transfer.fromJson(
        await QueryServer.getTransferByTransferID(transferID));
    return TransferWidget(transfer: transfer);
  } on TransferNotFoundException {
    await QueryLocal.removeFavourite("favourite_transfers", transferID);
    return const SizedBox();
  } catch (e) {
    rethrow;
  }
}

class AllFavourites extends StatelessWidget {
  const AllFavourites({super.key});

  Future<List<Widget>> getFutureWidgets() async {
    final Future<List<String>> favouriteTransfers =
        QueryLocal.getFavourites("favourite_transfers");
    final Future<List<String>> favouritePlayers =
        QueryLocal.getFavourites("favourite_players");
    final Future<List<String>> favouriteTeams =
        QueryLocal.getFavourites("favourite_teams");

    //List<Widget> favouriteWidgets = []; // Priority queue
    PriorityQueue<Widget> favouriteWidgets = PriorityQueue();
    for (String transferID in await favouriteTransfers) {
      try {
        final transferWidget = await getTransferWidget(transferID);
        favouriteWidgets.enqueue(transferWidget, 0);
      } catch (e) {
        if (e.toString() == "Transfer not found") {
          await QueryLocal.removeFavourite("favourite_transfers", transferID);
        }
      }
    }

    for (String playerID in await favouritePlayers) {
      final player =
          Player.fromJson(await QueryServer.getPlayerInfoByPlayerID(playerID));
      favouriteWidgets.enqueue(PlayerWidget(player: player), 1);
    }

    for (String teamID in await favouriteTeams) {
      final team = Team.fromJson(await QueryServer.getTeamInfoByTeamID(teamID));
      favouriteWidgets.enqueue(TeamWidget(team: team), 2);
    }

    return favouriteWidgets.getList();
  }

  @override
  Widget build(BuildContext context) {
    final Future<List<Widget>> favouriteWidgets = getFutureWidgets();

    return FutureBuilder(
        future: favouriteWidgets,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.length == 0) {
              return const Center(
                child: Text("No favourites"),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return snapshot.data![index];
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}

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
                    //QueryServer.getTransferByTransferID(snapshot.data![index]),
                    getTransferWidget(snapshot.data![index]),
                //Future.value(demoTransfersJson[0]),
                builder: (context, transferSnapshot) {
                  if (transferSnapshot.hasData) {
                    return transferSnapshot.data!;
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
  int? currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Center(
          child: CupertinoSlidingSegmentedControl(
              thumbColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.7),
              children: const {
                0: Padding(padding: EdgeInsets.all(5), child: Text("All")),
                1: Padding(
                    padding: EdgeInsets.all(5), child: Text("Transfers")),
                2: Padding(padding: EdgeInsets.all(5), child: Text("Players")),
                3: Padding(padding: EdgeInsets.all(5), child: Text("Teams"))
              },
              groupValue: currentIndex,
              onValueChanged: (int? index) {
                if (currentIndex != index) {
                  setState(() {
                    currentIndex = index;
                  });
                }
              })),
      Expanded(
          child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: currentIndex == 1
                  ? const FavouriteTransfers()
                  : currentIndex == 2
                      ? const FavouritePlayers()
                      : currentIndex == 3
                          ? const FavouriteTeams()
                          : const AllFavourites()))
    ]);
  }
}
