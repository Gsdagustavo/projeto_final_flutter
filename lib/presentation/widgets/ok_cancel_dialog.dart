import 'package:flutter/material.dart';

class OkCancelDialog extends StatelessWidget {
  const OkCancelDialog({
    super.key,
    required this.title,
    this.content,
    this.cancelText = 'Cancel',
    this.okText = 'Ok',
  });

  final Widget title;
  final Widget? content;
  final String cancelText;
  final String okText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: content,
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(cancelText),
        ),

        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text(okText),
        ),
      ],
    );
  }
}

Future<bool?> showOkCancelDialog(
  BuildContext context, {
  required Widget title,
  Widget? content,
}) async {
  return await showDialog<bool>(
    context: context,
    builder: (context) {
      return OkCancelDialog(title: title, content: content);
    },
  );
}
