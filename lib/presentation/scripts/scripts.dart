import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../core/extensions/date_extensions.dart';
import '../../core/extensions/experience_map_extension.dart';
import '../../core/extensions/travel_stop_extensions.dart';
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

Future<void> showTravelStopModal(
  BuildContext context,
  LatLng position, [
  TravelStop? stop,
]) async {
  final as = AppLocalizations.of(context)!;

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

  debugPrint('travel stop modal is being shown.\nstop: $stop');

  final registeredStop = await showModalBottomSheet<TravelStop?>(
    context: context,
    showDragHandle: true,

    builder: (context) {
      print('Stop that will be passed to travel stop modal: $stop');
      return _TravelStopModal(place: place, stop: stop);
    },
  );

  // print('Registered Stop: $registeredStop');

  /// If the stop was registered, adds the marker to the list
  if (registeredStop != null) {
    Provider.of<MapMarkersProvider>(context, listen: false).addMarker(
      Marker(
        markerId: registeredStop.toMarkerId(),
        position: position,
        infoWindow: InfoWindow(title: place.toString()),
        onTap: () => onMarkerTap(registeredStop, position, context),
      ),
    );
  }
}

class _TravelStopModal extends StatefulWidget {
  const _TravelStopModal({required this.place, this.stop});

  final Place place;
  final TravelStop? stop;

  @override
  State<_TravelStopModal> createState() => _TravelStopModalState();
}

class _TravelStopModalState extends State<_TravelStopModal> {
  DateTimeRange? _stopTimeRange;

  Map<Experience, bool> _selectedExperiences = {
    for (var e in Experience.values) e: false,
  };

  final _arriveDateController = TextEditingController();
  final _leaveDateController = TextEditingController();

  void onStopRemoved(TravelStop stop) {
    Provider.of<RegisterTravelProvider>(
      context,
      listen: false,
    ).removeTravelStop(stop);

    Provider.of<MapMarkersProvider>(context, listen: false).removeMarker(stop);

    Navigator.of(context).pop();
  }

  Future<void> onStopRegistered(Place place) async {
    print('on stop registered called');

    debugPrint('range: $_stopTimeRange');

    final as = AppLocalizations.of(context)!;

    final travelState = Provider.of<RegisterTravelProvider>(
      context,
      listen: false,
    );

    if (_stopTimeRange == null) {
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

    debugPrint('Stop in travel stop modal: ${widget.stop}');
    debugPrint('Place in travel stop modal: ${widget.place}');

    final stop = TravelStop(
      place: place,
      arriveDate: _stopTimeRange!.start,
      leaveDate: _stopTimeRange!.end,
      experiences: _selectedExperiences.toExperiencesList(),
    );

    if (travelState.hasError) {
      await showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
            title: as.warning,

            /// TODO: intl 'Invalid Travel Stop Data'
            content: Text(travelState.error!),
          );
        },
      );

      return;
    }

    await showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          title: as.travel_stop,
          content: Text(as.stop_registered_successfully),
        );
      },
    );

    Navigator.of(context).pop(stop);
  }

  void onStopUpdated() async {
    final travelState = Provider.of<RegisterTravelProvider>(
      context,
      listen: false,
    );

    if (_stopTimeRange == null) {
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

    if (widget.stop != null) {
      final newStop = widget.stop!.copyWith(
        experiences: _selectedExperiences.toExperiencesList(),
        arriveDate: _stopTimeRange!.start,
        leaveDate: _stopTimeRange!.end,
      );
    }
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

    final locale = Provider.of<UserPreferencesProvider>(
      context,
      listen: false,
    ).languageCode;

    _arriveDateController.text =
        _stopTimeRange?.start.getFormattedDate(locale) ?? '';
    _leaveDateController.text =
        _stopTimeRange?.end.getFormattedDate(locale) ?? '';

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
              value: _selectedExperiences[experience],
              title: Text(experience.getIntlExperience(context)),
              onChanged: (value) {
                setState(() {
                  _selectedExperiences[experience] = value ?? false;
                });
              },
            ),
          const Padding(padding: EdgeInsets.all(12)),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    as.dates_label,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
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
                        setState(() {
                          _stopTimeRange = range;
                          _arriveDateController.text = range.start
                              .getFormattedDate(locale);
                          _leaveDateController.text = range.end
                              .getFormattedDate(locale);
                        });
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
                    firstDateLabelText: as.arrive_date,
                    lastDateLabelText: as.leave_date,
                  ),
                ),
              ),
            ],
          ),

          const Padding(padding: EdgeInsets.all(12)),

          if (widget.stop != null)
            _UpdateStopButton(onPressed: onStopUpdated)
          else
            _RegisterStopButton(
              onPressed: () => onStopRegistered(widget.place),
            ),
        ],
      ),
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
