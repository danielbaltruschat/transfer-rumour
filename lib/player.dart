import 'package:flutter/material.dart';
import 'star_button.dart';
import 'decoration.dart';
import 'transfer.dart';
import 'app_icons_icons.dart';

class Player {
  final String playerName;
  final String? playerImage;
  final int playerID;
  final String teamName;
  final String? teamImage;
  final String? nationFlag;
  final String nationName;
  final String marketValue;
  final String playerPosition;
  final int age;

  const Player(
      {required this.playerName,
      required this.playerImage,
      required this.playerID,
      required this.teamName,
      required this.teamImage,
      required this.nationFlag,
      required this.nationName,
      required this.marketValue,
      required this.playerPosition,
      required this.age});

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      playerName: json['player_name'],
      playerImage: json['player_image'],
      playerID: json['player_id'],
      teamName: json['current_team_name'],
      teamImage: json['current_team_logo'],
      nationFlag: json['nation_flag_image'],
      nationName: json['nation_name'],
      marketValue: json['market_value'],
      playerPosition: json['player_position'],
      age: json['age'],
    );
  }
}

class PlayerWidgetUnboxed extends StatelessWidget {
  final Player player;

  const PlayerWidgetUnboxed({required this.player});

  @override
  Widget build(BuildContext context) {
    return Row(
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //Expanded(
        Flexible(
            //flex: 4,
            child: Padding(
                padding: EdgeInsets.only(right: 10),
                child: PlayerFace(
                  imageLink: player.playerImage,
                  flagLink: player.nationFlag,
                ))),
        Flexible(
            fit: FlexFit.tight,
            flex: 3,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconLabel(
                            label: player.playerName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                            icon: Icons.person),
                        IconLabel(
                            label: player.age.toString(), icon: Icons.cake)
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconLabel(
                            label: player.playerPosition,
                            icon: AppIcons.pitchIcon),
                        IconLabel(label: player.marketValue, icon: Icons.paid)
                      ]),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconLabel(label: player.teamName, icon: Icons.group),
                        IconLabel(label: player.nationName, icon: Icons.flag)
                      ])
                ])),
      ],
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
    required String nationFlag,
    required String nationName,
    required String marketValue,
    required String playerPosition,
    required int age,
  }) =>
      PlayerWidget(
          player: Player(
              playerName: playerName,
              playerImage: playerImage,
              playerID: playerID,
              teamName: teamName,
              teamImage: teamImage,
              nationFlag: nationFlag,
              nationName: nationName,
              marketValue: marketValue,
              playerPosition: playerPosition,
              age: age));

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
          Navigator.pushNamed(context, '/player', arguments: player);
        },
        child: DecoratedContainerItem(
          // elevation: 5,
          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: Stack(children: [
            Align(
                alignment: Alignment.topRight,
                child: FavouriteButtonSaveLocally(
                  valueToSave: player.playerID.toString(),
                  saveKey: "favourite_players",
                )),
            Center(
                child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Expanded(
                Expanded(child: PlayerWidgetUnboxed(player: player)),
                const SizedBox(width: 40)
              ],
            ))
          ]),
        ));
  }
}
