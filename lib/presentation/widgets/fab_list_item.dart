import 'package:flutter/material.dart';

class FabListItem extends StatelessWidget {
  const FabListItem({super.key, required this.content});

  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).primaryColor.withOpacity(0.25),
        ),
        child: content,
      ),
    );
  }
}
