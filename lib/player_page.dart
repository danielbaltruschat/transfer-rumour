import 'package:flutter/material.dart';
import 'transfer.dart';
import 'queries.dart';
import 'player.dart';

class PlayerPage extends StatelessWidget {
  const PlayerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final player = ModalRoute.of(context)!.settings.arguments as Player;

    final Future<List<TransferWidget>> futureTransferWidgets =
        TransferWidget.transferWidgetsFromJsonList(
            QueryServer.getTransfersByPlayerID(player.playerID));

    // final futureTransferWidgets = Future.value([
    //   const TransferWidget(
    //       transfer: Transfer(
    //     currentTeam: "Bayern Munich",
    //     player: "Jamal Musiala",
    //     rumouredTeam: "Paris Saint-Germain",
    //     timestamp: 1600000,
    //     playerImage:
    //         "https://img.a.transfermarkt.technology/portrait/header/580195-1667830802.jpg?lm=1",
    //     currentTeamImage:
    //         "https://tmssl.akamaized.net/images/wappen/head/27.png?lm=1498251238",
    //     rumouredTeamImage:
    //         "https://tmssl.akamaized.net/images/wappen/head/27.png?lm=1498251238",
    //     transferID: 1,
    //   )),
    //   const TransferWidget(
    //       transfer: Transfer(
    //     currentTeam: "Bayern Munich",
    //     player: "Robert Lewandowski",
    //     rumouredTeam: "Barcelona",
    //     timestamp: 1600000,
    //     transferID: 2,
    //     playerImage:
    //         "https://img.a.transfermarkt.technology/portrait/header/38253-1642434304.jpg?lm=1",
    //     currentTeamImage:
    //         "https://tmssl.akamaized.net/images/wappen/head/27.png?lm=1498251238",
    //     rumouredTeamImage:
    //         "https://tmssl.akamaized.net/images/wappen/head/131.png?lm=1406739548",
    //   ))
    // ]);
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.width * 0.25,
          flexibleSpace: SafeArea(
              child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Row(children: [
                    const SizedBox(width: 50),
                    Expanded(child: PlayerWidgetUnboxed(player: player)),
                  ])))),
      body: FutureBuilder<List<TransferWidget>>(
        future: futureTransferWidgets,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return snapshot.data![index];
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
