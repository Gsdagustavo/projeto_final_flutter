import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../core/extensions/date_extensions.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/travel_stop.dart';
import '../../l10n/app_localizations.dart';
import '../../services/location_service.dart';
import '../extensions/enums_extensions.dart';
import '../providers/map_markers_provider.dart';
import '../providers/register_travel_provider.dart';
import '../providers/user_preferences_provider.dart';
import '../widgets/custom_date_range_widget.dart';
import '../widgets/custom_dialog.dart';

void onMarkerTap(TravelStop stop, LatLng position, BuildContext context) async {
  debugPrint('Stop passed to onMarkerTap: $stop');

  await showTravelStopModal(context, position, stop);
}

Future<TravelStop?> showTravelStopModal(
  BuildContext context,
  LatLng position, [
  TravelStop? stop,
]) async {
  final as = AppLocalizations.of(context)!;

  final travelState = Provider.of<RegisterTravelProvider>(
    context,
    listen: false,
  );

  final Place place;

  if (stop != null) {
    place = stop.place;
  } else {
    /// Get the place from the given position
    try {
      place = await LocationService().getPlaceByPosition(position);
    } on Exception catch (e) {
      await showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
            title: as.warning,
            content: Text(e.toString()),
            isError: true,
          );
        },
      );
      return null;
    }
  }

  travelState.resetStopExperiences(stop);
  travelState.resetStopTimeRangeDates(stop);

  debugPrint('travel stop modal is being shown.\nstop: $stop');

  final registeredStop = await showModalBottomSheet<TravelStop?>(
    context: context,
    showDragHandle: true,

    builder: (context) {
      print('Stop that will be passed to travel stop modal: $stop');
      return _TravelStopModal(place: place, stop: stop);
    },
  );

  print('Registered Stop: $registeredStop');

  return registeredStop;
}

class _TravelStopModal extends StatefulWidget {
  const _TravelStopModal({required this.place, this.stop});

  final Place place;
  final TravelStop? stop;

  @override
  State<_TravelStopModal> createState() => _TravelStopModalState();
}

class _TravelStopModalState extends State<_TravelStopModal> {
  void onStopRemoved(TravelStop stop) {
    Provider.of<RegisterTravelProvider>(
      context,
      listen: false,
    ).removeTravelStop(stop);

    Provider.of<MapMarkersProvider>(context, listen: false).removeMarker(stop);

    Navigator.pop(context);
  }

  Future<void> onStopRegistered(Place place) async {
    print('on stop registered called');

    final as = AppLocalizations.of(context)!;

    final travelState = Provider.of<RegisterTravelProvider>(
      context,
      listen: false,
    );

    if (travelState.stopTimeRange == null) {
      await showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
            isError: true,
            title: 'Invalid Travel Stop',
            content: Text('The Travel Stop Dates are invalid'),
          );
        },
      );

      return;
    }

    final stop = travelState.addTravelStop(widget.place);

    print('new stop: $stop');

    /// TODO: ADD MODAL ERROR MESSAGES
    await showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          title: as.travel_stop,
          content: Text(as.stop_registered_successfully),
        );
      },
    );

    Navigator.pop(context, stop);
  }

  void onStopUpdated(TravelStop stop) async {
    final travelState = Provider.of<RegisterTravelProvider>(
      context,
      listen: false,
    );

    travelState.updateTravelStop(stop: stop);

    if (travelState.hasError) {
      await showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
            title: 'Error',
            content: Text(
              'An error has occurred while trying to update the travel stop',
            ),
            isError: true,
          );
        },
      );

      return;
    }

    await showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          title: 'Travel Stop',
          content: Text('The travel stop was updated successfully'),
        );
      },
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final travelState = Provider.of<RegisterTravelProvider>(
      context,
      listen: false,
    );

    debugPrint("Travel stop modal build called. Stop passed: ${widget.stop}");

    final as = AppLocalizations.of(context)!;
    final placeInfo = widget.place.toString();
    final useStop = widget.stop;
    final selectedExperiences = travelState.selectedExperiences;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Text that will display the place's name or position
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(placeInfo, style: const TextStyle(fontSize: 28)),
              ),

              if (useStop != null)
                IconButton(
                  onPressed: () => onStopRemoved(widget.stop!),
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
            ],
          ),

          /// Text that will be shown if the stop is the first stop
          /// registered (start of the travel)
          if (widget.stop?.type == TravelStopType.start ||
              travelState.stops.isEmpty)
            Text(
              as.travel_start_location,
              style: const TextStyle(fontSize: 22),
            ),

          const Padding(padding: EdgeInsets.all(12)),

          /// Text to show the "Experiences" label
          Text(
            as.experiences,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Padding(padding: EdgeInsets.all(6)),

          /// Checkbox to select the experiences of the stop
          for (final experience in Experience.values)
            CheckboxListTile(
              value: selectedExperiences[experience],
              title: Text(experience.getIntlExperience(context)),
              onChanged: (value) {
                setState(() {
                  selectedExperiences[experience] = value ?? false;
                });
              },
            ),
          const Padding(padding: EdgeInsets.all(12)),

          _DatesWidget(),

          const Padding(padding: EdgeInsets.all(12)),

          if (widget.stop != null)
            _UpdateStopButton(onPressed: () => onStopUpdated(widget.stop!))
          else
            _RegisterStopButton(
              onPressed: () => onStopRegistered(widget.place),
            ),
        ],
      ),
    );
  }
}

class _DatesWidget extends StatefulWidget {
  const _DatesWidget({super.key});

  @override
  State<_DatesWidget> createState() => _DatesWidgetState();
}

class _DatesWidgetState extends State<_DatesWidget> {
  final _arriveDateController = TextEditingController();
  final _leaveDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final travelState = Provider.of<RegisterTravelProvider>(
      context,
      listen: false,
    );

    final locale = Provider.of<UserPreferencesProvider>(
      context,
      listen: false,
    ).languageCode;

    _arriveDateController.text =
        travelState.stopTimeRange?.start.getFormattedDate(locale) ?? '';
    _leaveDateController.text =
        travelState.stopTimeRange?.end.getFormattedDate(locale) ?? '';

    final as = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              as.dates_label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),

            TextButton(
              onPressed: () async {
                final firstDate = travelState.lastPossibleArriveDate;
                final lastDate = travelState.lastPossibleLeaveDate;

                print('First Date: $firstDate');
                print('Last Date: $lastDate');

                final range = await showDateRangePicker(
                  context: context,
                  firstDate: firstDate!,
                  lastDate: lastDate!,
                );

                print('New range: $range');

                if (range != null) {
                  travelState.stopTimeRange = range;
                  _arriveDateController.text = range.start.getFormattedDate(
                    locale,
                  );
                  _leaveDateController.text = range.end.getFormattedDate(
                    locale,
                  );
                }
              },
              child: Text(as.select_dates_label),
            ),
          ],
        ),

        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: CustomDateRangeWidget(
              firstDateController: _arriveDateController,
              lastDateController: _leaveDateController,
              firstDateLabelText: 'Arrive Date',
              lastDateLabelText: 'Leave Date',
            ),
          ),
        ),
      ],
    );
  }
}

class _RegisterStopButton extends StatelessWidget {
  const _RegisterStopButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;

    return ElevatedButton(onPressed: onPressed, child: Text(as.register_stop));
  }
}

class _UpdateStopButton extends StatelessWidget {
  const _UpdateStopButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;

    return ElevatedButton(onPressed: onPressed, child: Text(as.update_stop));
  }
}
