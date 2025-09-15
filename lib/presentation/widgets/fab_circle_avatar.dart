import 'dart:io';

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
  /// [imageFile] is used for file-based images.
  /// [assetPath] is used for asset-based images.
  /// [radius] specifies the size of the avatar. Default is 20.
  const FabCircleAvatar({
    super.key,
    this.child,
    this.backgroundImage,
    this.imageFile,
    this.assetPath,
    this.radius = 20,
  });

  /// Optional child widget displayed on top of the avatar.
  final Widget? child;

  /// Optional background image of the avatar.
  final ImageProvider<Object>? backgroundImage;

  /// Optional file image for the avatar.
  final File? imageFile;

  /// Optional asset path for the avatar.
  final String? assetPath;

  /// The radius of the avatar.
  final double radius;

  ImageProvider<Object>? get _effectiveBackgroundImage {
    if (backgroundImage != null) return backgroundImage;
    if (imageFile != null) return FileImage(imageFile!);
    if (assetPath != null) return AssetImage(assetPath!);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundImage = _effectiveBackgroundImage;

    if (effectiveBackgroundImage != null) {
      return CircleAvatar(
        foregroundColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        backgroundImage: effectiveBackgroundImage,
        radius: radius,
        child: child,
      );
    }

    // If no image is provided, use ClipOval to ensure circular clipping
    return ClipOval(
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: const BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: child,
      ),
    );
  }
}
