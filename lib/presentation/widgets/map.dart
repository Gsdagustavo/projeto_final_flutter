import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../core/extensions/date_extensions.dart';
import '../../core/extensions/experience_map_extension.dart';
import '../../core/extensions/place_extensions.dart';
import '../../core/extensions/string_extensions.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/travel.dart';
import '../../domain/entities/travel_stop.dart';
import '../../services/locale_service.dart';
import '../../services/location_service.dart';
import '../extensions/enums_extensions.dart';
import '../providers/register_travel_provider.dart';
import 'error_dialog.dart';
import 'my_app_bar.dart';

Future<TravelStop?> _showTravelStopModal(
  BuildContext context, {
  required Place place,
  TravelStop? stop,
  VoidCallback? onStopRemoved,
}) async {
  if (stop != null) {
    assert(onStopRemoved != null);
  }

  final travelState = Provider.of<RegisterTravelProvider>(
    context,
    listen: false,
  );

  final display = place.display;

  final registeredStop = await showModalBottomSheet<TravelStop?>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          final selectedExperiences = travelState.selectedExperiences;
          debugPrint('Selected experiences: $selectedExperiences');

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                /// Text that will display the place's name or position
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(display, style: const TextStyle(fontSize: 28)),

                    if (stop != null)
                      IconButton(
                        onPressed: onStopRemoved,
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                  ],
                ),

                /// Text that will be shown if the stop is the first stop
                /// registered (start of the travel)
                if (stop?.type == TravelStopType.start ||
                    travelState.stops.isEmpty)
                  Text(
                    'Travel Start Location',
                    style: const TextStyle(fontSize: 22),
                  ),

                const Padding(padding: EdgeInsets.all(6)),

                /// Text that shows the type of the place
                Text(
                  place.type.capitalizedAndSpaced,
                  style: const TextStyle(fontSize: 20),
                ),
                const Padding(padding: EdgeInsets.all(4)),

                /// Text that shows the display name of the place
                Text(place.displayName),
                const Padding(padding: EdgeInsets.all(12)),

                /// Text to show the "Experiences" label
                Text(
                  'Experiences',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Padding(padding: EdgeInsets.all(6)),

                /// Checkbox to select the experiences of the stop
                for (final experience in Experience.values)
                  CheckboxListTile(
                    value: selectedExperiences[experience],
                    title: Text(experience.getIntlExperience(context)),
                    onChanged: (value) {
                      setModalState(() {
                        selectedExperiences[experience] = value ?? false;
                      });
                    },
                  ),
                const Padding(padding: EdgeInsets.all(12)),

                /// Date pickers to select the [arriveDate] and [leaveDate]
                _DatesPickers(setModalState: setModalState, stop: stop),
                const Padding(padding: EdgeInsets.all(12)),

                if (stop != null)
                  _UpdateStopButton(
                    stop: stop,
                    experiences: selectedExperiences.toExperiencesList(),
                  )
                else
                  _RegisterStopButton(
                    place: place,
                    experiences: selectedExperiences.toExperiencesList(),
                  ),
              ],
            ),
          );
        },
      );
    },
  );

  return registeredStop;
}

/// This is a map widget that will be used to register a [TravelStop] and to
/// view a [Travel] route
class CustomMap extends StatefulWidget {
  /// Constant constructor
  const CustomMap({super.key});

  static const double defaultZoom = 13.8;
  static const double maxZoom = 18;
  static const double minZoom = 3;

  @override
  State<CustomMap> createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> {
  GoogleMapController? _mapController;
  final _markers = <Marker>{};
  late LatLng _center;

  bool _isCreatingMap = true;
  bool _isLoading = false;

  final _stopMarkers = <TravelStop, Marker>{};

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
    });
  }

  Future<void> _onMarkerTap(TravelStop stop) async {
    debugPrint('Marker tapped');
    final Place place;

    setState(() {
      _isLoading = true;
    });

    /// Get place
    try {
      place = await LocationService().getPlaceByPosition(
        LatLng(stop.latitude, stop.longitude),
      );
    } on Exception catch (e) {
      await showDialog(
        context: context,
        builder: (context) {
          return ErrorDialog(errorMsg: e.toString());
        },
      );
      return;
    }

    setState(() {
      _isLoading = false;
    });

    await _showTravelStopModal(
      context,
      place: place,
      stop: stop,
      onStopRemoved: () {
        final travelState = Provider.of<RegisterTravelProvider>(
          context,
          listen: false,
        );

        travelState.removeTravelStop(stop);

        setState(() {
          _markers.removeWhere((element) {
            return element.markerId.value ==
                '${stop.latitude},${stop.longitude}';
          });
        });

        Navigator.pop(context);
      },
    );
  }

  /// Defines behavior for when the user long presses on the map
  ///
  /// [position]: the position where the user pressed
  void _onLongPress(LatLng position) async {
    /// Instantiates a new temporary marker with the given  position
    var marker = Marker(
      markerId: MarkerId(position.toString()),
      position: position,
    );

    setState(() {
      _markers.add(marker);
    });

    /// Animates the camera towards the position
    await _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(position, CustomMap.defaultZoom),
    );

    final Place place;

    setState(() {
      _isLoading = true;
    });

    /// Get place
    try {
      place = await LocationService().getPlaceByPosition(position);
    } on Exception catch (e) {
      await showDialog(
        context: context,
        builder: (context) {
          return ErrorDialog(errorMsg: e.toString());
        },
      );
      return;
    }

    setState(() {
      _isLoading = false;
      _markers.remove(marker);
    });

    final registeredStop = await _showTravelStopModal(context, place: place);

    if (registeredStop != null) {
      setState(() {
        _stopMarkers[registeredStop] = Marker(
          markerId: MarkerId('${place.lat},${place.lon}'),
          position: position,
          infoWindow: InfoWindow(title: place.display),
          onTap: () => _onMarkerTap(registeredStop),
        );

        _markers.add(
          Marker(
            markerId: MarkerId('${place.lat},${place.lon}'),
            position: position,
            infoWindow: InfoWindow(title: place.display),
            onTap: () => _onMarkerTap(registeredStop),
          ),
        );
      });
      debugPrint('Stop registered successfully!');
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Select Travel Stops'),
      body: Builder(
        builder: (context) {
          if (_isCreatingMap) return Center(child: CircularProgressIndicator());

          return Stack(
            children: [
              /// TODO: THIS WAS NOT TESTED YET!!!!!!
              if (_isLoading)
                CircularProgressIndicator()
              else
                GoogleMap(
                  minMaxZoomPreference: MinMaxZoomPreference(
                    CustomMap.minZoom,
                    CustomMap.maxZoom,
                  ),
                  onMapCreated: _onMapCreated,
                  onLongPress: _onLongPress,
                  myLocationEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: CustomMap.defaultZoom,
                  ),
                  markers: _markers,
                ),
            ],
          );
        },
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                debugPrint('Printing all markers:');
                for (final marker in _markers) {
                  debugPrint('${marker.toString()}\n');
                }
              },
              child: Center(child: Text('List markers')),
            ),

            Consumer<RegisterTravelProvider>(
              builder: (_, travelState, __) {
                return FloatingActionButton(
                  child: Center(child: Text('List stops')),
                  onPressed: () => debugPrint(travelState.stops.toString()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _RegisterStopButton extends StatelessWidget {
  const _RegisterStopButton({required this.experiences, required this.place});

  final List<Experience> experiences;
  final Place place;

  @override
  Widget build(BuildContext context) {
    final travelState = Provider.of<RegisterTravelProvider>(
      context,
      listen: false,
    );

    return ElevatedButton(
      onPressed: () async {
        final stop = TravelStop(
          cityName: place.address.city,
          latitude: place.lat,
          longitude: place.lon,
          experiences: experiences,
        );

        travelState.addTravelStop(stop);

        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Travel Stop'),
              content: Text('Travel Stop registered successfully!'),
              icon: Icon(Icons.check, color: Colors.green),
            );
          },
        );

        Navigator.pop(context, stop);
      },
      child: Text('Register Stop'),
    );
  }
}

class _UpdateStopButton extends StatelessWidget {
  const _UpdateStopButton({required this.stop, required this.experiences});

  final TravelStop stop;
  final List<Experience> experiences;

  @override
  Widget build(BuildContext context) {
    final travelState = Provider.of<RegisterTravelProvider>(
      context,
      listen: false,
    );

    return ElevatedButton(
      onPressed: () {
        final newStop = travelState.updateTravelStop(
          stop: stop,
          experiences: experiences,
        );

        if (travelState.hasError) {
          showDialog(
            context: context,
            builder: (context) {
              return ErrorDialog(errorMsg: travelState.error!);
            },
          );

          return;
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Travel Updated Successfully!')));
        Navigator.pop(context, newStop);
      },
      child: Text('Update Stop'),
    );
  }
}

class _DatesPickers extends StatefulWidget {
  const _DatesPickers({required this.setModalState, this.stop});

  final StateSetter setModalState;
  final TravelStop? stop;

  @override
  State<_DatesPickers> createState() => _DatesPickersState();
}

class _DatesPickersState extends State<_DatesPickers> {
  DateTime? _arriveDate;
  DateTime? _leaveDate;
  String? _locale;

  @override
  void initState() {
    super.initState();
    _arriveDate = widget.stop?.arriveDate;
    _leaveDate = widget.stop?.leaveDate;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final locale = await LocaleService().loadLanguageCode();

      if (mounted) {
        setState(() {
          _locale = locale;
        });
      }
    });

    debugPrint('Arrive date: $_arriveDate');
    debugPrint('Leave date: $_leaveDate');
    debugPrint('Locale: $_locale');
  }

  @override
  Widget build(BuildContext context) {
    final travelState = Provider.of<RegisterTravelProvider>(
      context,
      listen: false,
    );

    final initialArriveDate = widget.stop?.arriveDate ?? travelState.arriveDate;
    final initialLeaveDate = widget.stop?.leaveDate ?? travelState.leaveDate;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            TextButton(
              onPressed: () async {
                final initialDate =
                    initialArriveDate ?? travelState.lastPossibleArriveDate;
                final firstDate = travelState.lastPossibleArriveDate!;
                final lastDate = travelState.lastPossibleLeaveDate!;

                var date = await showDatePicker(
                  context: context,
                  initialDate: initialDate,
                  firstDate: firstDate,
                  lastDate: lastDate,
                );

                if (date == null) return;

                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (time == null) return;

                final dateTime = DateTime(
                  date.year,
                  date.month,
                  date.day,
                  time.hour,
                  time.minute,
                );

                setState(() {
                  _arriveDate = dateTime;
                });

                travelState.selectArriveDate(dateTime);
                widget.setModalState(() {});
              },
              child: Text('Arrive Date', style: TextStyle(fontSize: 16)),
            ),

            if (_arriveDate != null)
              if (_locale != null && _locale!.isNotEmpty)
                Text(
                  _arriveDate!.getFormattedDate(_locale!),
                  style: const TextStyle(fontSize: 14),
                )
              else
                const Center(child: CircularProgressIndicator()),
          ],
        ),

        Column(
          children: [
            TextButton(
              onPressed: () async {
                final arriveDate =
                    travelState.arriveDate ?? widget.stop?.arriveDate;

                if (arriveDate == null) {
                  await showDialog(
                    context: context,
                    builder: (context) => const ErrorDialog(
                      errorMsg: 'You must select the arrive date first!',
                    ),
                  );
                  return;
                }

                final initialDate = initialLeaveDate ?? arriveDate;
                final firstDate = arriveDate;
                final lastDate = travelState.lastPossibleLeaveDate;

                final date = await showDatePicker(
                  context: context,
                  initialDate: initialDate,
                  firstDate: firstDate,
                  lastDate: lastDate!,
                );

                if (date == null) return;

                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );

                if (time == null) return;

                final dateTime = DateTime(
                  date.year,
                  date.month,
                  date.day,
                  time.hour,
                  time.minute,
                );

                setState(() {
                  _leaveDate = dateTime;
                });

                travelState.selectLeaveDate(dateTime);
                widget.setModalState(() {});
              },
              child: Text('Leave Date', style: const TextStyle(fontSize: 16)),
            ),
            if (_leaveDate != null)
              if (_locale != null && _locale!.isNotEmpty)
                Text(
                  _leaveDate!.getFormattedDate(_locale!),
                  style: const TextStyle(fontSize: 14),
                )
              else
                const Center(child: CircularProgressIndicator()),
          ],
        ),
      ],
    );
  }
}
