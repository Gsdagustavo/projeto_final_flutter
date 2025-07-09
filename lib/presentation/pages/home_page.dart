import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../entities/enums.dart';
import '../../l10n/app_localizations.dart';
import '../../services/locale_service.dart';
import '../providers/language_code_provider.dart';
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

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final locState = Provider.of<LanguageCodeProvider>(
            context,
            listen: false,
          );

          await locState.changeLanguageCode(
            languageCode:
                LocaleService.languageCodes[Random().nextInt(
                  LocaleService.languageCodes.length,
                )],
          );
          debugPrint(locState.languageCode);
        },
      ),
    );
  }
}
