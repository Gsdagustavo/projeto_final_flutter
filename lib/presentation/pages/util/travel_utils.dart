import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/travel.dart';
import '../../../domain/entities/travel_stop.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/map_markers_provider.dart';
import '../../providers/register_travel_provider.dart';
import '../../providers/travel_list_provider.dart';
import '../../widgets/loading_dialog.dart';
import '../../widgets/modals.dart';

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
  debugPrint('Context on onTravelDeleted call: $context');

  final as = AppLocalizations.of(context)!;

  final result = await showDialog<bool>(
    context: context,
    builder: (context) => DeleteModal(
      message: as.delete_travel_confirmation(travel.travelTitle),
      title: as.delete_travel,
    ),
  );

  debugPrint('Context after delete modal: $context');

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

  await showDialog(
    context: context,
    builder: (context) => SuccessModal(message: as.travel_stop_removed),
  );

  return true;
}
