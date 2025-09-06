import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// A reusable widget to display a Lottie animation for authentication FABs or
/// similar.
///
/// This widget allows you to provide a Lottie [asset] and optionally set
/// [width] and [height].
class FabAuthAnimation extends StatelessWidget {
  /// Constant constructor
  const FabAuthAnimation({
    super.key,
    required this.asset,
    this.width,
    this.height,
  });

  /// The path to the Lottie animation asset.
  final String asset;

  /// Optional width of the animation.
  final double? width;

  /// Optional height of the animation.
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      asset,
      width: width,
      height: height,
      repeat: true, // keeps looping the animation
      fit: BoxFit.cover,
    );
  }
}
