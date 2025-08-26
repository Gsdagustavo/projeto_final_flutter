import 'package:flutter/material.dart';

import 'fab_app_bar.dart';

class FabPage extends StatelessWidget {
  const FabPage({
    super.key,
    required this.body,
    required this.title,
    this.floatingActionButton,
  });

  final Widget body;
  final String title;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        floatingActionButton: floatingActionButton,
        body: CustomScrollView(
          slivers: [
            FabAppBar(title: title),
            SliverToBoxAdapter(child: body),
          ],
        ),
      ),
    );
  }
}
