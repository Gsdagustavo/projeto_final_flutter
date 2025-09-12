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

const int _loadingDialogDelay = 150; // ms

/// Shows a modal dialog with a loading spinner while [function] executes.
/// Automatically closes the dialog when the function completes.
///
/// Example:
/// ```dart
/// await showLoadingDialog(
///   context: context,
///   function: () async {
///     await myAsyncFunction();
///   },
/// );
/// ```
Future<T?> showLoadingDialog<T>({
  required BuildContext context,
  required Future<T> Function() function,
}) async {
  final rootContext = Navigator.of(context, rootNavigator: true).context;

  unawaited(
    showDialog(
      context: rootContext,
      barrierDismissible: false,
      builder: (_) => const Center(child: LoadingDialog()),
    ),
  );

  await Future.delayed(const Duration(milliseconds: _loadingDialogDelay));

  final result = await function();

  if (!rootContext.mounted) return result;

  if (Navigator.of(rootContext, rootNavigator: true).canPop()) {
    Navigator.of(rootContext, rootNavigator: true).pop();
  }

  return result;
}
