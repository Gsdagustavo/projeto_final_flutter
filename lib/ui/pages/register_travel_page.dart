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
                /// Travel title text field
                TravelTitleTextField(),

                Padding(padding: EdgeInsets.all(16)),

                /// Transport types dropdown button
                TransportTypesDropdownButton(),

                Padding(padding: EdgeInsets.all(16)),

                /// Experiences checkboxes
                // ExperiencesCheckboxes(),
                Padding(padding: EdgeInsets.all(16)),

                DateTextButtons(),

                Padding(padding: EdgeInsets.all(16)),

                Participants(),

                Padding(padding: EdgeInsets.all(10)),

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

class TravelTitleTextField extends StatelessWidget {
  const TravelTitleTextField({super.key});

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
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),

            label: Text(AppLocalizations.of(context)!.travel_title_label),
          ),
        ),
      ],
    );
  }
}

class TransportTypesDropdownButton extends StatelessWidget {
  const TransportTypesDropdownButton({super.key});

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

class ExperiencesCheckboxes extends StatelessWidget {
  const ExperiencesCheckboxes({super.key});

  @override
  Widget build(BuildContext context) {
    final travelState = Provider.of<RegisterTravelProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          AppLocalizations.of(context)!.experiences_label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),

        Padding(padding: EdgeInsets.all(12)),

        for (final item in Experience.values)
          CheckboxListTile(
            value: travelState.checkIfExperienceIsSelected(item),
            onChanged: (_) => travelState.toggleExperience(item),
            title: Text(item.getIntlExperience(context)),
          ),
      ],
    );
  }
}

class DateTextButtons extends StatelessWidget {
  const DateTextButtons({super.key});

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
      ],
    );
  }
}

class Participants extends StatelessWidget {
  const Participants({super.key});

  @override
  Widget build(BuildContext context) {
    final travelState = Provider.of<RegisterTravelProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          'Participants',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),

        Padding(padding: EdgeInsets.all(12)),

        TextButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                final numParticipantsController = TextEditingController(
                  text: travelState.numParticipants.toString(),
                );

                return AlertDialog(
                  title: Text('Numero de participantes'),
                  actions: [
                    TextField(
                      controller: numParticipantsController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),

                        label: Text('Inserir numero de participantes'),
                      ),
                    ),

                    Padding(padding: EdgeInsets.all(12)),

                    TextButton(
                      onPressed: () {
                        travelState.changeNumParticipants(
                          int.parse(numParticipantsController.text),
                        );

                        Navigator.of(context).pop();
                      },

                      child: Text('Ok'),
                    ),
                  ],
                );
              },
            );
          },

          child: Text('Selecionar numero de participantes'),
        ),

        ParticipantsStepper(),
      ],
    );
  }
}

class ParticipantsStepper extends StatefulWidget {
  const ParticipantsStepper({super.key});

  @override
  State<ParticipantsStepper> createState() => _ParticipantsStepperState();
}

class _ParticipantsStepperState extends State<ParticipantsStepper> {
  int step = 0;

  @override
  Widget build(BuildContext context) {
    final travelState = Provider.of<RegisterTravelProvider>(context);

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (step >= travelState.numParticipants) {
    //     setState(() {
    //       step = travelState.numParticipants - 1;
    //     });
    //   }
    // });

    return Stepper(
      steps: List.generate(travelState.numParticipants, (index) {
        return Step(
          title: Text('Participant ${index + 1}'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField()
            ],
          ),
        );
      }),

      currentStep: step,

      onStepCancel: () {
        if (step > 0) {
          setState(() {
            step--;
          });
        }
      },

      onStepContinue: () {
        if (step < travelState.numParticipants - 1) {
          setState(() {
            step++;
          });
        }
      },

      onStepTapped: (value) {
        setState(() {
          step = value;
        });
      },
    );
  }
}
