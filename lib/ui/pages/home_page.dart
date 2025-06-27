import 'package:flutter/material.dart';
import 'package:projeto_final_flutter/ui/util/enums_util.dart';

import '../../entities/enums.dart';
import '../../l10n/app_localizations.dart';
import 'fab_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const String routeName = '/home';

  @override
  Widget build(BuildContext context) {
    final List<TransportType> items = TransportType.values;

    return FabPage(
      title: AppLocalizations.of(context)!.title_home,
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Text(items[index].getIntlTransportType(context));
        },
      )
    );
  }
}
