import 'package:flutter/material.dart';

/// This is a custom dialog that will be shown in auth contexts
/// (login, register, etc)
///
/// It requires a title ([String]) and a content ([Widget])
class CustomDialog extends StatelessWidget {
  /// Constant constructor
  const CustomDialog({
    super.key,
    required this.title,
    required this.content,
    this.isError = false,
    this.actions,
  });

  /// The title of the dialog
  final String title;

  /// The content of the dialog
  final Widget content;

  /// Whether the dialog is shown in an error context or not
  ///
  /// This has impact on how the dialog is shown to the user
  ///
  /// If the dialog is an error dialog, a [Icons.error] icon is shown, with
  /// a red color, representing that an error has occurred
  ///
  /// Otherwise, a [Icons.check] icon is shown, with
  /// a green color, representing that there are no errors
  final bool isError;

  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final Icon icon;

    if (isError) {
      icon = Icon(Icons.warning, color: Colors.orange, size: 40);
    } else {
      icon = Icon(Icons.check, color: Colors.green, size: 30);
    }

    final titleRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(title, style: TextStyle(fontSize: 26))),
        Padding(padding: const EdgeInsets.only(right: 20), child: icon),
      ],
    );

    return AlertDialog(
      title: title.isNotEmpty ? titleRow : icon,
      content: content,
      actions: actions,
    );
  }
}
