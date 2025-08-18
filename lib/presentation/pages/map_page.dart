import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../core/extensions/date_extensions.dart';
import '../../core/extensions/travel_stop_extensions.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/travel.dart';
import '../../domain/entities/travel_stop.dart';
import '../../l10n/app_localizations.dart';
import '../../services/location_service.dart';
import '../extensions/enums_extensions.dart';
import '../providers/map_markers_provider.dart';
import '../providers/register_travel_provider.dart';
import '../providers/user_preferences_provider.dart';
import '../widgets/custom_date_range_widget.dart';
import '../widgets/custom_dialog.dart';
import '../widgets/my_app_bar.dart';

/// This is a map widget that will be used to register a [TravelStop] and to
/// view a [Travel] route
class TravelMap extends StatefulWidget {
  /// Constant constructor
  const TravelMap({super.key});

  static const String routeName = '/travelMap';

  @override
  State<TravelMap> createState() => _TravelMapState();
}

class _TravelMapState extends State<TravelMap> {
  GoogleMapController? _mapController;
  late LatLng _center;

  static const double _defaultZoom = 13.8;
  static const double _maxZoom = 18;
  static const double _minZoom = 3;

  bool _isCreatingMap = true;

  @override
  void initState() {
    super.initState();

    final travelState = Provider.of<RegisterTravelProvider>(
      context,
      listen: false,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final pos = await LocationService().getCurrentPosition();

      if (pos == null) return;

      setState(() {
        _center = LatLng(pos.latitude, pos.longitude);
        _isCreatingMap = false;
      });

      final markersState = Provider.of<MapMarkersProvider>(
        context,
        listen: false,
      );

      markersState.resetMarkers(travelState.stops);
    });
  }

  /// Defines behavior for when the user long presses on the map
  ///
  /// [position]: the position where the user pressed
  void _onLongPress(LatLng position) async {
    final as = AppLocalizations.of(context)!;

    /// Animates the camera towards the position
    await _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(position, _defaultZoom),
    );

    final Place place;

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

    /// Shows the modal to register the stop
    final registeredStop = await _showTravelStopModal(context, place: place);

    print('Registered Stop: $registeredStop');

    /// If the stop was registered, adds the marker to the list
    if (registeredStop != null) {
      Provider.of<MapMarkersProvider>(context, listen: false).addMarker(
        Marker(
          markerId: registeredStop.toMarkerId(),
          position: position,
          infoWindow: InfoWindow(title: place.toString()),
          onTap: () => _onMarkerTap(registeredStop, context),
        ),
      );
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;

    print("map widget build called");

    final areStopsValid = Provider.of<RegisterTravelProvider>(
      context,
      listen: true,
    ).areStopsValid;

    return Scaffold(
      appBar: MyAppBar(
        title: as.title_map_select_travel_stops,
        automaticallyImplyLeading: true,
      ),

      body: Builder(
        builder: (context) {
          if (_isCreatingMap) return Center(child: CircularProgressIndicator());

          return Stack(
            alignment: Alignment.center,
            children: [
              GoogleMap(
                minMaxZoomPreference: MinMaxZoomPreference(_minZoom, _maxZoom),
                onMapCreated: _onMapCreated,
                onLongPress: _onLongPress,
                myLocationEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: _defaultZoom,
                ),
                markers: Provider.of<MapMarkersProvider>(
                  context,
                  // listen: false,
                ).markers,
              ),

              /// Text field to search for places
              Positioned(
                right: 30,
                left: 30,
                top: 15,
                child: TextField(
                  onTapUpOutside: (_) => FocusScope.of(context).unfocus(),
                  decoration: InputDecoration(
                    hintText: 'Search for places',
                    prefixIcon: Icon(Icons.search),
                    // border: OutlineInputBorder(),
                  ),
                ),
              ),

              /// 'Finish' button
              if (areStopsValid)
                Positioned(
                  bottom: 30,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 64,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(as.finish, style: TextStyle(fontSize: 22)),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

Future<TravelStop?> _showTravelStopModal(
  BuildContext context, {
  required Place place,
  TravelStop? stop,
}) async {
  final travelState = Provider.of<RegisterTravelProvider>(
    context,
    listen: false,
  );

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

Future<void> _onMarkerTap(TravelStop stop, BuildContext context) async {
  debugPrint('Stop passed to onMarkerTap: $stop');

  final as = AppLocalizations.of(context)!;

  final Place place;

  /// Get place
  try {
    place = await LocationService().getPlaceByPosition(
      LatLng(stop.place.latitude, stop.place.longitude),
    );
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

  await _showTravelStopModal(context, place: place, stop: stop);
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

    Provider.of<MapMarkersProvider>(context, listen: false).addMarker(
      Marker(
        markerId: stop.toMarkerId(),
        position: LatLng(stop.place.latitude, stop.place.longitude),
        infoWindow: InfoWindow(title: place.toString()),
        onTap: () => _onMarkerTap(stop, context),
      ),
    );

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
