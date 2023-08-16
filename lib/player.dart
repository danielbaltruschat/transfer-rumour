import 'package:flutter/material.dart';
import 'star_button.dart';

class Player {
  final String playerName;
  final String playerImage;
  final int playerID;
  final String teamName;
  final String? teamImage;

  const Player(
      {required this.playerName,
      required this.playerImage,
      required this.playerID,
      required this.teamName,
      required this.teamImage});

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      playerName: json['player_name'],
      playerImage: json['player_image'],
      playerID: json['player_id'],
      teamName: json['current_team_name'],
      teamImage: json['current_team_logo'],
    );
  }
}

class PlayerWidget extends StatelessWidget {
  final Player player;

  const PlayerWidget({required this.player});

  factory PlayerWidget.fromData({
    required String playerName,
    required String playerImage,
    required int playerID,
    required String teamName,
    required String teamImage,
  }) =>
      PlayerWidget(
          player: Player(
              playerName: playerName,
              playerImage: playerImage,
              playerID: playerID,
              teamName: teamName,
              teamImage: teamImage));

  static Future<List<Player>> playerFromJsonList(
      Future<List<Map<String, dynamic>>> json) async {
    final players = await json;
    return players.map((player) => Player.fromJson(player)).toList();
  }

  static Future<List<PlayerWidget>> playerWidgetFromJsonList(
      Future<List<Map<String, dynamic>>> json) async {
    final players = await json;
    return players
        .map((player) => PlayerWidget(player: Player.fromJson(player)))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/player', arguments: [
            player.playerName,
            player.playerImage,
            player.playerID.toString()
          ]);
        },
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: Stack(children: [
            Align(
                alignment: Alignment.topRight,
                child: FavouriteButtonSaveLocally(
                  valueToSave: player.playerID.toString(),
                  saveKey: "favourite_players",
                )),
            Center(
                child: Column(children: [
              Image.network(player.playerImage, height: 70),
              Text(player.playerName),
            ]))
          ]),
        ));
  }
}
