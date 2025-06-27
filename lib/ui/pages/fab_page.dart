import 'package:flutter/material.dart';
import 'package:projeto_final_flutter/ui/widgets/my_app_bar.dart';

import '../widgets/bottom_navigation_bar.dart';

class FabPage extends StatelessWidget {
  const FabPage({
    super.key,
    required this.body,
    required this.pageIndex,
    required this.title,
  });

  final String title;
  final Widget body;
  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: title),
      body: body,
      bottomNavigationBar: MyBottomNavigationBar(currentIndex: pageIndex),
    );
  }
}
