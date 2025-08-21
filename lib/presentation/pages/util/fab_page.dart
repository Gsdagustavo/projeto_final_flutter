import 'package:flutter/material.dart';

import '../../widgets/my_app_bar.dart';

/// A Fab page util that is used in many pages of the app
class FabPage extends StatelessWidget {
  /// Const constructor
  const FabPage({
    super.key,
    required this.body,
    required this.title,
    this.floatingActionButton,
  });

  /// The title of the page
  ///
  /// Will be shown in the [MyAppBar]
  final String title;

  /// The body of the page
  final Widget body;

  /// An optional [FloatingActionButton]
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: title),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
