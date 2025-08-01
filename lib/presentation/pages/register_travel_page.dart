import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/extensions/string_extensions.dart';
import '../../domain/entities/enums.dart';
import '../../l10n/app_localizations.dart';
import '../extensions/enums_extensions.dart';
import '../providers/register_travel_provider.dart';
import '../providers/travel_list_provider.dart';
import '../widgets/map.dart';
import 'fab_page.dart';

/// This is a page for registering a travel
class RegisterTravelPage extends StatelessWidget {
  /// Constant constructor
  const RegisterTravelPage({super.key});

  /// The route of the page
  static const String routeName = '/registerTravel';

  void _showCustomDialog(BuildContext context) async {
    unawaited(
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Consumer<RegisterTravelProvider>(
            builder: (context, state, child) {
              final as = AppLocalizations.of(context)!;
              final Widget icon;
              Widget content;

              if (state.isLoading) {
                content = const SizedBox(
                  width: 48,
                  height: 48,
                  child: CircularProgressIndicator(),
                );
              }

              /// Determine which icon and text to show
              if (state.hasError) {
                content = Text(
                  state.error ?? as.unknown_error,
                  textAlign: TextAlign.center,
                );
                icon = const Icon(Icons.error, color: Colors.red);
              } else {
                content = Text(
                  as.travel_registered_successfully,
                  textAlign: TextAlign.center,
                );
                icon = const Icon(Icons.check_circle, color: Colors.green);
              }

              return AlertDialog(
                icon: icon,
                alignment: Alignment.center,
                content: content,
              );
            },
          );
        },
      ),
    );
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
              /// Travel title text field
              _TravelTitleTextField(),

              const Padding(padding: EdgeInsets.all(16)),

              /// Transport types dropdown button
              _TransportTypesDropdownButton(),

              const Padding(padding: EdgeInsets.all(16)),

              _DateTextButtons(),

              const Padding(padding: EdgeInsets.all(16)),

              _ParticipantsWidget(),

              const Padding(padding: EdgeInsets.all(16)),

              const _TravelMapWidget(),
            ],
          ),
        ),
      ),

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            tooltip: 'Register travel',
            child: const Icon(Icons.app_registration),
            onPressed: () async {
              final registerTravelState = Provider.of<RegisterTravelProvider>(
                context,
                listen: false,
              );

              _showCustomDialog(context);
              await registerTravelState.registerTravel();
              await context.read<TravelListProvider>().update();

              await Future.delayed(const Duration(seconds: 2));

              Navigator.pop(context);
            },
          ),

          const Padding(padding: EdgeInsets.all(16)),

          FloatingActionButton(
            tooltip: 'List travels',
            child: const Icon(Icons.get_app),
            onPressed: () async {
              final registerTravelState = Provider.of<RegisterTravelProvider>(
                context,
                listen: false,
              );

              await registerTravelState.select();
            },
          ),
        ],
      ),
    );
  }
}

class _TravelTitleTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final travelState = Provider.of<RegisterTravelProvider>(context);
    final as = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          as.travel_title_label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const Padding(padding: EdgeInsets.all(12)),
        TextField(
          controller: travelState.travelTitleController,
          onTapUpOutside: (_) => FocusScope.of(context).unfocus(),
          decoration: InputDecoration(
            label: Text(as.travel_title_label),
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
    final as = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          as.transport_type_label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const Padding(padding: EdgeInsets.all(12)),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: BoxBorder.all(color: Theme.of(context).hintColor, width: 1),
          ),

          child: DropdownButton<TransportType>(
            value: travelState.transportType,
            icon: const Icon(Icons.arrow_downward),
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
                      item.getIntlTransportType(context).capitalizedAndSpaced,
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

String _formatDate(DateTime date) {
  var stringDate = '';
  stringDate += '${date.day}/';
  stringDate += '${date.month}/';
  stringDate += date.year.toString();
  return stringDate;
}

class _DateTextButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final travelState = Provider.of<RegisterTravelProvider>(context);
    final as = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          as.select_dates_label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const Padding(padding: EdgeInsets.all(10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(EdgeInsets.zero),
                  ),

                  onPressed: () async {
                    final now = DateTime.now();
                    var date = await showDatePicker(
                      context: context,
                      initialDate: travelState.startDate ?? now,
                      firstDate: now,
                      lastDate: now.add(const Duration(days: 365)),
                    );
                    travelState.selectStartDate(date);
                  },
                  child: Text(as.travel_start_date_label),
                ),

                if (travelState.startDate != null)
                  Text(_formatDate(travelState.startDate!)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () async {
                    if (!travelState.isStartDateSelected) {
                      final message = as.err_invalid_date_snackbar;

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(message)));

                      return;
                    }

                    var date = await showDatePicker(
                      context: context,
                      initialDate: travelState.endDate ?? travelState.startDate,
                      firstDate: travelState.startDate!,
                      lastDate: travelState.startDate!.add(
                        const Duration(days: 365),
                      ),
                    );
                    travelState.selectEndDate(date);
                  },
                  child: Text(as.travel_end_date_label),
                ),

                if (travelState.endDate != null)
                  Text(_formatDate(travelState.endDate!)),
              ],
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

    final as = AppLocalizations.of(context)!;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              as.participants,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            TextButton(
              child: Text(
                as.register_participant,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
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
                              as.register_participant,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            const Padding(padding: EdgeInsets.all(16)),
                            TextField(
                              onTapOutside: (_) =>
                                  FocusScope.of(context).unfocus(),
                              controller: travelState.participantNameController,
                              decoration: InputDecoration(
                                hintText: as.name,
                                prefixIcon: const Icon(Icons.person),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            const Padding(padding: EdgeInsets.all(12)),
                            TextField(
                              onTapOutside: (_) =>
                                  FocusScope.of(context).unfocus(),
                              controller: travelState.participantAgeController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: as.age,
                                prefixIcon: const Icon(Icons.timer),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),

                            const Padding(padding: EdgeInsets.all(8)),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(as.cancel),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    travelState.addParticipant();
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          as.participant_registered,
                                        ),
                                      ),
                                    );
                                  },

                                  child: Text(as.register),
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

        const Padding(padding: EdgeInsets.all(8)),

        _ListParticipants(),
      ],
    );
  }
}

class _ListParticipants extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final travelState = Provider.of<RegisterTravelProvider>(context);
    final as = AppLocalizations.of(context)!;

    if (travelState.numParticipants <= 0) {
      return Text(as.no_participants_on_the_list);
    }

    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: travelState.numParticipants,
      itemBuilder: (context, index) {
        final participant = travelState.participants[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              CircleAvatar(child: Text(participant.name[0].toUpperCase())),
              const Padding(padding: EdgeInsets.all(8)),
              Text(
                '${as.name}: ${participant.name}\n'
                '${as.age}: ${participant.age}',
              ),

              const Spacer(),

              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  final result = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(as.remove),
                        content: Text(
                          '${as.remove_participant_confirmation} '
                          '${participant.name}?',
                        ),

                        icon: const Icon(Icons.warning, color: Colors.red),

                        actions: [
                          TextButton(
                            child: Text(as.cancel),
                            onPressed: () => Navigator.pop(context, false),
                          ),
                          TextButton(
                            child: Text(as.remove),
                            onPressed: () => Navigator.pop(context, true),
                          ),
                        ],
                      );
                    },
                  );

                  if (result != null && result == true) {
                    travelState.removeParticipant(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(as.participant_removed)),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TravelMapWidget extends StatelessWidget {
  const _TravelMapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Travel Map',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const Padding(padding: EdgeInsets.all(10)),

        Text('Add stops for your travel'),

        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, TravelMap.routeName);
          },
          icon: const Icon(Icons.map),
        ),
      ],
    );
  }
}
