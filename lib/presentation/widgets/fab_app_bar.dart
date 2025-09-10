import 'package:flutter/material.dart';

import 'theme_toggle_button.dart';

/// A custom AppBar widget with a floating design and a theme toggle button.
///
/// This widget uses a [SliverAppBar] with a fixed expanded height and includes
/// a [ThemeToggleButton] in the actions. It is designed to be used in
/// scrollable layouts that support slivers (e.g., [CustomScrollView]).
class FabAppBar extends StatelessWidget {
  /// Creates a [FabAppBar] with the given [title].
  const FabAppBar({super.key, required this.title});

  /// The text displayed in the AppBar's title.
  final String title;

  static const bool _floating = false;
  static const bool _snap = false;
  static const double _expandedHeight = 80;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: _floating,
      snap: _snap,
      expandedHeight: _expandedHeight,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(title, style: Theme.of(context).textTheme.headlineLarge),
      actions: const [ThemeToggleButton()],
    );
  }
}
