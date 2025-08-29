import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

const _loadingAnimationPath = 'assets/animations/loading.json';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width / 2,
        maxHeight: MediaQuery.of(context).size.height / 2,
      ),
      child: Lottie.asset(_loadingAnimationPath),
    );
  }
}
