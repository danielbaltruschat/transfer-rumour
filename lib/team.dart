import 'package:flutter/material.dart';
import 'star_button.dart';
import 'decoration.dart';

class Team {
  final String teamName;
  final String? teamImage;
  final int teamID;

  const Team(
      {required this.teamName, required this.teamImage, required this.teamID});

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      teamName: json['team_name'],
      teamImage: json['logo_image'],
      teamID: json['team_id'],
    );
  }
}

class TeamWidgetUnboxed extends StatelessWidget {
  final Team team;

  const TeamWidgetUnboxed({required this.team});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Image.network(team.teamImage ??
          "https://tmssl.akamaized.net/images/wappen/homepageWappen150x150/515.png?lm=1456997255"),
      const SizedBox(width: 20),
      FittedBox(
          child: Text(team.teamName,
              style:
                  const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)))
    ]));
  }
}

class TeamWidget extends StatelessWidget {
  final Team team;

  const TeamWidget({required this.team});

  factory TeamWidget.fromData({
    required String teamName,
    required String teamImage,
    required int teamID,
  }) =>
      TeamWidget(
          team: Team(teamName: teamName, teamImage: teamImage, teamID: teamID));

  static Future<List<Team>> teamFromJsonList(
      Future<List<Map<String, dynamic>>> json) async {
    final teams = await json;
    return teams.map((team) => Team.fromJson(team)).toList();
  }

  static Future<List<TeamWidget>> teamWidgetFromJsonList(
      Future<List<Map<String, dynamic>>> json) async {
    final teams = await json;
    return teams.map((team) => TeamWidget(team: Team.fromJson(team))).toList();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/team', arguments: team);
        },
        child: DecoratedContainerItem(
          aspectRatio: 6,
          child: Stack(children: [
            Align(
                alignment: Alignment.topRight,
                child: FavouriteButtonSaveLocally(
                  valueToSave: team.teamID.toString(),
                  saveKey: "favourite_teams",
                )),
            Center(
                child: Row(children: [
              TeamWidgetUnboxed(team: team),
              const SizedBox(width: 50)
            ]))
          ]),
        ));
  }
}
