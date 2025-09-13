import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../core/extensions/date_extensions.dart';
import '../../../core/extensions/experience_map_extension.dart';
import '../../../core/extensions/place_extensions.dart';
import '../../../core/extensions/travel_stop_extensions.dart';
import '../../../domain/entities/enums.dart';
import '../../../domain/entities/place.dart';
import '../../../domain/entities/travel.dart';
import '../../../domain/entities/travel_stop.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/location_service.dart';
import '../../extensions/enums_extensions.dart';
import '../../providers/map_markers_provider.dart';
import '../../providers/register_travel_provider.dart';
import '../../providers/travel_list_provider.dart';
import '../../providers/user_preferences_provider.dart';
import '../../util/app_router.dart';
import '../../widgets/loading_dialog.dart';
import '../../widgets/modals.dart';
import 'ui_utils.dart';

/// Handles the deletion of a [Travel].
///
/// Displays a confirmation dialog before proceeding. If the user confirms, the
/// travel is deleted through [TravelListProvider]. After deletion, the context
/// may be popped (navigated back).
///
/// Parameters:
/// - [context]: The current [BuildContext].
/// - [travel]: The [Travel] instance to delete.
/// - [popContext]: Whether to pop the context after deletion (default: `true`).
///
/// Returns a [Future] that completes once the deletion and optional navigation
/// are finished.
Future<void> onTravelDeleted(
  BuildContext context,
  Travel travel, {
  bool popContext = true,
}) async {
  final as = AppLocalizations.of(context)!;

  final result = await showDialog<bool>(
    context: context,
    builder: (context) => DeleteModal(
      message: as.delete_travel_confirmation(travel.travelTitle),
      title: as.delete_travel,
    ),
  );

  if (result == null || !result) return;

  if (!context.mounted) return;

  final state = context.read<TravelListProvider>();

  await showLoadingDialog(
    context: context,
    function: () async => await state.deleteTravel(travel),
  );

  if (!context.mounted) return;

  await showDialog(
    context: context,
    builder: (context) => SuccessModal(message: 'Travel Deleted Successfully!'),
  );

  if (popContext) {
    if (!context.mounted) return;

    Navigator.of(context).pop();
  }
}

/// Handles the removal of a [TravelStop] from the currently registered travel.
///
/// Displays a confirmation dialog before removing. If confirmed:
/// - Removes the stop from [RegisterTravelProvider].
/// - Removes the marker from [MapMarkersProvider].
///
/// After successful removal, a success modal is displayed.
///
/// Parameters:
/// - [context]: The current [BuildContext].
/// - [stop]: The [TravelStop] instance to remove.
///
/// Returns a [Future] that resolves to:
/// - `true` if the stop was removed.
/// - `false` if the user canceled the action.
Future<bool> onStopRemoved(BuildContext context, TravelStop stop) async {
  final travelState = Provider.of<RegisterTravelProvider>(
    context,
    listen: false,
  );
  final markersState = Provider.of<MapMarkersProvider>(context, listen: false);

  final as = AppLocalizations.of(context)!;

  final remove = await showDialog<bool>(
    context: context,
    builder: (context) {
      return DeleteModal(
        title: as.remove_stop,
        message: as.remove_stop_confirmation,
      );
    },
  );

  if (remove != null && remove) {
    travelState.removeTravelStop(stop);
    markersState.removeMarker(stop);
  } else {
    return false;
  }

  if (!context.mounted) return true;

  showSuccessSnackBar(context, as.travel_stop_removed);

  return true;
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

    final as = AppLocalizations.of(context)!;

    showSuccessSnackBar(context, as.stop_updated_successfully);

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

    showSuccessSnackBar(context, as.stop_added);

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
              spacing: 12,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on),
                    Text(
                      useStop ? as.update_stop : as.add_stop,
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
                const Padding(padding: EdgeInsets.all(2)),
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
                Padding(padding: EdgeInsets.all(6)),
                Text(
                  as.planned_experiences,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final experience = Experience.values[index];
                    final experienceIcon = experiencesIcons()[experience];

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
                              : Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                      trailing: _selectedExperiences[experience] == true
                          ? const Icon(Icons.check, color: Colors.green)
                          : const SizedBox.shrink(),
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
