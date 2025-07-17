import 'package:flutter/material.dart';

import 'theme_toggle_button.dart';

/// This widget is a custom [AppBar] that is used in [FabPage]
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Constant constructor
  const MyAppBar({super.key, required this.title, this.actions});

  /// The title of the page that will be shown in the
  /// App Bar
  final String title;

  /// A list of widgets of all actions of the App Bar
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      // leading: null,
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),

      centerTitle: true,

      actions: [ThemeToggleButton(), ...?actions],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
