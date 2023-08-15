import 'package:flutter/material.dart';
import 'transfer.dart';
import 'queries.dart';

class TeamPage extends StatelessWidget {
  const TeamPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final teamData = ModalRoute.of(context)!.settings.arguments as List<String>;
    //final Future<List<TransferWidget>> futureTransferWidgets = TransferWidget.transferWidgetFromJsonList(QueryServer.getTransfersByTeamID(teamData[0]));
    final futureTransferWidgets = Future.value([
      const TransferWidget(
          transfer: Transfer(
        currentTeam: "Bayern Munich",
        player: "Jamal Musiala",
        rumouredTeam: "Paris Saint-Germain",
        timestamp: 1600000,
        playerImage:
            "https://img.a.transfermarkt.technology/portrait/header/580195-1667830802.jpg?lm=1",
        currentTeamImage:
            "https://tmssl.akamaized.net/images/wappen/head/27.png?lm=1498251238",
        rumouredTeamImage:
            "https://tmssl.akamaized.net/images/wappen/head/27.png?lm=1498251238",
        transferID: 1,
      )),
      const TransferWidget(
          transfer: Transfer(
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
      ))
    ]);
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 70,
          flexibleSpace: Card(
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: SafeArea(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    // decoration: BoxDecoration(
                    //   border: Border.all(width: 1),
                    //   borderRadius: BorderRadius.circular(20), //<-- SEE HERE
                    // ),
                    padding: EdgeInsets.only(right: 15, left: 10, bottom: 5),
                    child: Image.network(teamData[1])),
                Text(teamData[0],
                    style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'Helvetica',
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ],
            )),
          )),
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
