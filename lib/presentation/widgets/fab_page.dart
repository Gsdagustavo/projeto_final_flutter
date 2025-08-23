import 'package:flutter/material.dart';

import 'my_app_bar.dart';
import 'theme_toggle_button.dart';

/// A Fab page util that is used in many pages of the app
class FabPage extends StatelessWidget {
  /// Const constructor
  const FabPage({
    super.key,
    required this.body,
    required this.title,
    this.floatingActionButton,
    this.pageIcon,
  });

  /// The title of the page
  ///
  /// Will be shown in the [MyAppBar]
  final String title;

  /// The body of the page
  final Widget body;

  /// An optional [FloatingActionButton]
  final Widget? floatingActionButton;

  final Icon? pageIcon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            snap: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(title, style: Theme.of(context).textTheme.titleLarge),
            ),
            expandedHeight: 140,
            backgroundColor: Theme.of(context).primaryColor,
            actions: [const ThemeToggleButton()],
          ),

          SliverToBoxAdapter(child: body),
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
