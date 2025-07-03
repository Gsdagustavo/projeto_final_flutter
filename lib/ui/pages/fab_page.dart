import 'package:flutter/material.dart';

import '../widgets/bottom_navigation_bar.dart';
import '../widgets/my_app_bar.dart';

class FabPage extends StatelessWidget {
  const FabPage({
    super.key,
    required this.body,
    required this.title,
  });

  final String title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: title),
      body: body,
      bottomNavigationBar: const MyBottomNavigationBar(),
    );
  }
}
