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
  final dialogContext = context;

  showDialog(
    barrierDismissible: false,
    context: dialogContext,
    builder: (_) {
      return const Center(child: LoadingDialog());
    },
  );

  await Future.delayed(const Duration(milliseconds: 100));

  final item = await function();

  if (Navigator.of(dialogContext, rootNavigator: true).canPop()) {
    Navigator.of(dialogContext, rootNavigator: true).pop();
  }

  return item;
}
