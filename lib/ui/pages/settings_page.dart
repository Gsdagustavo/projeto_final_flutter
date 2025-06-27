import 'package:flutter/material.dart';

import 'fab_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FabPage(
      title: 'Settings',
      body: Center(child: Text('Settings page')),
      pageIndex: 1,
    );
  }
}
