import 'package:flutter/material.dart';
import 'package:implicitly_animated_list/implicitly_animated_list.dart';

/// Default curve used for all animations in [FabAnimatedList].
const _defaultAnimationCurve = Curves.easeInOutQuad;

/// Default duration used for insert and delete animations in [FabAnimatedList].
const _defaultAnimationDuration = Duration(milliseconds: 750);

/// Wraps an [Animation] with a default curve and drives it from 0 to 1.
///
/// This is used internally by [_defaultAnimation] to provide a smooth
/// size and fade transition.
Animation<double> _driveDefaultAnimation(Animation<double> parent) {
  return CurvedAnimation(
    parent: parent,
    curve: _defaultAnimationCurve,
  ).drive(Tween<double>(begin: 0, end: 1));
}

/// The default animation for insertions and deletions in [FabAnimatedList].
///
/// Combines a [SizeTransition] and [FadeTransition] using
///  [_driveDefaultAnimation].
///
/// Can be overridden by passing a custom [AnimatedChildBuilder] to the widget.
Widget _defaultAnimation(
  BuildContext context,
  Widget child,
  Animation<double> animation,
) {
  return SizeTransition(
    sizeFactor: _driveDefaultAnimation(animation),
    child: FadeTransition(
      opacity: _driveDefaultAnimation(animation),
      child: child,
    ),
  );
}

/// A wrapper around [ImplicitlyAnimatedList] with configurable defaults for
/// insert and delete animations, durations, and scroll behavior.
///
/// Provides a simple, reusable way to create animated lists with optional
/// customization for transitions and equality checks.
class FabAnimatedList<T> extends StatelessWidget {
  /// Creates a [FabAnimatedList].
  ///
  /// [itemBuilder] and [itemData] are required. Optional parameters
  /// allow customization of animation durations, animation widgets,
  /// scroll behavior, and equality checking.
  const FabAnimatedList({
    super.key,
    required this.itemBuilder,
    required this.itemData,
    this.insertDuration,
    this.insertAnimation,
    this.deleteDuration,
    this.deleteAnimation,
    this.shrinkWrap = true,
    this.physics = const NeverScrollableScrollPhysics(),
    this.scrollDirection = Axis.vertical,
    this.itemEquality,
  });

  /// Builds each item in the list.
  ///
  /// Receives the [BuildContext] and the corresponding data of type [T].
  final Widget Function(BuildContext context, T data) itemBuilder;

  /// The data to display in the list.
  ///
  /// Each element of type [T] will be rendered using [itemBuilder].
  final List<T> itemData;

  /// Whether the list should shrink-wrap its contents.
  ///
  /// Defaults to `true`. Pass `false` to let the list expand to fill available
  /// space.
  final bool shrinkWrap;

  /// Scroll physics of the list.
  ///
  /// Defaults to [NeverScrollableScrollPhysics], which disables scrolling.
  final ScrollPhysics? physics;

  /// Scroll direction of the list. Defaults to [Axis.vertical].
  final Axis scrollDirection;

  /// Duration of the insert animation.
  ///
  /// If not provided, [_defaultAnimationDuration] is used.
  final Duration? insertDuration;

  /// Builder for the insert animation.
  ///
  /// If not provided, [_defaultAnimation] is used.
  final AnimatedChildBuilder? insertAnimation;

  /// Duration of the delete animation.
  ///
  /// If not provided, [_defaultAnimationDuration] is used.
  final Duration? deleteDuration;

  /// Builder for the delete animation.
  ///
  /// If not provided, [_defaultAnimation] is used.
  final AnimatedChildBuilder? deleteAnimation;

  /// Optional equality function to determine whether two items are the same.
  ///
  /// Used by [ImplicitlyAnimatedList] to prevent unnecessary insert/remove animations.
  /// If `null`, the default is reference equality (`identical`).
  final bool Function(T a, T b)? itemEquality;

  @override
  Widget build(BuildContext context) {
    return ImplicitlyAnimatedList<T>(
      itemBuilder: itemBuilder,
      itemData: itemData,
      shrinkWrap: shrinkWrap,
      physics: physics,
      scrollDirection: scrollDirection,
      insertDuration: insertDuration ?? _defaultAnimationDuration,
      insertAnimation: insertAnimation ?? _defaultAnimation,
      deleteDuration: deleteDuration ?? _defaultAnimationDuration,
      deleteAnimation: deleteAnimation ?? _defaultAnimation,
      itemEquality: itemEquality,
    );
  }
}
