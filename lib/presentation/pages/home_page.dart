import 'package:flutter/material.dart';

import '../../entities/enums.dart';
import '../../l10n/app_localizations.dart';
import '../util/enums_extensions.dart';
import 'fab_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
