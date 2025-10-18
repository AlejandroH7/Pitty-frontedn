import 'package:flutter/material.dart';

class PedidoItemInput extends StatelessWidget {
  const PedidoItemInput({
    super.key,
    required this.onChanged,
  });

  final void Function(int cantidad) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Cantidad'),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              final parsed = int.tryParse(value) ?? 0;
              onChanged(parsed);
            },
            decoration: const InputDecoration(hintText: '0'),
          ),
        ),
      ],
    );
  }
}
