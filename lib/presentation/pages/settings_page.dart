import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import 'auth/auth_page_switcher.dart';
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
    final loginProvider = Provider.of<UserProvider>(context, listen: false);

    return FabPage(
      title: AppLocalizations.of(context)!.title_settings,
      body: Center(child: Text('Settings page')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await loginProvider.signOut();

          if (loginProvider.hasError) {
            unawaited(
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('Warning'),
                  content: Text(loginProvider.errorMsg),
                ),
              ),
            );

            return;
          }

          Navigator.pushReplacementNamed(context, AuthPageSwitcher.routeName);
        },

        child: Text('Sign out'),
      ),
    );
  }
}
