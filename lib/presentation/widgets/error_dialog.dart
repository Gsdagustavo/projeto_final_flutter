import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({
    super.key,
    required this.errorMsg,
    this.icon = const Icon(Icons.warning, color: Colors.orange),
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
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Wrap(children: [Text(title)]),
          icon,
        ],
      ),
      content: Text(errorMsg.toString()),
      icon: icon,
      actions: actions,
    );
  }
}
