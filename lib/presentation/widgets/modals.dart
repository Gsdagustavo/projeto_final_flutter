import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../l10n/app_localizations.dart';

/// Returns the text style used for modal content.
TextStyle? _modalContentTextStyle(BuildContext context) {
  return Theme.of(context).textTheme.bodyMedium;
}

/// Returns the text style used for modal titles.
TextStyle? _modalTitleTextStyle(BuildContext context) {
  return Theme.of(context).textTheme.titleLarge;
}

/// Icon displayed in the [SuccessModal].
class _SuccessIcon extends StatelessWidget {
  const _SuccessIcon();

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.green.shade200,
      child: Icon(Icons.check_circle_outline, color: Colors.green.shade800),
    );
  }
}

/// Icon displayed in the [ErrorModal].
class _ErrorIcon extends StatelessWidget {
  const _ErrorIcon();

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.red.shade200,
      child: Icon(FontAwesomeIcons.circleXmark, color: Colors.red.shade800),
    );
  }
}

/// Icon displayed in the [WarningModal].
class _WarningIcon extends StatelessWidget {
  const _WarningIcon();

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.yellow.shade200,
      child: Icon(Icons.warning_amber_outlined, color: Colors.yellow.shade800),
    );
  }
}

/// Base dialog used by all modals, providing icon, content, and actions.
class _BaseDialog extends StatelessWidget {
  /// The icon displayed inside the circle avatar at the top of the dialog.
  final Widget icon;

  /// The main content of the dialog.
  final Widget content;

  /// The list of actions displayed at the bottom of the dialog.
  final List<Widget> actions;

  /// Optional background color for the circle avatar.
  final Color? circleAvatarBackgroundColor;

  const _BaseDialog({
    required this.icon,
    required this.content,
    required this.actions,
    this.circleAvatarBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: CircleAvatar(
        backgroundColor: circleAvatarBackgroundColor,
        child: icon,
      ),
      content: content,
      actions: actions,
    );
  }
}

/// A modal dialog indicating a successful operation.
class SuccessModal extends StatelessWidget {
  /// The message displayed in the modal.
  final String message;

  /// Constant constructor
  const SuccessModal({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;

    return _BaseDialog(
      icon: const _SuccessIcon(),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          Text(as.success, style: _modalTitleTextStyle(context)),
          Text(message, style: _modalContentTextStyle(context)),
        ],
      ),
      actions: [
        _BaseElevatedButton(
          buttonColor: Colors.green,
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text(as.great),
        ),
      ],
    );
  }
}

/// A modal dialog indicating an error.
class ErrorModal extends StatelessWidget {
  /// The error message displayed in the modal.
  final String message;

  /// Constant constructor
  const ErrorModal({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;

    return _BaseDialog(
      icon: const _ErrorIcon(),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          Text(as.error_occurred, style: _modalContentTextStyle(context)),
          Text(message, style: _modalContentTextStyle(context)),
        ],
      ),
      actions: [
        _BaseElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(as.ok),
        ),
      ],
    );
  }
}

/// A warning modal with options to continue or cancel.
///
/// Pops `true` if the user taps Continue, `false` if Cancel.
class WarningModal extends StatelessWidget {
  /// The warning message displayed in the modal.
  final String message;

  /// Constant constructor
  const WarningModal({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;

    return _BaseDialog(
      icon: const _WarningIcon(),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          Text(as.warning, style: _modalTitleTextStyle(context)),
          Text(message, style: _modalContentTextStyle(context)),
        ],
      ),
      actions: [
        _BaseElevatedButton(
          buttonColor: Colors.red,
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text(as.continue_label),
        ),
        _BaseElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(as.cancel),
        ),
      ],
    );
  }
}

/// A modal dialog for confirming deletion.
///
/// Pops `true` if deletion is confirmed, otherwise `false`.
class DeleteModal extends StatelessWidget {
  /// Title of the deletion dialog.
  final String title;

  /// Message describing what will be deleted.
  final String message;

  /// Constant constructor
  const DeleteModal({super.key, required this.message, required this.title});

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;

    return _BaseDialog(
      circleAvatarBackgroundColor: Colors.red.shade200,
      icon: Icon(Icons.delete_outline, color: Colors.red.shade800),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          Text(title, style: _modalTitleTextStyle(context)),
          Text(message, style: _modalContentTextStyle(context)),
        ],
      ),
      actions: [
        _BaseElevatedButton(
          buttonColor: Colors.red,
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text(as.delete),
        ),
        _BaseElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(as.cancel),
        ),
      ],
    );
  }
}

/// Modal dialog asking the user to confirm sign out.
///
/// Pops `true` if sign out is confirmed, otherwise `false`.
class SignOutModal extends StatelessWidget {
  /// Constant constructor
  const SignOutModal({super.key});

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;

    return _BaseDialog(
      circleAvatarBackgroundColor: Colors.amber.shade200,
      icon: Icon(Icons.logout, color: Colors.amber.shade800),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          Text(as.sign_out_question, style: _modalContentTextStyle(context)),
          Text(as.sign_out_confirmation, style: _modalTitleTextStyle(context)),
        ],
      ),
      actions: [
        _BaseElevatedButton(
          buttonColor: Colors.red,
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text(as.sign_out),
        ),
        const Padding(padding: EdgeInsets.all(6)),
        _BaseElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(as.stay_signed_in),
        ),
      ],
    );
  }
}

/// Modal shown when there is no internet connection.
///
/// Pops `true` if user tries to reconnect, otherwise `false`.
class NoInternetModal extends StatelessWidget {
  /// Constant constructor
  const NoInternetModal({super.key});

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;

    return _BaseDialog(
      circleAvatarBackgroundColor: Colors.red.shade200,
      icon: Icon(
        Icons.signal_wifi_connected_no_internet_4_outlined,
        color: Colors.red.shade800,
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          Text(as.no_internet, style: _modalTitleTextStyle(context)),
          Text(as.no_internet_message, style: _modalContentTextStyle(context)),
        ],
      ),
      actions: [
        _BaseElevatedButton(
          buttonColor: Colors.red,
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text('Try Again'),
        ),
        const Padding(padding: EdgeInsets.all(6)),
        _BaseElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text('Continue Offline'),
        ),
      ],
    );
  }
}

/// Modal with "Ok" and "Cancel" buttons.
///
/// Pops `true` if user taps Ok, otherwise `false`.
class OkCancelModal extends StatelessWidget {
  /// The title of the dialog.
  final String title;

  /// The content of the dialog.
  final String content;

  /// Constant constructor
  const OkCancelModal({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;

    return _BaseDialog(
      circleAvatarBackgroundColor: Colors.blue.shade200,
      icon: Icon(FontAwesomeIcons.circleQuestion, color: Colors.blue.shade800),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          Text(title, style: _modalTitleTextStyle(context)),
          Text(content, style: _modalContentTextStyle(context)),
        ],
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: _BaseElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(as.cancel),
              ),
            ),
            const Padding(padding: EdgeInsets.all(6)),
            Expanded(
              child: _BaseElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(as.ok),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Base button used in modals.
class _BaseElevatedButton extends StatelessWidget {
  /// The child widget of the button.
  final Widget child;

  /// Optional background color for the button.
  final Color? buttonColor;

  /// Callback triggered when the button is pressed.
  final VoidCallback onPressed;

  const _BaseElevatedButton({
    required this.child,
    this.buttonColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final style = ElevatedButton.styleFrom(backgroundColor: buttonColor);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(onPressed: onPressed, style: style, child: child),
    );
  }
}

SnackBar _baseSnackBar({
  required Color backgroundColor,
  required Widget icon,
  required String message,
  Duration duration = const Duration(seconds: 4),
  SnackBarBehavior behavior = SnackBarBehavior.floating,
}) {
  return SnackBar(
    margin: EdgeInsets.all(12),
    padding: EdgeInsets.all(12),
    content: Row(
      spacing: 12,
      children: [
        icon,
        Expanded(child: Text(message)),
      ],
    ),
    duration: duration,
    backgroundColor: backgroundColor,
    behavior: behavior,
  );
}

/// Shows a green snack bar with a success message.
void showSuccessSnackBar(BuildContext context, String message) {
  final snackBar = _baseSnackBar(
    icon: _SuccessIcon(),
    message: message,
    backgroundColor: Colors.green.shade400,
  );

  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(snackBar);
}

/// Shows a red snack bar with an error message.
void showErrorSnackBar(BuildContext context, String message) {
  final snackBar = _baseSnackBar(
    icon: _ErrorIcon(),
    message: message,
    backgroundColor: Colors.red.shade400,
  );

  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(snackBar);
}

/// Shows a yellow snack bar with a warning message.
void showWarningSnackBar(BuildContext context, String message) {
  final snackBar = _baseSnackBar(
    icon: _WarningIcon(),
    message: message,
    backgroundColor: Colors.yellow.shade400,
  );

  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(snackBar);
}
