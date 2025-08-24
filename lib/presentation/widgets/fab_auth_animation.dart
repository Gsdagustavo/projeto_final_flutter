import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FabAuthAnimation extends StatelessWidget {
  const FabAuthAnimation({
    super.key,
    required this.asset,
    this.width,
    this.height,
  });

  final String asset;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      asset,
      width: width,
      height: height,
      repeat: true,
      fit: BoxFit.cover,
    );
  }
}
