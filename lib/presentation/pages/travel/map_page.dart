import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../core/extensions/date_extensions.dart';
import '../../../core/extensions/experience_map_extension.dart';
import '../../../core/extensions/travel_stop_extensions.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/place.dart';
import '../../../domain/entities/travel_stop.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/location_service.dart';
import '../../extensions/enums_extensions.dart';
import '../../providers/map_markers_provider.dart';
import '../../providers/register_travel_provider.dart';
import '../../providers/user_preferences_provider.dart';
import '../../scripts/scripts.dart';
import '../../widgets/custom_dialog.dart';

class TravelMap extends StatefulWidget {
  /// Constant constructor
  const TravelMap({super.key});

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

      markersState.resetMarkers(context, travelState.stops);
    });
  }

  /// Defines behavior for when the user long presses on the map
  ///
  /// [position]: the position where the user pressed
  void _onLongPress(LatLng position) async {
    /// Animates the camera towards the position
    await _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(position, _defaultZoom),
    );

    /// Shows the modal to register the stop
    await showTravelStopModal(context, position);
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;
    return Scaffold(
      /// TODO: add transparency to appbar
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              as.route_planning,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            Text(
              'Long press to add stops',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        automaticallyImplyLeading: true,
      ),

      body: Builder(
        builder: (context) {
          if (_isCreatingMap) return Center(child: CircularProgressIndicator());

          return Stack(
            // alignment: Alignment.center,
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
                markers: Provider.of<MapMarkersProvider>(context).markers,
              ),

              Positioned(
                top: 12,
                left: 12,
                right: 12,
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.withOpacity(0.75),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 14,
                      ),
                      child: Consumer<RegisterTravelProvider>(
                        builder: (_, state, __) {
                          return Row(
                            spacing: 12,
                            children: [
                              Icon(Icons.route, size: 18),
                              Text('${state.stops.length} stop(s)'),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              /// Text field to search for places
              // Positioned(
              //   right: 30,
              //   left: 30,
              //   top: 15,
              //   child: TextField(
              //     onTapUpOutside: (_) => FocusScope.of(context).unfocus(),
              //     decoration: InputDecoration(
              //       hintText: as.search_for_places,
              //       prefixIcon: Icon(Icons.search),
              //     ),
              //   ),
              // ),
              Consumer<RegisterTravelProvider>(
                builder: (_, travelState, __) {
                  final areStopsValid = travelState.areStopsValid;

                  /// 'Finish' button
                  if (areStopsValid) {
                    return Positioned(
                      bottom: 30,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 64,
                          ),
                        ),
                        onPressed: () {
                          context.pop();
                        },

                        /// TODO: fix theme
                        child: Text(
                          as.finish,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                    );
                  }

                  return SizedBox.shrink();
                },
              ),
            ],
          );
        },
      ),

      floatingActionButton: Column(
        children: [
          FloatingActionButton(
            onPressed: () {
              final markerState = Provider.of<MapMarkersProvider>(
                context,
                listen: false,
              );

              debugPrint('Markers len: ${markerState.markers.length}');

              for (final (idx, marker) in markerState.markers.indexed) {
                debugPrint("$idx: ${marker.markerId}");
              }
            },
          ),

          FloatingActionButton(
            onPressed: () {
              final travelState = Provider.of<RegisterTravelProvider>(
                context,
                listen: false,
              );

              debugPrint('Stops len: ${travelState.stops.length}');

              for (final (idx, stop) in travelState.stops.indexed) {
                debugPrint('$idx: $stop');
              }
            },
          ),
        ],
      ),
    );
  }
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

  final result = await showDialog<TravelStop?>(
    context: context,
    builder: (context) {
      print('Stop that will be passed to travel stop modal: $stop');
      return Dialog(
        child: _TravelStopModal(place: place, stop: stop),
      );
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
  DateTime? _arriveDate = DateTime.now();
  DateTime? _leaveDate = DateTime.now().add(Duration(days: 1));

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

    // Navigator.of(context).pop();
  }

  void onStopAdded() async {
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

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          /// TODO: intl
          title: Text('Stop added successfully!'),
          icon: Icon(Icons.check, color: Colors.green),
        );
      },
    );

    Navigator.of(context).pop(stop);
  }

  void onStopUpdated() async {
    final stop = TravelStop(
      place: widget.place,
      experiences: _selectedExperiences.toExperiencesList(),
      leaveDate: _leaveDate,
      arriveDate: _arriveDate,
    );

    Navigator.of(context).pop(stop);
  }

  bool get isStopValid {
    final areDatesValid = _arriveDate != null && _leaveDate != null;
    final areExperiencesValid = _selectedExperiences
        .toExperiencesList()
        .isNotEmpty;

    return areDatesValid && areExperiencesValid;
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
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 18,
          children: [
            Row(
              children: [
                Icon(Icons.location_on),
                Text(
                  /// TODO: intl
                  'Add Travel Stop',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ],
            ),
            Padding(padding: EdgeInsets.all(4)),
            Text(placeInfo, style: Theme.of(context).textTheme.displaySmall),
            Padding(padding: EdgeInsets.all(4)),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(as.arrive_date),
                      TextFormField(
                        onTapOutside: (_) => FocusScope.of(context).unfocus(),
                        controller: _arriveDateController,
                        decoration: InputDecoration(
                          /// TODO: intl
                          hintText: 'dd/mm/aaaa',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                        readOnly: true,
                        // onTap: () => _pickDate(isStart: true),
                      ),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.all(6)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(as.leave_date),
                      TextFormField(
                        onTapOutside: (_) => FocusScope.of(context).unfocus(),
                        controller: _leaveDateController,
                        decoration: InputDecoration(
                          /// TODO: intl
                          hintText: 'dd/mm/aaaa',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                        readOnly: true,
                        // onTap: () => _arriveDateController(isStart: false),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            /// TODO: intl
            Text(
              'Planned Experiences',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final experience = Experience.values[index];
                final experienceIcon = getExperiencesIcons()[experience];
                return Consumer<RegisterTravelProvider>(
                  builder: (_, state, __) {
                    final isExperienceSelected =
                        _selectedExperiences[experience] == true;

                    return ListTile(
                      shape: Theme.of(context).cardTheme.shape,
                      leading: Icon(
                        experienceIcon,
                        color: isExperienceSelected
                            ? Colors.green
                            : Theme.of(context).iconTheme.color,
                      ),
                      onTap: () {
                        /// TODO: implement a travel stop provider to avoid
                        /// rebuilding the whole widget when selecting an experience
                        setState(() {
                          _selectedExperiences[experience] =
                              !_selectedExperiences[experience]!;
                        });
                      },
                      title: Text(
                        experience.getIntlExperience(context),
                        style: TextStyle(
                          color: isExperienceSelected
                              ? Colors.green
                              : Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                      trailing: _selectedExperiences[experience] == true
                          ? Icon(Icons.check, color: Colors.green)
                          : SizedBox.shrink(),
                    );
                  },
                );
              },
              separatorBuilder: (context, index) {
                return Padding(padding: EdgeInsets.all(8));
              },
              itemCount: Experience.values.length,
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },

                    /// TODO: intl
                    child: Text('Cancel'),
                  ),
                ),

                Expanded(
                  child: Builder(
                    builder: (context) {
                      final baseColor = Theme.of(context)
                          .elevatedButtonTheme
                          .style!
                          .backgroundColor!
                          .resolve({})!;

                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isStopValid
                              ? baseColor
                              : baseColor.withOpacity(0.3),
                        ),
                        onPressed: onStopAdded,
                        /// TODO: intl
                        child: Text('Add Stop'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Map<Experience, IconData> getExperiencesIcons() {
  return {
    Experience.cultureImmersion: Icons.language,
    Experience.alternativeCuisines: Icons.dining_outlined,
    Experience.visitHistoricalPlaces: Icons.account_balance,
    Experience.visitLocalEstablishments: Icons.storefront,
    Experience.contactWithNature: Icons.park,
    Experience.socialEvents: Icons.celebration,
  };
}
