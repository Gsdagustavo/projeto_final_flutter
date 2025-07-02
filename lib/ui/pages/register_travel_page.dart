import 'package:flutter/material.dart';
import 'package:projeto_final_flutter/l10n/app_localizations.dart';
import 'package:projeto_final_flutter/ui/pages/fab_page.dart';

class RegisterTravelPage extends StatefulWidget {
  const RegisterTravelPage({super.key});

  static const String routeName = '/registerTravel';

  @override
  State<RegisterTravelPage> createState() => _RegisterTravelPageState();
}

class _RegisterTravelPageState extends State<RegisterTravelPage> {
  final _travelTitleController = TextEditingController();

  void _sendData() async {
    final travelTitle = _travelTitleController.text;
    debugPrint('Travel title: $travelTitle');
  }

  @override
  Widget build(BuildContext context) {
    return FabPage(
      title: AppLocalizations.of(context)!.title_register_travel,

      body: Column(
        children: [
          TextField(
            controller: _travelTitleController,
            onTapUpOutside: (_) => FocusScope.of(context).unfocus(),

            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),

              label: Text('Titulo da viagem'),
            ),
          ),

          ElevatedButton(onPressed: _sendData, child: Text('Enviar dados')),
        ],
      ),
    );
  }
}
