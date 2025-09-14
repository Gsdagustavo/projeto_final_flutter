import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../core/extensions/place_extensions.dart';
import '../../../core/extensions/travel_stop_extensions.dart';
import '../../../domain/entities/place.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/location_service.dart';
import '../../providers/map_markers_provider.dart';
import '../../providers/register_travel_provider.dart';
import '../../widgets/loading_dialog.dart';
import '../util/travel_utils.dart';

/// A widget that displays a Google Map for planning travel routes.
///
/// Users can search for places, add travel stops by long-pressing on the map,
/// and update or remove stops. Each stop can have associated experiences and
/// dates.
class TravelMapPage extends StatefulWidget {
  /// Constant constructor
  const TravelMapPage({super.key});

  @override
  State<TravelMapPage> createState() => _TravelMapPageState();
}

class _TravelMapPageState extends State<TravelMapPage> {
  GoogleMapController? _mapController;
  late LatLng _center;

  static const double _defaultZoom = 13.8;
  static const double _maxZoom = 18;
  static const double _minZoom = 3;

  final _searchController = TextEditingController();
  final _uuid = const Uuid();
  String _sessionToken = '123456780';
  final List<Place> _placeList = [];

  bool _isCreatingMap = true;

  /// Handles long press events on the map.
  ///
  /// Opens a modal to add a travel stop at the pressed [position].
  void _onLongPress(LatLng position) async {
    await _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(position, _defaultZoom),
    );

    if (mounted) {
      FocusScope.of(context).requestFocus(FocusNode());
    }

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
    setState(() {
      _sessionToken = _uuid.v4();
    });

    if (_searchController.text.isEmpty) {
      setState(_placeList.clear);
      return;
    }

    final places = await LocationService().getSuggestions(
      input: _searchController.text,
      sessionToken: _sessionToken,
    );

    setState(() {
      _placeList
        ..clear()
        ..addAll(places);
    });

    if (_searchController.text.isEmpty) {
      setState(_placeList.clear);
    }
  }

  void _moveToViewport(
    GoogleMapController controller,
    Map<String, dynamic> geometry,
  ) async {
    final viewport = geometry['viewport'];
    final northeast = viewport['northeast'];
    final southwest = viewport['southwest'];

    final bounds = LatLngBounds(
      northeast: LatLng(northeast['lat'], northeast['lng']),
      southwest: LatLng(southwest['lat'], southwest['lng']),
    );

    await controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  void _onPlaceListTileTap(Place place) async {
    Place? resolved;
    Map<String, dynamic>? geometry;

    if (place.placeId != null && place.placeId!.isNotEmpty) {
      resolved = await LocationService().getPlaceDetails(place.placeId!);
      geometry = await LocationService().getPlaceGeometry(place.placeId!);
    } else {
      final query = [
        place.city,
        place.state,
        place.country,
      ].where((e) => e != null && e.isNotEmpty).join(', ');

      resolved = await LocationService().getPositionByPlaceQuery(query);
    }

    if (resolved == null) return;

    if (_mapController != null) {
      if (geometry != null && geometry['viewport'] != null) {
        _moveToViewport(_mapController!, geometry);
      } else {
        await _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(resolved.latitude, resolved.longitude),
            _defaultZoom,
          ),
        );
      }
    }

    setState(() {
      _searchController.clear();
      _placeList.clear();
    });

    if (!mounted) return;
    FocusScope.of(context).unfocus();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final pos = await LocationService().getCurrentPosition();
      if (pos == null) return;

      setState(() {
        _center = LatLng(pos.latitude, pos.longitude);
        _isCreatingMap = false;
      });

      if (!mounted) return;

      context.read<MapMarkersProvider>().resetMarkers(
        stops: context.read<RegisterTravelProvider>().stops,
        onTap: (stop) async {
          await showTravelStopModal(stop.place.latLng);
        },
      );
    });
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
                          final title = [
                            place.city,
                            place.state,
                            place.country,
                          ].where((e) => e != null && e.isNotEmpty).join(', ');

                          return _AutocompletePlaceListTile(
                            onTap: () async => _onPlaceListTileTap(place),
                            place: place,
                            title: title,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AutocompletePlaceListTile extends StatelessWidget {
  const _AutocompletePlaceListTile({
    required this.onTap,
    required this.place,
    required this.title,
  });

  final VoidCallback onTap;
  final Place place;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title.isEmpty ? place.toString() : title,
        style: const TextStyle(color: Colors.black),
      ),
      leading: const Icon(Icons.location_on, color: Colors.black),
    );
  }
}
