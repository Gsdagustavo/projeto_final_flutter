import 'package:flutter/material.dart';
import 'package:projeto_final_flutter/pages/home_page.dart';
import 'package:projeto_final_flutter/pages/settings_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Roam',
      debugShowCheckedModeBanner: false,

      routes: {
        '/home': (_) => const HomePage(),
        '/settings': (_) => const SettingsPage(),
      },

      initialRoute: '/home',
    );
  }
}
