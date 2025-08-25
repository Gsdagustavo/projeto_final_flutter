import 'package:flutter/material.dart';

import 'theme_toggle_button.dart';

class FabAppBar extends StatelessWidget {
  const FabAppBar({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: false,
      snap: false,
      expandedHeight: 120,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(title, style: Theme.of(context).textTheme.headlineLarge),
      actions: const [ThemeToggleButton()],
    );
  }
}
