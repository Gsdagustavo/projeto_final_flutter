import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import 'fab_page.dart';

/// This is the settings page of the app
///
/// Currently, it does not have any interaction nor action available, but in the
/// future, more features will be added
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  /// The route of the page
  static const String routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return FabPage(
      title: AppLocalizations.of(context)!.title_settings,
      body: Center(child: Text('Settings page')),
    );
  }
}
