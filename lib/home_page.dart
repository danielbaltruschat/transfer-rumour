import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'transfer.dart';
import 'search.dart';
import 'favourites.dart';
import 'queries.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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
    // This method is rerun every time setState is called, for instance as done
    // by the _goToSources method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        backgroundColor: Theme.of(context).colorScheme.surface,
        // Here we take the value from the HomePage object that was created by
        // the App.build method, and use it to set our appbar title.
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
            ? FutureBuilder<List<TransferWidget>>(
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
              )
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
                // rippleColor: const Color.fromARGB(
                //     255, 93, 32, 32), // tab button ripple color when pressed
                hoverColor: Colors.grey[700]!, // tab button hover color
                haptic: true, // haptic feedback
                tabBorderRadius: 15,
                // tabActiveBorder: Border.all(
                //     color: Colors.black, width: 1), // tab button border
                // tabBorder: Border.all(
                //     color: Colors.grey, width: 1), // tab button border
                // tabShadow: [
                //   BoxShadow(
                //       color: Color.alphaBlend(
                //           Theme.of(context)
                //               .colorScheme
                //               .primary
                //               .withOpacity(0.7),
                //           Colors.white),
                //       blurRadius: 8)
                // ], // tab button shadow
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
