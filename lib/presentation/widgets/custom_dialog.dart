import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    required this.title,
    this.isError = false,
    required this.content,
  });

  final String title;
  final Widget content;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final Icon icon;

    if (isError) {
      icon = Icon(Icons.error, color: Colors.red  );
    } else {
      icon = Icon(Icons.check, color: Colors.green);
    }

    return AlertDialog(
      title: title.isNotEmpty ? Text(title) : null,
      icon: icon,
      content: content,
    );
  }
}
