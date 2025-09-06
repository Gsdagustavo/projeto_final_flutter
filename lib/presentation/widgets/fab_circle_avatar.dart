import 'package:flutter/material.dart';

/// A customized [CircleAvatar] that supports transparent colors for both
/// foreground and background.
///
/// This widget is useful when you want to display a circular avatar without
/// the default fill colors, allowing the child or background image to blend
/// seamlessly with its surroundings.
///
/// Example usage:
/// ```dart
/// FabCircleAvatar(
///   radius: 30,
///   backgroundImage: NetworkImage('https://example.com/avatar.png'),
///   child: Icon(Icons.person),
/// )
/// ```
class FabCircleAvatar extends StatelessWidget {
  /// Creates a [FabCircleAvatar].
  ///
  /// [child] is displayed on top of the avatar.
  /// [backgroundImage] is used as the avatar's image.
  /// [radius] specifies the size of the avatar. Default is 20.
  const FabCircleAvatar({
    super.key,
    this.child,
    this.backgroundImage,
    this.radius = 20,
  });

  /// Optional child widget displayed on top of the avatar.
  final Widget? child;

  /// Optional background image of the avatar.
  final ImageProvider<Object>? backgroundImage;

  /// The radius of the avatar.
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      // Both colors set to transparent to avoid showing default CircleAvatar
      // colors
      foregroundColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      backgroundImage: backgroundImage,
      radius: radius,
      child: child,
    );
  }
}
