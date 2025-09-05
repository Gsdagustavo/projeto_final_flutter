import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

const _loadingAnimationPath = 'assets/animations/loading.json';

class LoadingDialog extends StatelessWidget {
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

Future<T> showLoadingDialog<T>({
  required BuildContext context,
  required Future<T> Function() function,
}) async {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) {
      return const Center(child: LoadingDialog());
    },
  );

  await Future.delayed(const Duration(milliseconds: 100));

  final item = await function();

  debugPrint('is context mounted: ${context.mounted}');

  if (!context.mounted) {
    debugPrint(
      'Context not mounted in showLoadingDialog. Returning item: $item',
    );
    return item;
  }

  debugPrint(
    'Can pop loading dialog: ${Navigator.of(context, rootNavigator: true).canPop()}',
  );

  if (Navigator.of(context, rootNavigator: true).canPop()) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  return item;
}
