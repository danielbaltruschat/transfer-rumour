import 'package:flutter/material.dart';
import 'star_button.dart';
import 'decoration.dart';

class Transfer {
  final String player;
  final String currentTeam;
  final String rumouredTeam;
  final int transferID;
  final int timestamp;
  final String? playerImage;
  final String? currentTeamImage;
  final String? rumouredTeamImage;
  final String? playerFlag;

  const Transfer(
      {required this.player,
      required this.currentTeam,
      required this.rumouredTeam,
      required this.transferID,
      required this.timestamp,
      required this.playerImage,
      required this.currentTeamImage,
      required this.rumouredTeamImage,
      required this.playerFlag});

  factory Transfer.fromJson(Map<String, dynamic> json) {
    return Transfer(
        player: json['player_name'],
        currentTeam: json['current_team_name'],
        rumouredTeam: json['rumoured_team_name'],
        transferID: json['transfer_id'],
        timestamp: json['latest_timestamp'],
        playerImage: json['player_image'],
        currentTeamImage: json['current_team_logo'],
        rumouredTeamImage: json['rumoured_team_logo'],
        playerFlag: json['nation_flag_image']);
  }
}

class PlayerFace extends StatelessWidget {
  final imageLink;
  final flagLink;

  const PlayerFace({required this.imageLink, required this.flagLink});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 0.75,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(imageLink),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Theme.of(context).colorScheme.onSurface,
                        width: 1),
                    image: DecorationImage(
                        fit: BoxFit.cover, image: NetworkImage(flagLink))),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                    // maxWidth: 30,
                    // maxHeight: 30,
                  ),
                ),
              ),
            )
          ],
        ));
    // return Stack(
    //   children: [
    //     Container(
    //       decoration: BoxDecoration(
    //           borderRadius: BorderRadius.circular(20),
    //           image: DecorationImage(
    //               fit: BoxFit.scaleDown, image: NetworkImage(imageLink))),
    //     ),
    //     Positioned(
    //       bottom: 0,
    //       right: 0,
    //       child: Container(
    //         decoration: BoxDecoration(
    //             shape: BoxShape.circle,
    //             border: Border.all(color: Colors.white, width: 2),
    //             image: DecorationImage(
    //                 fit: BoxFit.cover, image: NetworkImage(flagLink))),
    //         child: const SizedBox(
    //           height: 30,
    //           width: 30,
    //         ),
    //       ),
    //     )
    //   ],
    // );
  }
}

class TransferWidgetUnboxed extends StatelessWidget {
  final Transfer transfer;

  const TransferWidgetUnboxed({required this.transfer});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Expanded(
          flex: 5,
          child: Column(children: [
            Expanded(
                flex: 3,
                child: PlayerFace(
                    imageLink: transfer.playerImage ??
                        "https://img.a.transfermarkt.technology/portrait/header/default.jpg?lm=1",
                    flagLink: transfer.playerFlag ??
                        "https://tmssl.akamaized.net/images/flagge/head/189.png?lm=1520611569")),
            Expanded(child: FittedBox(child: Text(transfer.player))),
          ])),
      SizedBox(width: 5),
      Expanded(
          flex: 4,
          child: Column(children: [
            Expanded(
                flex: 3,
                child: Image.network(transfer.currentTeamImage ??
                    "https://tmssl.akamaized.net/images/wappen/homepageWappen150x150/515.png?lm=1456997255")),
            Expanded(child: FittedBox(child: Text(transfer.currentTeam))),
          ])),
      Expanded(flex: 1, child: const Icon(Icons.arrow_forward)),
      Expanded(
          flex: 4,
          child: Column(children: [
            Expanded(
                flex: 3,
                child: Image.network(transfer.rumouredTeamImage ??
                    "https://tmssl.akamaized.net/images/wappen/homepageWappen150x150/515.png?lm=1456997255")),
            Expanded(child: FittedBox(child: Text(transfer.rumouredTeam))),
          ])),
      SizedBox(width: 30)
    ]);
  }
}

class TransferWidget extends StatelessWidget {
  final Transfer transfer;
  final VoidCallback? onFavourite;
  final VoidCallback? onUnFavourite;

  const TransferWidget(
      {required this.transfer, this.onFavourite, this.onUnFavourite});

  static Future<List<Transfer>> transfersFromJsonList(
      Future<List<Map<String, dynamic>>> json) async {
    final transfers = await json;
    return transfers.map((transfer) => Transfer.fromJson(transfer)).toList();
  }

  static Future<List<TransferWidget>> transferWidgetsFromJsonList(
      Future<List<Map<String, dynamic>>> json) async {
    final transfers = await json;
    return transfers
        .map(
            (transfer) => TransferWidget(transfer: Transfer.fromJson(transfer)))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/sources', arguments: transfer);
        },
        child: Padding(
            padding: const EdgeInsets.only(left: 0, right: 0, top: 0),
            child: AspectRatio(
                aspectRatio: 4,
                child: DecoratedContainerItem(
                    child: Stack(alignment: Alignment.topRight, children: [
                  // Padding(
                  //     padding: const EdgeInsets.all(5),
                  //     child:
                  TransferWidgetUnboxed(transfer: transfer),
                  FavouriteButtonSaveLocally(
                    valueToSave: transfer.transferID.toString(),
                    saveKey: "favourite_transfers",
                    onFavouriteAddition: onFavourite,
                    onUnFavouriteAddition: onUnFavourite,
                  ),
                ])))));
  }
}

List<Transfer> demoTransfers = [
  const Transfer(
      currentTeam: "Team 1",
      player: "Player 1",
      rumouredTeam: "Team 2",
      timestamp: 1600000,
      playerImage:
          "https://img.a.transfermarkt.technology/portrait/header/580195-1667830802.jpg?lm=1",
      currentTeamImage:
          "https://tmssl.akamaized.net/images/wappen/head/27.png?lm=1498251238",
      rumouredTeamImage:
          "https://tmssl.akamaized.net/images/wappen/head/27.png?lm=1498251238",
      transferID: 1,
      playerFlag:
          "https://tmssl.akamaized.net/images/flagge/head/189.png?lm=1520611569"),
  const Transfer(
      currentTeam: "Bayern Munich",
      player: "Robert Lewandowski",
      rumouredTeam: "Barcelona",
      timestamp: 1600000,
      transferID: 2,
      playerImage:
          "https://img.a.transfermarkt.technology/portrait/header/38253-1642434304.jpg?lm=1",
      currentTeamImage:
          "https://tmssl.akamaized.net/images/wappen/head/27.png?lm=1498251238",
      rumouredTeamImage:
          "https://tmssl.akamaized.net/images/wappen/head/131.png?lm=1406739548",
      playerFlag:
          "https://tmssl.akamaized.net/images/flagge/head/189.png?lm=1520611569")
];

List<Map<String, dynamic>> demoTransfersJson = [
  {
    "player": "Player 1",
    "current_team": "Team 1",
    "rumoured_team": "Team 2",
    "transfer_id": 1,
    "timestamp": 1600000,
    "player_image":
        "https://img.a.transfermarkt.technology/portrait/header/580195-1667830802.jpg?lm=1",
    "current_team_logo":
        "https://tmssl.akamaized.net/images/wappen/head/27.png?lm=1498251238",
    "rumoured_team_logo":
        "https://tmssl.akamaized.net/images/wappen/head/27.png?lm=1498251238"
  },
  {
    "player": "Robert Lewandowski",
    "current_team": "Bayern Munich",
    "rumoured_team": "Barcelona",
    "transfer_id": 2,
    "timestamp": 1600000,
    "player_image":
        "https://img.a.transfermarkt.technology/portrait/header/38253-1642434304.jpg?lm=1",
    "current_team_logo":
        "https://tmssl.akamaized.net/images/wappen/head/27.png?lm=1498251238",
    "rumoured_team_logo":
        "https://tmssl.akamaized.net/images/wappen/head/131.png?lm=1406739548"
  }
];

List<TransferWidget> demoTransferWidgets = demoTransfers
    .map((transfer) => TransferWidget(
          transfer: transfer,
        ))
    .toList();
