import 'package:flutter/material.dart';

import 'fab_app_bar.dart';

/// A reusable page widget with a floating app bar and optional floating action
/// button.
///
/// This widget wraps the content in a [CustomScrollView] with a [FabAppBar] at
///  the top.
///
/// It supports additional slivers, custom scroll physics, and automatically
/// dismisses the keyboard when tapping outside text fields.
class FabPage extends StatelessWidget {
  /// Creates a [FabPage].
  ///
  /// [body] is the main content of the page.
  /// [title] is displayed in the [FabAppBar].
  /// [floatingActionButton] is optional and displayed above the body.
  /// [physics] allows customizing the scroll physics of the page.
  /// [slivers] allows adding additional slivers between the app bar and the
  /// body.
  const FabPage({
    super.key,
    required this.body,
    required this.title,
    this.floatingActionButton,
    this.physics,
    this.slivers,
  });

  /// The main content of the page.
  final Widget body;

  /// The title displayed in the [FabAppBar].
  final String title;

  /// Optional floating action button displayed above the body.
  final Widget? floatingActionButton;

  /// Optional scroll physics for the page's scroll view.
  final ScrollPhysics? physics;

  /// Optional list of slivers to insert between the app bar and the body.
  final List<Widget>? slivers;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(
        context,
      ).unfocus, // Dismiss keyboard when tapping outside
      child: Scaffold(
        floatingActionButton: floatingActionButton,
        body: CustomScrollView(
          physics: physics,
          slivers: [
            FabAppBar(title: title),
            if (slivers != null && slivers!.isNotEmpty) ...slivers!,
            SliverToBoxAdapter(child: body),
          ],
        ),
      ),
    );
  }
}
