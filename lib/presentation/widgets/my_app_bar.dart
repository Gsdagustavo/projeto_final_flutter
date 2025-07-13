import 'package:flutter/material.dart';

import 'toggle_dark_mode_icon_button.dart';

/// This widget is a custom [AppBar] that is used in [FabPage]
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key, required this.title, this.actions});

  final String title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),

      centerTitle: true,

      actions: [ToggleDarkModeIconButton(), ...?actions],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
