import 'package:flutter/material.dart';
import 'home_page.dart';
import 'sources_page.dart';
import 'player_page.dart';
import 'team_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Root of application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rumour Mill',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Colors.green,
          secondary: Colors.teal,
          background: Colors.black,
        ),
        fontFamily: 'Dosis',
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(title: 'Transfers'),
        '/sources': (context) => const SourcesPage(),
        '/player': (context) => const PlayerPage(),
        '/team': (context) => const TeamPage(),
      },
    );
  }
}
