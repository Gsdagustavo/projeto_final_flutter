import 'package:flutter/material.dart';
import 'package:projeto_final_flutter/providers/theme_provider.dart';
import 'package:provider/provider.dart';

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
