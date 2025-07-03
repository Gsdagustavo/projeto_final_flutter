import 'package:flutter/material.dart';
import 'package:projeto_final_flutter/entities/enums.dart';
import 'package:projeto_final_flutter/l10n/app_localizations.dart';
import 'package:projeto_final_flutter/ui/pages/fab_page.dart';
import 'package:projeto_final_flutter/ui/util/enums_extensions.dart';

class RegisterTravelPage extends StatefulWidget {
  const RegisterTravelPage({super.key});

  static const String routeName = '/registerTravel';

  @override
  State<RegisterTravelPage> createState() => _RegisterTravelPageState();
}

class _RegisterTravelPageState extends State<RegisterTravelPage> {
  final _travelTitleController = TextEditingController();
  var _selectedTransportType = TransportType.values.first;

  final Map<Experience, bool> _selectedExperiences = {
    for (final e in Experience.values) e: false,
  };

  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  void _sendData() async {
    final travelTitle = _travelTitleController.text;
    debugPrint('Travel title: $travelTitle');

    debugPrint('Selected experiences: $_selectedExperiences');

    debugPrint('Start date: $_selectedStartDate');
    debugPrint('End date: $_selectedEndDate');
  }

  @override
  Widget build(BuildContext context) {
    return FabPage(
      title: AppLocalizations.of(context)!.title_register_travel,

      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.travel_title_label,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),

              Padding(padding: EdgeInsets.all(10)),

              TextField(
                controller: _travelTitleController,
                onTapUpOutside: (_) => FocusScope.of(context).unfocus(),

                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),

                  label: Text(AppLocalizations.of(context)!.travel_title_label),
                ),
              ),

              Padding(padding: EdgeInsets.all(16)),

              Text(
                AppLocalizations.of(context)!.transport_type_label,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),

              Padding(padding: EdgeInsets.all(10)),

              /// Transport type dropdown button
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: BoxBorder.all(
                    color: Theme.of(context).hintColor,
                    width: 1,
                  ),
                ),

                child: DropdownButton<TransportType>(
                  value: _selectedTransportType,
                  icon: Icon(Icons.arrow_downward),
                  underline: Container(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(12),
                  isExpanded: true,

                  items: [
                    for (final item in TransportType.values)
                      DropdownMenuItem(
                        value: item,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            EnumFormatUtils.getFormattedString(
                              item.getIntlTransportType(context),
                            ),
                          ),
                        ),
                      ),
                  ],

                  onChanged: (value) {
                    setState(() {
                      _selectedTransportType =
                          value ?? TransportType.values.first;
                    });
                  },
                ),
              ),

              Padding(padding: EdgeInsets.all(16)),

              Text(
                AppLocalizations.of(context)!.experiences_label,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),

              Padding(padding: EdgeInsets.all(10)),

              Column(
                children: [
                  for (final item in _selectedExperiences.entries)
                    CheckboxListTile(
                      value: item.value,
                      onChanged: (value) {
                        setState(() {
                          _selectedExperiences[item.key] = value ?? false;
                        });
                      },

                      title: Text(item.key.getIntlTransportType(context)),
                    ),
                ],
              ),

              Row(
                children: [
                  TextButton(
                    onPressed: () async {
                      final now = DateTime.now();
                      var startDate = await showDatePicker(
                        context: context,
                        firstDate: now,
                        lastDate: now.add(Duration(days: 365)),
                      );

                      setState(() {
                        _selectedStartDate = startDate;
                      });
                    },

                    child: Text(
                      AppLocalizations.of(context)!.travel_start_date_label,
                    ),
                  ),

                  TextButton(
                    onPressed: () async {
                      if (_selectedStartDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppLocalizations.of(
                                context,
                              )!.err_invalid_date_snackbar,
                            ),
                          ),
                        );

                        return;
                      }

                      var endDate = await showDatePicker(
                        context: context,
                        firstDate: _selectedStartDate!,
                        lastDate: _selectedStartDate!.add(Duration(days: 365)),
                      );

                      setState(() {
                        _selectedEndDate = endDate;
                      });
                    },

                    child: Text(
                      AppLocalizations.of(context)!.travel_end_date_label,
                    ),
                  ),
                ],
              ),

              FloatingActionButton(onPressed: _sendData),
            ],
          ),
        ),
      ),
    );
  }
}
