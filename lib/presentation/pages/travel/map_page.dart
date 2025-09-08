import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../core/extensions/date_extensions.dart';
import '../../../core/extensions/experience_map_extension.dart';
import '../../../core/extensions/place_extensions.dart';
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
import '../../util/app_router.dart';
import '../../widgets/loading_dialog.dart';
import '../../widgets/modals.dart';
import '../util/travel_utils.dart';
import '../util/ui_utils.dart';

/// A widget that displays a Google Map for planning travel routes.
///
/// Users can search for places, add travel stops by long-pressing on the map,
/// and update or remove stops. Each stop can have associated experiences and
/// dates.
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

  final _searchController = TextEditingController();
  final _uuid = const Uuid();
  String _sessionToken = '1234567890';
  final List<Place> _placeList = [];

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

      if (!mounted) return;

      final markersState = Provider.of<MapMarkersProvider>(
        context,
        listen: false,
      );

      markersState.resetMarkers(context, travelState.stops);
    });
  }

  /// Handles long press events on the map.
  ///
  /// Opens a modal to add a travel stop at the pressed [position].
  void _onLongPress(LatLng position) async {
    await _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(position, _defaultZoom),
    );
    await showTravelStopModal(position);
  }

  /// Callback when the Google Map is created.
  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  /// Updates the search suggestions based on the current input.
  Future<void> _onChanged() async {
    if (_sessionToken.isEmpty) {
      setState(() {
        _sessionToken = _uuid.v4();
      });
    }

    if (_searchController.text.isEmpty) {
      setState(_placeList.clear);
      return;
    }

    final places = await LocationService().getSuggestion(
      input: _searchController.text,
      sessionToken: _sessionToken,
    );

    setState(() {
      _placeList.clear();
      _placeList.addAll(places);
    });

    if (_searchController.text.isEmpty) {
      setState(_placeList.clear);
    }
  }

  @override
  Widget build(BuildContext modalContext) {
    final as = AppLocalizations.of(modalContext)!;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              as.route_planning,
              style: Theme.of(modalContext).textTheme.displaySmall,
            ),
            Text(
              as.long_press_to_add_stops,
              style: Theme.of(modalContext).textTheme.bodyMedium,
            ),
          ],
        ),
        automaticallyImplyLeading: true,
      ),
      body: Builder(
        builder: (context) {
          if (_isCreatingMap) {
            return const Center(child: LoadingDialog());
          }

          return Stack(
            children: [
              /// Google Map display
              GoogleMap(
                minMaxZoomPreference: const MinMaxZoomPreference(
                  _minZoom,
                  _maxZoom,
                ),
                onMapCreated: _onMapCreated,
                onLongPress: _onLongPress,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: _defaultZoom,
                ),
                markers: context
                    .watch<MapMarkersProvider>()
                    .markers
                    .map(
                      (marker) => marker.copyWith(
                        onTapParam: () async {
                          final travelStop = context
                              .read<RegisterTravelProvider>()
                              .stops
                              .firstWhere(
                                (s) =>
                                    s.toMarkerId().value ==
                                    marker.markerId.value,
                              );
                          await showTravelStopModal(
                            travelStop.place.latLng,
                            travelStop,
                          );
                        },
                      ),
                    )
                    .toSet(),
              ),

              /// Search field for places
              Positioned(
                right: 15,
                left: 15,
                top: 15,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextField(
                      autofocus: false,
                      maxLines: 1,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: Icon(FontAwesomeIcons.xmark),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _placeList.clear();
                            });
                          },
                        ),
                        hintText: as.search_for_places,
                      ),
                      onTapOutside: (_) => FocusScope.of(context).unfocus(),
                      onChanged: (value) async {
                        await _onChanged();
                      },
                      controller: _searchController,
                    ),
                    Container(
                      color: _placeList.isEmpty
                          ? Colors.transparent
                          : Colors.white,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _placeList.length,
                        itemBuilder: (context, index) {
                          final place = _placeList[index];
                          return ListTile(
                            onTap: () async {
                              final p = await LocationService()
                                  .getPositionByPlaceQuery(place.toString());

                              if (p != null) {
                                unawaited(
                                  _mapController?.animateCamera(
                                    CameraUpdate.newLatLngZoom(
                                      LatLng(p.latitude, p.longitude),
                                      _defaultZoom,
                                    ),
                                  ),
                                );
                              }
                            },
                            title: Text(
                              place.toString(),
                              style: TextStyle(color: Colors.black),
                            ),
                            leading: Icon(
                              Icons.location_on,
                              color: Colors.black,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              /// Finish button if stops are valid
              Consumer<RegisterTravelProvider>(
                builder: (_, travelState, __) {
                  if (travelState.areStopsValid) {
                    return Positioned(
                      bottom: 30,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 64,
                          ),
                        ),
                        onPressed: () {
                          context.pop();
                        },
                        child: Text(
                          as.finish,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Opens a modal bottom sheet to add or update a travel stop at [position].
///
/// If [stop] is provided, the modal will edit that stop.
Future<void> showTravelStopModal(LatLng position, [TravelStop? stop]) async {
  final context = AppRouter.navigatorKey.currentContext;
  if (context == null || !context.mounted) return;

  final Place? place;

  if (stop != null) {
    place = stop.place;
  } else {
    try {
      place = await showLoadingDialog(
        context: context,
        function: () async {
          return await LocationService().getPlaceByPosition(position);
        },
      );
    } on Exception catch (e) {
      if (!context.mounted) return;
      await showDialog(
        context: context,
        builder: (context) => ErrorModal(message: e.toString()),
      );
      return;
    }
  }

  if (place == null) return;

  if (!context.mounted) return;

  final result = await showModalBottomSheet<TravelStop?>(
    context: context,
    useSafeArea: true,
    showDragHandle: true,
    enableDrag: true,
    isScrollControlled: true,
    builder: (context) {
      return _TravelStopModal(place: place!, stop: stop);
    },
  );

  if (!context.mounted) return;

  FocusScope.of(context).unfocus();

  final state = context.read<RegisterTravelProvider>();

  if (result != null) {
    if (stop == null) {
      state.addTravelStop(result);
    } else {
      state.updateTravelStop(oldStop: stop, newStop: result);
    }
  }
}

/// A modal bottom sheet for adding or editing a travel stop.
class _TravelStopModal extends StatefulWidget {
  const _TravelStopModal({required this.place, this.stop});

  final Place place;
  final TravelStop? stop;

  @override
  State<_TravelStopModal> createState() => _TravelStopModalState();
}

/// State for [_TravelStopModal] managing dates, experiences, and submission.
class _TravelStopModalState extends State<_TravelStopModal> {
  DateTime? _arriveDate;
  DateTime? _leaveDate;
  Map<Experience, bool> _selectedExperiences = {
    for (var e in Experience.values) e: false,
  };

  final _arriveDateController = TextEditingController();
  final _leaveDateController = TextEditingController();
  final _controller = DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    if (widget.stop != null) {
      _arriveDate = widget.stop!.arriveDate;
      _leaveDate = widget.stop!.leaveDate;
      _selectedExperiences = {
        for (final e in Experience.values)
          e: widget.stop!.experiences!.contains(e),
      };
    }
  }

  /// Updates an existing travel stop.
  void _onStopUpdated() async {
    if (widget.stop == null) return;

    final travelState = context.read<RegisterTravelProvider>();
    final markersState = context.read<MapMarkersProvider>();

    markersState.removeMarker(widget.stop!);

    widget.stop!
      ..arriveDate = _arriveDate
      ..leaveDate = _leaveDate
      ..experiences = _selectedExperiences.toExperiencesList();

    markersState.addMarker(
      Marker(
        markerId: widget.stop!.toMarkerId(),
        infoWindow: InfoWindow(title: widget.stop!.place.toString()),
        position: LatLng(
          widget.stop!.place.latitude,
          widget.stop!.place.longitude,
        ),
        onTap: () async =>
            await showTravelStopModal(widget.stop!.place.latLng, widget.stop!),
      ),
    );

    travelState.notifyListeners();
    Navigator.of(context).pop(widget.stop);
  }

  /// Adds a new travel to the list of travel stops in register travel provider.
  /// Also adds a marker to the list of markers in map markers provider
  void _onStopAdded() async {
    final stop = TravelStop(
      place: widget.place,
      experiences: _selectedExperiences.toExperiencesList(),
      leaveDate: _leaveDate,
      arriveDate: _arriveDate,
    );

    final pos = stop.place.latLng;

    context.read<MapMarkersProvider>().addMarker(
      Marker(
        markerId: stop.toMarkerId(),
        infoWindow: InfoWindow(title: stop.place.toString()),
        position: pos,
        onTap: () async => await showTravelStopModal(stop.place.latLng, stop),
      ),
    );

    final as = AppLocalizations.of(context)!;

    await showDialog(
      context: context,
      builder: (context) => SuccessModal(message: as.stop_added),
    );

    final ctx = AppRouter.navigatorKey.currentContext;

    if (ctx != null) {
      if (!ctx.mounted) return;

      Navigator.of(ctx).pop(stop);
    }
  }

  /// Checks if the stop is valid (dates selected + at least one experience).
  bool get isStopValid {
    final areDatesValid = _arriveDate != null && _leaveDate != null;
    final areExperiencesValid = _selectedExperiences
        .toExperiencesList()
        .isNotEmpty;
    return areDatesValid && areExperiencesValid;
  }

  /// Opens a date picker to select arrival date.
  void selectArriveDate() async {
    final travelState = context.read<RegisterTravelProvider>();
    final firstDate = travelState.lastPossibleArriveDate;
    final lastDate = travelState.lastPossibleLeaveDate;

    if (firstDate == null || lastDate == null) return;

    final date = await showDatePicker(
      context: context,
      initialDate: firstDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (date != null) {
      setState(() {
        _arriveDate = date;
        if (_leaveDate != null && _arriveDate!.isAfter(_leaveDate!)) {
          _leaveDate = null;
        }
      });
    }
  }

  /// Opens a date picker to select leave date.
  void selectLeaveDate() async {
    final travelState = context.read<RegisterTravelProvider>();
    final as = AppLocalizations.of(context)!;

    if (_arriveDate == null || travelState.lastPossibleLeaveDate == null) {
      return;
    }

    if (_arriveDate!.isAfter(travelState.lastPossibleLeaveDate!)) {
      await showDialog(
        context: context,
        builder: (context) => ErrorModal(message: as.err_invalid_leave_date),
      );
      return;
    }

    final date = await showDatePicker(
      context: context,
      initialDate: _arriveDate,
      firstDate: _arriveDate!,
      lastDate: travelState.lastPossibleLeaveDate!,
    );

    if (date != null) {
      setState(() {
        _leaveDate = date;
      });
    }
  }

  @override
  Widget build(BuildContext modalContext) {
    final as = AppLocalizations.of(context)!;
    final placeInfo = widget.place.toString();

    final locale = Provider.of<UserPreferencesProvider>(
      modalContext,
      listen: false,
    ).languageCode;

    _arriveDateController.text = _arriveDate?.getFormattedDate(locale) ?? '';
    _leaveDateController.text = _leaveDate?.getFormattedDate(locale) ?? '';

    final useStop = widget.stop != null;

    return DraggableScrollableSheet(
      controller: _controller,
      expand: false,
      maxChildSize: 1,
      minChildSize: 0.20,
      snapSizes: [0.25, 1],
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 18,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on),
                    Text(
                      as.add_stop,
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const Spacer(),
                    if (useStop)
                      IconButton(
                        onPressed: () async {
                          final removed = await onStopRemoved(
                            modalContext,
                            widget.stop!,
                          );

                          if (removed) {
                            if (!modalContext.mounted) return;

                            Navigator.of(modalContext).pop();
                          }
                        },
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                      ),
                  ],
                ),
                const Padding(padding: EdgeInsets.all(4)),
                Text(
                  placeInfo,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const Padding(padding: EdgeInsets.all(4)),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(as.arrive_date),
                          TextFormField(
                            onTapOutside: (_) =>
                                FocusScope.of(context).unfocus(),
                            controller: _arriveDateController,
                            decoration: InputDecoration(
                              /// TODO: intl
                              hintText: 'dd/mm/aaaa',
                              suffixIcon: const Icon(Icons.calendar_today),
                            ),
                            readOnly: true,
                            onTap: selectArriveDate,
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
                            onTapOutside: (_) =>
                                FocusScope.of(context).unfocus(),
                            controller: _leaveDateController,
                            decoration: InputDecoration(
                              /// TODO: intl
                              hintText: 'dd/mm/aaaa',
                              suffixIcon: const Icon(Icons.calendar_today),
                            ),
                            readOnly: true,
                            onTap: selectLeaveDate,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                /// TODO: intl
                Text(
                  as.planned_experiences,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
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
                            /// rebuilding the whole widget when selecting an
                            /// experience
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
                                  : Theme.of(
                                      context,
                                    ).textTheme.bodyMedium!.color,
                            ),
                          ),
                          trailing: _selectedExperiences[experience] == true
                              ? const Icon(Icons.check, color: Colors.green)
                              : const SizedBox.shrink(),
                        );
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Padding(padding: EdgeInsets.all(8));
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
                        child: Text(as.cancel),
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
                                  : baseColor.withValues(alpha: 0.3),
                            ),
                            onPressed: () {
                              if (isStopValid) {
                                if (useStop) {
                                  _onStopUpdated();
                                } else {
                                  _onStopAdded();
                                }
                              }
                            },
                            child: Text(useStop ? as.update_stop : as.add_stop),
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
      },
    );
  }
}

/// Returns a map associating [Experience] enum values to icons.
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
