import 'dart:async';

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
import '../../l10n/app_localizations.dart';
import '../../services/locale_service.dart';
import '../../services/location_service.dart';
import '../extensions/enums_extensions.dart';
import '../pages/register_travel_page.dart';
import '../providers/register_travel_provider.dart';
import 'custom_dialog.dart';
import 'my_app_bar.dart';

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
  final _markers = <Marker>{};
  late LatLng _center;

  static const double _defaultZoom = 13.8;
  static const double _maxZoom = 18;
  static const double _minZoom = 3;

  bool _isCreatingMap = true;
  bool _isLoading = false;

  // bool _isLoadingDialogVisible = false;

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
    final as = AppLocalizations.of(context)!;

    setState(() {
      _isLoading = true;
    });

    final Place place;

    /// Get place
    try {
      place = await LocationService().getPlaceByPosition(
        LatLng(stop.place.lat, stop.place.lon),
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
                '${stop.place.lat},${stop.place.lon}';
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
    final as = AppLocalizations.of(context)!;

    /// Instantiates a marker with the given  position
    var marker = Marker(
      markerId: MarkerId(position.toString()),
      position: position,
    );

    /// Adds the marker to the list of markers
    ///
    /// At this point, the marker is purely visual, with no information about
    /// it ([InfoWindow] was not given)
    setState(() {
      _markers.add(marker);
    });

    /// Animates the camera towards the position
    await _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(position, _defaultZoom),
    );

    final Place place;

    setState(() {
      _isLoading = true;
    });

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

    setState(() {
      _isLoading = false;

      /// Removes the marker from the list
      _markers.remove(marker);
    });

    /// Shows the modal to register the stop
    final registeredStop = await _showTravelStopModal(context, place: place);

    /// If the stop was registered, adds the definitive marker to the list
    if (registeredStop != null) {
      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId('${place.lat},${place.lon}'),
            position: position,
            infoWindow: InfoWindow(title: place.display),
            onTap: () => _onMarkerTap(registeredStop),
          ),
        );
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              Padding(padding: EdgeInsets.all(20)),
              Text('Loading...'),
            ],
          ),
        );
      },
    );
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

          // debugPrint('Is loading dialog visible: $_isLoadingDialogVisible');
          // /// TODO: implement a better way of showing the loading dialog,
          // /// since it can be popped unwantedly
          // if (_isLoading && !_isLoadingDialogVisible) {
          //   WidgetsBinding.instance.addPostFrameCallback((_) {
          //     if (mounted && (ModalRoute.of(context)?.isCurrent ?? true)) {
          //       _isLoadingDialogVisible = true;
          //       debugPrint('Showing loading dialog...');
          //       _showLoadingDialog(context);
          //     }
          //   });
          // } else if (!_isLoading && _isLoadingDialogVisible) {
          //   if (Navigator.canPop(context)) {
          //     debugPrint('Closing loading dialog...');
          //     Navigator.of(context).pop();
          //   }
          //   _isLoadingDialogVisible = false;
          // }

          final travelState = Provider.of<RegisterTravelProvider>(context);

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
                markers: _markers,
                // myLocationButtonEnabled: false,
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
              if (travelState.areStopsValid)
                Positioned(
                  bottom: 30,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 64,
                      ),
                    ),
                    onPressed: () async {
                      final travelState = Provider.of<RegisterTravelProvider>(
                        context,
                        listen: false,
                      );

                      unawaited(
                        Navigator.pushReplacementNamed(
                          context,
                          RegisterTravelPage.routeName,
                        ),
                      );
                    },
                    child: Text(as.finish, style: TextStyle(fontSize: 22)),
                  ),
                ),
            ],
          );
        },
      ),

      /// TODO: remove this
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
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

    final as = AppLocalizations.of(context)!;

    return ElevatedButton(
      onPressed: () async {
        final stop = TravelStop(place: place, experiences: experiences);

        travelState.addTravelStop(stop);

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
      },
      child: Text(as.register_stop),
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

    final as = AppLocalizations.of(context)!;

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
              return CustomDialog(
                title: as.travel_stop,
                content: Text(travelState.error!),
                isError: true,
              );
            },
          );

          return;
        }

        showDialog(
          context: context,
          builder: (context) {
            return CustomDialog(
              title: as.travel_stop,
              content: Text(as.stop_updated_successfully),
              isError: true,
            );
          },
        );
      },
      child: Text(as.update_stop),
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
  }

  @override
  Widget build(BuildContext context) {
    final travelState = Provider.of<RegisterTravelProvider>(
      context,
      listen: false,
    );

    final as = AppLocalizations.of(context)!;

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
              child: Text(as.arrive_date, style: TextStyle(fontSize: 16)),
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
                    builder: (context) => CustomDialog(
                      title: as.warning,
                      content: Text(as.err_you_must_select_arrive_date_first),
                      isError: true,
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
              child: Text(as.leave_date, style: const TextStyle(fontSize: 16)),
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

  final as = AppLocalizations.of(context)!;

  final display = place.display;

  final registeredStop = await showModalBottomSheet<TravelStop?>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          final selectedExperiences = travelState.selectedExperiences;

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
                    as.travel_start_location,
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
                  as.experiences,
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
                const Padding(padding: EdgeInsets.all(6)),

                // TextField(
                //   decoration: InputDecoration(hintText: as.other),
                //   onTapUpOutside: (_) => FocusScope.of(context).unfocus(),
                // ),
                // const Padding(padding: EdgeInsets.all(12)),

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
