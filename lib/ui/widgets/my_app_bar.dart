import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

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

      actions: [
        Consumer<ThemeProvider>(
          builder: (_, themeState, __) {
            return IconButton(
              onPressed: themeState.toggleTheme,
              icon: Icon(
                themeState.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              ),
            );
          },
        ),

        ...?actions,
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
