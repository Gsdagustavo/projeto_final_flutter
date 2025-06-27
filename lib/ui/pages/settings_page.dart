import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import 'fab_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FabPage(
      title: AppLocalizations.of(context)!.title_settings,
      body: Center(child: Text('Settings page')),
      pageIndex: 1,
    );
  }
}
