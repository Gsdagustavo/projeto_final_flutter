import 'package:flutter/material.dart';

import '../widgets/bottom_navigation_bar.dart';
import '../widgets/my_app_bar.dart';

class FabPage extends StatelessWidget {
  const FabPage({
    super.key,
    required this.body,
    required this.title,
    this.floatingActionButton
  });

  final String title;
  final Widget body;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: title),
      body: body,
      bottomNavigationBar: const MyBottomNavigationBar(),
      floatingActionButton: floatingActionButton,
    );
  }
}
