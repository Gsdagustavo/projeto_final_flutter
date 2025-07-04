import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../entities/enums.dart';
import '../../entities/participant.dart';
import '../../l10n/app_localizations.dart';
import '../providers/register_travel_provider.dart';
import '../util/enums_extensions.dart';
import 'fab_page.dart';

/// This is a page for registering a travel
class RegisterTravelPage extends StatelessWidget {
  const RegisterTravelPage({super.key});

  /// The route of the page
  static const String routeName = '/registerTravel';

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
              /// Travel title text field
              _TravelTitleTextField(),

              Padding(padding: EdgeInsets.all(16)),

              /// Transport types dropdown button
              _TransportTypesDropdownButton(),

              Padding(padding: EdgeInsets.all(16)),

              _DateTextButtons(),

              Padding(padding: EdgeInsets.all(16)),

              _ParticipantsWidget(),

              Padding(padding: EdgeInsets.all(10)),
            ],
          ),
        ),
      ),
    );
  }
}

class _TravelTitleTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final travelState = Provider.of<RegisterTravelProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.travel_title_label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        Padding(padding: EdgeInsets.all(12)),
        TextField(
          controller: travelState.travelTitleController,
          onTapUpOutside: (_) => FocusScope.of(context).unfocus(),
          decoration: InputDecoration(
            label: Text(AppLocalizations.of(context)!.travel_title_label),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}

class _TransportTypesDropdownButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final travelState = Provider.of<RegisterTravelProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.transport_type_label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        Padding(padding: EdgeInsets.all(12)),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: BoxBorder.all(color: Theme.of(context).hintColor, width: 1),
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
      ],
    );
  }
}

// class _ExperiencesCheckboxes extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final travelState = Provider.of<RegisterTravelProvider>(context);
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//
//       children: [
//         Text(
//           AppLocalizations.of(context)!.experiences_label,
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
//         ),
//
//         Padding(padding: EdgeInsets.all(12)),
//
//         for (final item in Experience.values)
//           CheckboxListTile(
//             value: travelState.checkIfExperienceIsSelected(item),
//             onChanged: (_) => travelState.toggleExperience(item),
//             title: Text(item.getIntlExperience(context)),
//           ),
//       ],
//     );
//   }
// }

class _DateTextButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final travelState = Provider.of<RegisterTravelProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.select_dates_label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        Padding(padding: EdgeInsets.all(10)),
        Row(
          children: [
            Column(
              children: [
                TextButton(
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(EdgeInsets.zero),
                  ),
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
                Text(
                  'Date Registered: ${travelState.selectedStartDate.toString()}',
                ),
              ],
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
              child: Text(AppLocalizations.of(context)!.travel_end_date_label),
            ),
          ],
        ),
      ],
    );
  }
}

class _ParticipantsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final travelState = Provider.of<RegisterTravelProvider>(
      context,
      listen: false,
    );

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Participants',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            TextButton(
              child: Text(
                'Register Participant',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.viewInsetsOf(context).bottom,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Register Participant',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(16)),
                            TextField(
                              onTapOutside: (_) =>
                                  FocusScope.of(context).unfocus(),
                              controller: travelState.nameController,
                              decoration: InputDecoration(
                                hintText: 'Name',
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(12)),
                            TextField(
                              onTapOutside: (_) =>
                                  FocusScope.of(context).unfocus(),
                              controller: travelState.ageController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Age',
                                prefixIcon: Icon(Icons.timer),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(8)),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    travelState.addParticipant();
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Participant registered'),
                                      ),
                                    );
                                  },

                                  child: Text('Register'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),

        Padding(padding: EdgeInsets.all(8)),
        _ListParticipants(),
      ],
    );
  }
}

class _ListParticipants extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final travelState = Provider.of<RegisterTravelProvider>(context);

    if (travelState.numParticipants <= 0) {
      return Text('No participants in the list');
    }

    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: travelState.numParticipants,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _ParticipantListItem(
            participant: travelState.participants[index],
          ),
        );
      },
    );
  }
}

class _ParticipantListItem extends StatelessWidget {
  const _ParticipantListItem({required this.participant});

  final Participant participant;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          child: Image.network('https://i.redd.it/oqhs74f166511.png'),
        ),
        Padding(padding: EdgeInsets.all(8)),
        Text('${participant.name}, ${participant.age}'),
      ],
    );
  }
}
