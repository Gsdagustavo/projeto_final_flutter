import 'package:flutter/material.dart';
import 'package:projeto_final_flutter/widgets/bottom_navigation_bar.dart';

class FabPage extends StatelessWidget {
  const FabPage({super.key, required this.body, required this.pageIndex});

  final Widget body;
  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: MyBottomNavigationBar(currentIndex: pageIndex),
    );
  }
}
