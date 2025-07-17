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

  @override
  Widget build(BuildContext context) {
    final Icon icon;

    if (isError) {
      icon = Icon(Icons.error, color: Colors.red);
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
