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
          } else {
            return Center(child: const CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
