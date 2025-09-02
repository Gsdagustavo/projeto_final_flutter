import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/travel.dart';
import '../../providers/travel_list_provider.dart';
import '../../widgets/loading_dialog.dart';
import '../../widgets/ok_cancel_dialog.dart';

Future<void> onTravelDeleted(
  BuildContext context,
  Travel travel, {
  bool popContext = true,
}) async {
  final result = await showOkCancelDialog(
    context,
    title: Text(
      'Do you really want to delete the travel ${travel.travelTitle}?',
    ),
  );

  if (result == null || !result) return;

  final state = context.read<TravelListProvider>();

  await showLoadingDialog(
    context: context,
    function: () async => await state.deleteTravel(travel),
  );

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Travel deleted successfully!'),
            Icon(Icons.check, color: Colors.green),
          ],
        ),
      );
    },
  );

  if (popContext) {
    context.pop();
  }
}
