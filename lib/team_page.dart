import 'package:flutter/material.dart';
import 'transfer.dart';
import 'team.dart';
import 'queries.dart';

class TeamPage extends StatelessWidget {
  const TeamPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final teamData =
    //     ModalRoute.of(context)!.settings.arguments as List<dynamic>;

    final team = ModalRoute.of(context)!.settings.arguments as Team;
    final Future<List<TransferWidget>> futureTransferWidgets =
        TransferWidget.transferWidgetsFromJsonList(
            QueryServer.getTransfersByTeamID(team.teamID));
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.width * (1 / 6),
          flexibleSpace: SafeArea(
              child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Row(children: [
                    Expanded(child: TeamWidgetUnboxed(team: team)),
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
            return Center(child: const CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
