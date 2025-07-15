import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    return FabPage(
      title: AppLocalizations.of(context)!.title_settings,
      body: Consumer<LoginProvider>(
        builder: (_, authProvider, __) {
          final locale = Localizations.localeOf(context).toString();

          final user = authProvider.loggedUser;
          final emailInitial = user != null && user.email != null
              ? user.email![0].toUpperCase()
              : '?';

          final creationTime = user!.metadata.creationTime;
          final lastSignInTime = user.metadata.lastSignInTime;

          final formattedCreationTime = creationTime != null
              ? DateFormat.yMd(locale).format(creationTime)
              : 'N/A';

          final formattedSignInTime = lastSignInTime != null
              ? DateFormat.yMd(locale).format(lastSignInTime)
              : 'N/A';

          return Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    radius: 64,
                    child: Text(
                      emailInitial,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                      ),
                    ),
                  ),
                ),

                Padding(padding: EdgeInsets.all(12)),

                Text(
                  'Account',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),

                Padding(padding: EdgeInsets.all(6)),

                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email: ${user.email}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Account creation: $formattedCreationTime',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Last sign in: $formattedSignInTime',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),


              ],
            ),
          );
        },
      ),
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
