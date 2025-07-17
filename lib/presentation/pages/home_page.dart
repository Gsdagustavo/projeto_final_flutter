import 'package:flutter/material.dart';

import '../../domain/entities/enums.dart';
import '../../l10n/app_localizations.dart';
import '../util/enums_extensions.dart';
import 'fab_page.dart';

/// The Home Page of the app
class HomePage extends StatelessWidget {
  /// Constant constructor
  const HomePage({super.key});

  /// The route of the page
  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    final items = TransportType.values;

    return FabPage(
      title: AppLocalizations.of(context)!.title_home,
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Text(items[index].getIntlTransportType(context));
        },
      ),
    );
  }
}
