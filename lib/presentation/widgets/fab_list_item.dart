import 'package:flutter/material.dart';

class FabListItem extends StatelessWidget {
  const FabListItem({super.key, required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).primaryColor.withOpacity(0.25),
        ),
        child: child,
      ),
    );
  }
}
