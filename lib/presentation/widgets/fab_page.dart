import 'package:flutter/material.dart';

import 'theme_toggle_button.dart';

/// A Fab page util that is used in many pages of the app
class FabPage extends StatelessWidget {
  /// Const constructor
  const FabPage({
    super.key,
    required this.children,
    this.floatingActionButton,
    required this.title,
  });

  /// A list of children widgets or slivers
  final List<Widget> children;

  final String title;

  /// Optional FAB
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            snap: false,
            floating: false,
            title: Text(
              title,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            expandedHeight: 120,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            actions: const [ThemeToggleButton()],
          ),

          ...children.map((child) {
            if (_isSliver(child)) {
              return child;
            } else {
              return SliverToBoxAdapter(child: child);
            }
          }),
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }

  bool _isSliver(Widget widget) {
    return widget is SliverList ||
        widget is SliverGrid ||
        widget is SliverToBoxAdapter ||
        widget is SliverFillRemaining;
  }
}
