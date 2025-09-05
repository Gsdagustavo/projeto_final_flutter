import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/travel.dart';
import '../../../domain/entities/travel_stop.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/map_markers_provider.dart';
import '../../providers/register_travel_provider.dart';
import '../../providers/travel_list_provider.dart';
import '../../widgets/modals.dart';

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

  // await showLoadingDialog(
  //   context: context,
  //   function: () async => await state.deleteTravel(travel),
  // );

  await state.deleteTravel(travel);

  debugPrint('Context after loading dialog call: $context');

  if (!context.mounted) return;

  if (popContext) {
    Navigator.of(context).pop();
  }
}

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
    builder: (context) => SuccessModal(
      /// TODO: intl
      message: 'Stop Removed Successfully!',
    ),
  );

  return true;
}
