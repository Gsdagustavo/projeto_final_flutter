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
      return;
    }
  }

  debugPrint('travel stop modal is being shown.\nstop: $stop');

  final result = await showModalBottomSheet<TravelStop?>(
    context: context,
    showDragHandle: true,
    builder: (context) {
      print('Stop that will be passed to travel stop modal: $stop');
      return _TravelStopModal(place: place, stop: stop);
    },
  );

  final state = context.read<RegisterTravelProvider>();

  if (result != null) {
    if (stop == null) {
      state.addTravelStop(result);
    } else {
      state.updateTravelStop(oldStop: stop, newStop: result);
    }
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
  DateTime? _arriveDate;
  DateTime? _leaveDate;

  Map<Experience, bool> _selectedExperiences = {
    for (var e in Experience.values) e: false,
  };

  final _arriveDateController = TextEditingController();
  final _leaveDateController = TextEditingController();

  void onStopRemoved() async {
    final travelState = Provider.of<RegisterTravelProvider>(
      context,
      listen: false,
    );
    final markersState = Provider.of<MapMarkersProvider>(
      context,
      listen: false,
    );

    final as = AppLocalizations.of(context)!;

    final remove = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          /// TODO: intl
          title: Text('Remove Stop'),
          content: Text('Do you really want to remove this stop?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(as.no),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(as.yes),
            ),
          ],
        );
      },
    );

    if (remove != null && remove) {
      travelState.removeTravelStop(widget.stop!);
      markersState.removeMarker(widget.stop!);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final travelState = Provider.of<RegisterTravelProvider>(
      context,
      listen: false,
    );

    debugPrint('Travel stop modal build called. Stop passed: ${widget.stop}');

    final as = AppLocalizations.of(context)!;
    final placeInfo = widget.place.toString();
    final useStop = widget.stop;

    final locale = Provider.of<UserPreferencesProvider>(
      context,
      listen: false,
    ).languageCode;

    _arriveDateController.text = _arriveDate?.getFormattedDate(locale) ?? '';
    _leaveDateController.text = _leaveDate?.getFormattedDate(locale) ?? '';

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
                  onPressed: onStopRemoved,
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
                          _arriveDate = range.start;
                          _leaveDate = range.end;

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

          if (useStop == null) ...[
            ElevatedButton(
              onPressed: () {
                final stop = TravelStop(
                  place: widget.place,
                  experiences: _selectedExperiences.toExperiencesList(),
                  leaveDate: _leaveDate,
                  arriveDate: _arriveDate,
                );

                final pos = LatLng(stop.place.latitude, stop.place.longitude);

                final marker = Marker(
                  markerId: stop.toMarkerId(),
                  infoWindow: InfoWindow(title: stop.place.toString()),
                  position: pos,
                  onTap: () => onMarkerTap(stop, pos, context),
                );

                final state = context.read<MapMarkersProvider>();
                state.addMarker(marker);

                Navigator.of(context).pop(stop);
              },
              child: Text('Add Stop'),
            ),
          ] else ...[
            ElevatedButton(
              onPressed: () {
                final stop = TravelStop(
                  place: widget.place,
                  experiences: _selectedExperiences.toExperiencesList(),
                  leaveDate: _leaveDate,
                  arriveDate: _arriveDate,
                );

                Navigator.of(context).pop(stop);
              },
              child: Text('Update Stop'),
            ),
          ],
        ],
      ),
    );
  }
}
