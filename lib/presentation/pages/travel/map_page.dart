import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../../services/location_service.dart';
import '../../providers/map_markers_provider.dart';
import '../../providers/register_travel_provider.dart';
import '../../scripts/scripts.dart';
import '../../widgets/my_app_bar.dart';

/// This is a map widget that will be used to register a [TravelStop] and to
/// view a [Travel] route
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
                markers: Provider.of<MapMarkersProvider>(context).markers,
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

                  return Container();
                },
              ),
            ],
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
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
    );
  }
}
