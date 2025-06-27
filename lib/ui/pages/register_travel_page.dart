import 'package:flutter/material.dart';
import 'package:projeto_final_flutter/l10n/app_localizations.dart';
import 'package:projeto_final_flutter/ui/pages/fab_page.dart';

class RegisterTravelPage extends StatelessWidget {
  const RegisterTravelPage({super.key});

  static const String routeName = '/registerTravel';

  @override
  Widget build(BuildContext context) {
    return FabPage(
      body: Text('Hello World'),
      title: AppLocalizations.of(context)!.title_register_travel,
    );
  }
}
