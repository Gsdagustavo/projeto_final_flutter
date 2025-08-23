import 'package:flutter/material.dart';

import 'my_app_bar.dart';

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
            pinned: false,
            expandedHeight: 120,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: Text(
              title,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),

          SliverToBoxAdapter(child: body),
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
