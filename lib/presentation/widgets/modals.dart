import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../l10n/app_localizations.dart';

TextStyle? modalContentTextStyle(BuildContext context) {
  return Theme.of(context).textTheme.bodyMedium;
}

TextStyle? modalTitleTextStyle(BuildContext context) {
  return Theme.of(context).textTheme.titleLarge;
}

class _BaseDialog extends StatelessWidget {
  const _BaseDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
    this.insetPadding,
    this.alignment,
    this.actionsAlignment,
    this.actionsPadding,
    this.circleAvatarBackgroundColor,
    this.circleAvatarForegroundColor,
  });

  final Widget title;
  final Widget content;
  final List<Widget> actions;
  final EdgeInsets? insetPadding;
  final Alignment? alignment;
  final MainAxisAlignment? actionsAlignment;
  final EdgeInsets? actionsPadding;
  final Color? circleAvatarBackgroundColor;
  final Color? circleAvatarForegroundColor;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: CircleAvatar(
        backgroundColor: circleAvatarBackgroundColor,
        foregroundColor: circleAvatarForegroundColor,
        child: title,
      ),
      content: content,
      actionsPadding: actionsPadding,
      actionsAlignment: actionsAlignment,
      actions: actions,
      insetPadding: insetPadding,
      alignment: alignment,
    );
  }
}

class SuccessModal extends StatelessWidget {
  const SuccessModal({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;

    return _BaseDialog(
      circleAvatarBackgroundColor: Colors.green.shade200,
      title: Icon(Icons.check_circle_outline, color: Colors.green.shade800),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          Text('Success!', style: modalTitleTextStyle(context)),
          Text(message, style: modalContentTextStyle(context)),
        ],
      ),
      actions: [
        _BaseElevatedButton(
          buttonColor: Colors.green,
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text('Great!'),
        ),
      ],
    );
  }
}

class ErrorModal extends StatelessWidget {
  const ErrorModal({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;

    return _BaseDialog(
      circleAvatarBackgroundColor: Colors.red.shade200,
      title: Icon(FontAwesomeIcons.xmarkCircle, color: Colors.red.shade800),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          Text('Error Occurred', style: modalContentTextStyle(context)),
          Text(message, style: modalContentTextStyle(context)),
        ],
      ),
      actions: [
        _BaseElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Ok'),
        ),
      ],
    );
  }
}

/// Pops [true] if the user taps [Continue]. Otherwise, returns [false]
class WarningModal extends StatelessWidget {
  const WarningModal({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;

    return _BaseDialog(
      circleAvatarBackgroundColor: Colors.yellow.shade200,
      title: Icon(Icons.warning_amber_outlined, color: Colors.yellow.shade800),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          Text(as.warning, style: modalTitleTextStyle(context)),
          Text(message, style: modalContentTextStyle(context)),
        ],
      ),
      actions: [
        _BaseElevatedButton(
          buttonColor: Colors.red,
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text('Continue'),
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

/// Pops [true] if the item deletion was confirmed. Otherwise, returns [false]
class DeleteModal extends StatelessWidget {
  const DeleteModal({super.key, required this.message, required this.title});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;

    return _BaseDialog(
      circleAvatarBackgroundColor: Colors.red.shade200,
      title: Icon(Icons.delete_outline, color: Colors.red.shade800),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          Text(title, style: modalTitleTextStyle(context)),
          Text(message, style: modalContentTextStyle(context)),
        ],
      ),
      actions: [
        _BaseElevatedButton(
          buttonColor: Colors.red,
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text('Delete'),
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

/// Pops [true] if the user confirms sign out. Otherwise, returns [false]
class SignOutModal extends StatelessWidget {
  const SignOutModal({super.key});

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;

    return _BaseDialog(
      circleAvatarBackgroundColor: Colors.amber.shade200,
      title: Icon(Icons.logout, color: Colors.amber.shade800),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          Text('Sign Out?', style: modalContentTextStyle(context)),
          Text(
            'Are you sure you want to sign out? You\'ll need to sign in again '
            'to access your travels.',
            style: modalTitleTextStyle(context),
          ),
        ],
      ),
      actions: [
        _BaseElevatedButton(
          buttonColor: Colors.red,
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text('Sign Out'),
        ),
        const Padding(padding: EdgeInsets.all(6)),
        _BaseElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text('Stay Signed In'),
        ),
      ],
    );
  }
}

/// Pops [true] if the user tries to connect again. Otherwise, returns [false]
class NoInternetModal extends StatelessWidget {
  const NoInternetModal({super.key});

  @override
  Widget build(BuildContext context) {
    final as = AppLocalizations.of(context)!;

    return _BaseDialog(
      circleAvatarBackgroundColor: Colors.red.shade200,
      title: Icon(
        Icons.signal_wifi_connected_no_internet_4_outlined,
        color: Colors.red.shade800,
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          Text('No Internet Connection', style: modalTitleTextStyle(context)),
          Text(
            'You\'re currently offline. Some features may not be available '
            'until you reconnect to the internet.',
            style: modalContentTextStyle(context),
          ),
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

class _BaseElevatedButton extends StatelessWidget {
  const _BaseElevatedButton({
    super.key,
    required this.child,
    this.buttonColor,
    required this.onPressed,
  });

  final Widget child;
  final Color? buttonColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final style = ElevatedButton.styleFrom(backgroundColor: buttonColor);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(onPressed: onPressed, style: style, child: child),
    );
  }
}
