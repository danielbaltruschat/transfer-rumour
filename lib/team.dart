import 'package:flutter/material.dart';
import 'star_button.dart';

class Team {
  final String teamName;
  final String teamImage;
  final int teamID;

  const Team(
      {required this.teamName, required this.teamImage, required this.teamID});

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      teamName: json['team_name'],
      teamImage: json['team_logo'],
      teamID: json['team_id'],
    );
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
          Navigator.pushNamed(context, '/team', arguments: [
            team.teamName,
            team.teamImage,
            team.teamID.toString()
          ]);
        },
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: Stack(children: [
            Align(
                alignment: Alignment.topRight,
                child: FavouriteButtonSaveLocally(
                  valueToSave: team.teamID.toString(),
                  saveKey: "favourite_teams",
                )),
            Center(
                child: Column(children: [
              Image.network(team.teamImage, height: 70),
              Text(team.teamName),
            ]))
          ]),
        ));
  }
}
