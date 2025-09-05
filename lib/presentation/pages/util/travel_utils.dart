import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/travel.dart';
import '../../../l10n/app_localizations.dart';
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

  final state = context.read<TravelListProvider>();
  //
  // await showLoadingDialog(
  //   context: context,
  //   function: () async => await state.deleteTravel(travel),
  // );

  await state.deleteTravel(travel);

  debugPrint('Context after loading dialog call: $context');

  if (!context.mounted) return;

  await showDialog(
    context: context,
    builder: (context) => SuccessModal(message: as.travel_deleted),
  );

  if (popContext) {
    Navigator.of(context).pop();
  }
}
