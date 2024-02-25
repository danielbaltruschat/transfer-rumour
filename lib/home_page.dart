import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'transfer.dart';
import 'search.dart';
import 'favourites.dart';
import 'queries.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool isHome = true;
  late Future<List<TransferWidget>> futureTransferWidgets =
      getTransferWidgets();

  Future<List<TransferWidget>> getTransferWidgets() async {
    Future<List<Map<String, dynamic>>> transferList =
        QueryServer.getAllTransfers();
    return TransferWidget.transferWidgetsFromJsonList(transferList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(widget.title,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.w700)),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: TransferSearch());
              },
              icon: Icon(Icons.search))
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: isHome
            ? RefreshIndicator(
                onRefresh: () {
                  setState(() {
                    futureTransferWidgets = getTransferWidgets();
                  });
                  return futureTransferWidgets;
                },
                child: FutureBuilder<List<TransferWidget>>(
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
                      return const Center(
                          child: CircularProgressIndicator.adaptive());
                    }
                  },
                ))
            : FavouritesBody(),
      ),
      bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Padding(
              padding: EdgeInsets.all(10),
              child: SafeArea(
                  child: GNav(
                hoverColor: Colors.grey[700]!, // tab button hover color
                haptic: true, // haptic feedback
                tabBorderRadius: 15,
                curve: Curves.easeIn, // tab animation curves
                duration: Duration(milliseconds: 300), // tab animation duration
                gap: 5, // the tab button gap between icon and text
                color: Theme.of(context)
                    .colorScheme
                    .onSurface, // unselected icon color
                activeColor: Theme.of(context)
                    .colorScheme
                    .primary, // selected icon and text color
                iconSize: 24, // tab button icon size
                tabBackgroundColor: Theme.of(context)
                    .colorScheme
                    .primary
                    .withOpacity(0.2), // selected tab background color
                padding: EdgeInsets.symmetric(
                    horizontal: 50, vertical: 5), // navigation bar padding
                tabs: [
                  const GButton(
                    icon: Icons.home,
                    text: 'Home',
                  ),
                  const GButton(
                    icon: Icons.star,
                    text: 'Favourites',
                  ),
                ],
                onTabChange: (index) {
                  setState(() {
                    if (index == 0) {
                      isHome = true;
                    } else {
                      isHome = false;
                    }
                  });
                },
              )))),
    );
  }
}
