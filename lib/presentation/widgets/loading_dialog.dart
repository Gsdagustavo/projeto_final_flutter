import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

const _loadingAnimationPath = 'assets/animations/loading.json';

/// A full-screen widget that displays a Lottie loading animation.
///
/// Can be used as a custom dialog to indicate a background process is running.
class LoadingDialog extends StatelessWidget {
  /// Creates a [LoadingDialog].
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Lottie.asset(
        _loadingAnimationPath,
        width: MediaQuery.of(context).size.width / 2,
        height: MediaQuery.of(context).size.height / 2,
        backgroundLoading: true,
        fit: BoxFit.contain,
      ),
    );
  }
}

/// Shows a modal loading dialog while executing an asynchronous function.
///
/// The dialog will prevent user interaction (`barrierDismissible: false`)
/// and automatically closes when the [function] completes.
///
/// Returns the result of [function].
///
/// Example usage:
/// ```dart
/// final result = await showLoadingDialog(
///   context: context,
///   function: () async {
///     return await fetchData();
///   },
/// );
/// ```
Future<T> showLoadingDialog<T>({
  required BuildContext context,
  required Future<T> Function() function,
}) async {
  // Show the loading dialog, but don't await it (unawaited)
  unawaited(
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => const Center(child: LoadingDialog()),
    ),
  );

  // Small delay to ensure dialog is displayed
  await Future.delayed(const Duration(milliseconds: 100));

  // Execute the asynchronous function
  final item = await function();

  debugPrint('is context mounted: ${context.mounted}');

  if (!context.mounted) {
    debugPrint(
      'Context not mounted in showLoadingDialog. Returning item: $item',
    );
    return item;
  }

  // Close the loading dialog if it is still open
  if (Navigator.of(context, rootNavigator: true).canPop()) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  return item;
}
