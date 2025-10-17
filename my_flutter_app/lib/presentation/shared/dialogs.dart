import 'package:flutter/material.dart';

Future<bool> showConfirmDeleteDialog({
  required BuildContext context,
  required String title,
  String message = '¿Deseas eliminar este registro?',
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      );
    },
  );
  return result ?? false;
}
