import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/extensions/date_extensions.dart';
import '../../../domain/entities/travel.dart';
import '../../../domain/entities/travel_stop.dart';
import '../../../l10n/app_localizations.dart';
import '../../extensions/enums_extensions.dart';
import '../../providers/travel_list_provider.dart';
import '../../providers/user_preferences_provider.dart';
import '../../widgets/fab_page.dart';
import '../util/form_validations.dart';
import '../util/travel_utils.dart';
import 'register_travel_page.dart';

class TravelDetailsPage extends StatefulWidget {
  const TravelDetailsPage({super.key, required this.travel});

  final Travel travel;

  @override
  State<TravelDetailsPage> createState() => _TravelDetailsPageState();
}

class _TravelDetailsPageState extends State<TravelDetailsPage> {
  String locale = 'en';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      setState(() {
        locale = context.read<UserPreferencesProvider>().languageCode;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Travel details page build called');

    return FabPage(
      title: widget.travel.travelTitle,
      body: Column(
        spacing: 8,
        children: [
          Builder(
            builder: (context) {
              if (widget.travel.photos.isEmpty) {
                return Image.asset('assets/images/placeholder.png');
              }

              return Image.file(widget.travel.photos.first!);
            },
          ),

          _TravelTitleWidget(travel: widget.travel),

          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(cardPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 16,
                      children: [
                        Row(
                          spacing: 8,
                          children: [
                            Icon(Icons.calendar_today, size: 16),
                            Text(
                              'Duration',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        Text(
                          '${widget.travel.totalDuration} days',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(cardPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 16,
                      children: [
                        Row(
                          spacing: 8,
                          children: [
                            Icon(Icons.people, size: 16),
                            Text(
                              'Participants',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        Text(
                          '${widget.travel.participants.length} participants',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(cardPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 16,
                      children: [
                        Row(
                          spacing: 8,
                          children: [
                            Icon(Icons.airplanemode_active, size: 16),
                            Text(
                              'Transport',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        Text(
                          widget.travel.transportType.getIntlTransportType(
                            context,
                          ),
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(cardPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 16,
                      children: [
                        Row(
                          spacing: 8,
                          children: [
                            Icon(Icons.location_on, size: 16),
                            Text(
                              'Countries',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        Text(
                          '${widget.travel.numCountries} countries',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(cardPadding),
            child: Builder(
              builder: (context) {
                final countries = widget.travel.countries;

                if (countries.isEmpty) {
                  return SizedBox.shrink();
                }

                return Row(
                  children: List.generate(countries.length, (index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.transparent,
                      ),
                      child: Text(
                        countries[index]!,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(cardPadding),
              child: Column(
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      Icon(Icons.calendar_today),
                      Text(
                        'Travel Dates',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(12)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Start',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      Text(
                        widget.travel.startDate.getFormattedDateWithYear(
                          locale,
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(6)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'End',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      Text(
                        widget.travel.endDate.getFormattedDateWithYear(locale),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Card(
            child: Padding(
              padding: EdgeInsets.all(cardPadding),
              child: Column(
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      Icon(Icons.location_on),
                      Text(
                        'Travel Route',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),

                  _StopStepperWidget(
                    stops: widget.travel.stops,
                    locale: locale,
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(cardPadding),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  await onTravelDeleted(context, widget.travel);
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: const Padding(
                        padding: EdgeInsets.only(left: 32),
                        child: Icon(Icons.delete),
                      ),
                    ),
                    Text('Delete Travel'),
                  ],
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsetsGeometry.all(12)),
        ],
      ),
    );
  }
}

class _StopStepperWidget extends StatefulWidget {
  const _StopStepperWidget({
    super.key,
    required this.stops,
    required this.locale,
  });

  final List<TravelStop> stops;
  final String locale;

  @override
  State<_StopStepperWidget> createState() => _StopStepperWidgetState();
}

class _StopStepperWidgetState extends State<_StopStepperWidget> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Stepper(
      stepIconHeight: 60,
      currentStep: index,
      physics: NeverScrollableScrollPhysics(),
      type: StepperType.vertical,
      onStepTapped: (value) {
        setState(() {
          index = value;
        });
      },
      onStepContinue: () {
        if (index != widget.stops.length - 1) {
          setState(() {
            index++;
          });
        }
      },
      onStepCancel: () {
        if (index != 0) {
          setState(() {
            index--;
          });
        }
      },
      stepIconBuilder: (stepIndex, stepState) {
        /// First stop
        if (stepIndex == 0) {
          return Icon(Icons.start, color: Colors.blueAccent);
        }

        /// Last stop
        if (stepIndex == widget.stops.length - 1) {
          return Icon(Icons.flag, color: Colors.grey);
        }

        /// Middle stop
        return Icon(Icons.location_on, color: Colors.green);
      },
      steps: [
        for (final stop in widget.stops)
          Step(
            subtitle: Text(stop.type.getIntlTravelStopType(context)),
            title: Text('${stop.place.country}, ${stop.place.city}'),
            content: Row(
              spacing: 16,
              children: [
                Icon(Icons.access_time_filled),
                Text(stop.arriveDate!.getFormattedDateWithYear(widget.locale)),
              ],
            ),
          ),
      ],
    );
  }
}

class _TravelTitleWidget extends StatefulWidget {
  const _TravelTitleWidget({super.key, required this.travel});

  final Travel travel;

  @override
  State<_TravelTitleWidget> createState() => _TravelTitleWidgetState();
}

class _TravelTitleWidgetState extends State<_TravelTitleWidget> {
  final formKey = GlobalKey<FormState>();
  final travelTitleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    travelTitleController.text = widget.travel.travelTitle;
  }

  Future<void> onTravelTitleUpdated() async {
    if (!formKey.currentState!.validate()) {
      /// TODO: show error dialog
      return;
    }

    /// Travel title is the same
    if (travelTitleController.text == widget.travel.travelTitle) {
      return;
    }

    widget.travel.travelTitle = travelTitleController.text;

    final state = context.read<TravelListProvider>();
    await state.updateTravelTitle(widget.travel);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Travel Title Updated!'),
              Icon(Icons.check, color: Colors.green),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;
    final validations = FormValidations(as);

    return Padding(
      padding: const EdgeInsets.all(cardPadding),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Form(
            key: formKey,
            child: TextFormField(
              decoration: InputDecoration(
                constraints: BoxConstraints(maxWidth: 300, maxHeight: 100),
                labelText: 'Travel Title',
              ),
              controller: travelTitleController,
              validator: validations.travelTitleValidator,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          IconButton(onPressed: onTravelTitleUpdated, icon: Icon(Icons.save)),
        ],
      ),
    );
  }
}
