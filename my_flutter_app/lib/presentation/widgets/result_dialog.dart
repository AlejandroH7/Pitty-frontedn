import 'package:flutter/material.dart';
import 'package:my_flutter_app/presentation/widgets/custom_button.dart';

class ResultDialog extends StatelessWidget {
  const ResultDialog({
    super.key,
    required this.message,
    required this.actionText,
    required this.onAction,
    this.detail,
  });

  final String message;
  final String actionText;
  final VoidCallback onAction;
  final String? detail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Widget> contentChildren = <Widget>[
      Text(
        message,
        textAlign: TextAlign.center,
        style: theme.textTheme.headlineSmall,
      ),
    ];

    if (detail != null && detail!.isNotEmpty) {
      contentChildren.addAll(<Widget>[
        const SizedBox(height: 12),
        Text(
          detail!,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
      ]);
    }

    contentChildren.addAll(<Widget>[
      const SizedBox(height: 16),
      SizedBox(
        width: 140,
        child: CustomButton(
          label: actionText,
          onPressed: onAction,
        ),
      ),
    ]);

    return Semantics(
      label: 'Notificación',
      child: AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: contentChildren,
        ),
      ),
    );
  }
}
