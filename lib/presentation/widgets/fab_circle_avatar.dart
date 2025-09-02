import 'package:flutter/material.dart';

class FabCircleAvatar extends StatelessWidget {
  const FabCircleAvatar({
    super.key,
    this.child,
    this.backgroundImage,
    this.radius = 20,
  });

  final Widget? child;
  final ImageProvider<Object>? backgroundImage;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      foregroundColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      backgroundImage: backgroundImage,
      radius: radius,
      child: child,
    );
  }
}
