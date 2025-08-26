import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../../services/location_service.dart';
import '../../providers/map_markers_provider.dart';
import '../../providers/register_travel_provider.dart';
import '../../scripts/scripts.dart';

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
