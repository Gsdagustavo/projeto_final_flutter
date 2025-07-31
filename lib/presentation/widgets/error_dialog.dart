import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({
    super.key,
    required this.errorMsg,
    this.icon = const Icon(Icons.warning, color: Colors.red),
    this.title = 'Error',
    this.actions = const [],
  });

  final String errorMsg;
  final String title;
  final Icon icon;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(errorMsg.toString()),
      icon: icon,
      actions: actions,
    );
  }
}
