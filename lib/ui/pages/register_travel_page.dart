import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../entities/enums.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/register_travel_provider.dart';
import '../util/enums_extensions.dart';
import 'fab_page.dart';

/// This is a page for registering a travel
class RegisterTravelPage extends StatelessWidget {
  const RegisterTravelPage({super.key});

  /// The route of the page
  static const String routeName = '/registerTravel';

  @override
  Widget build(BuildContext context) {
    final travelState = Provider.of<RegisterTravelProvider>(
      context,
      listen: true,
    );

    return ChangeNotifierProvider(
      create: (context) => RegisterTravelProvider(),
      child: FabPage(
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

                /// Travel title text field
                TextField(
                  controller: travelState.travelTitleController,
                  onTapUpOutside: (_) => FocusScope.of(context).unfocus(),

                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),

                    label: Text(
                      AppLocalizations.of(context)!.travel_title_label,
                    ),
                  ),
                ),

                Padding(padding: EdgeInsets.all(16)),

                Text(
                  AppLocalizations.of(context)!.transport_type_label,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),

                Padding(padding: EdgeInsets.all(10)),

                /// Transport types dropdown button
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: BoxBorder.all(
                      color: Theme.of(context).hintColor,
                      width: 1,
                    ),
                  ),

                  child: DropdownButton<TransportType>(
                    value: travelState.selectedTransportType,
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
                              EnumFormatUtils().getFormattedString(
                                item.getIntlTransportType(context),
                              ),
                            ),
                          ),
                        ),
                    ],

                    onChanged: travelState.selectTransportType,
                  ),
                ),

                Padding(padding: EdgeInsets.all(16)),

                Text(
                  AppLocalizations.of(context)!.experiences_label,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),

                Padding(padding: EdgeInsets.all(10)),

                /// Experiences checkboxes
                Column(
                  children: [
                    for (final item in Experience.values)
                      CheckboxListTile(
                        value: travelState.checkIfExperienceIsSelected(item),
                        onChanged: (_) => travelState.toggleExperience(item),
                        title: Text(item.getIntlExperience(context)),
                      ),
                  ],
                ),

                Padding(padding: EdgeInsets.all(16)),

                Text(
                  AppLocalizations.of(context)!.select_dates_label,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),

                Padding(padding: EdgeInsets.all(10)),

                /// Select dates
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () async {
                          final now = DateTime.now();
                          var date = await showDatePicker(
                            context: context,
                            initialDate: travelState.selectedStartDate ?? now,
                            firstDate: now,
                            lastDate: now.add(Duration(days: 365)),
                          );

                          travelState.selectStartDate(date);
                        },

                        child: Text(
                          AppLocalizations.of(context)!.travel_start_date_label,
                        ),
                      ),

                      TextButton(
                        onPressed: () async {
                          if (!travelState.isStartDateSelected) {
                            final message = AppLocalizations.of(
                              context,
                            )!.err_invalid_date_snackbar;

                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text(message)));

                            return;
                          }

                          var date = await showDatePicker(
                            context: context,
                            initialDate:
                                travelState.selectedEndDate ??
                                travelState.selectedStartDate,
                            firstDate: travelState.selectedStartDate!,
                            lastDate: travelState.selectedStartDate!.add(
                              Duration(days: 365),
                            ),
                          );

                          travelState.selectEndDate(date);
                        },

                        child: Text(
                          AppLocalizations.of(context)!.travel_end_date_label,
                        ),
                      ),
                    ],
                  ),
                ),

                /// FloatingButton for debug purposes
                FloatingActionButton(onPressed: travelState.registerTravel),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
