import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class EventDetailPage extends StatelessWidget {
  const EventDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
    final event = args ?? <String, String>{};

    final eventName = event['evento'] ?? '-';
    final client = event['cliente'] ?? '-';
    final dessert = event['postre'] ?? '-';
    final quantity = event['cantidad'] ?? '-';
    final place = event['lugar'] ?? '-';
    final note = event['anotacion'] ?? '-';
    final date = event['fecha'] ?? '-';

    return Scaffold(
      backgroundColor: theme.colorScheme.background, // ignore: deprecated_member_use
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 24),
                Text(
                  'Eventos',
                  style: theme.textTheme.headlineLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _DetailRow(label: 'Evento', value: eventName),
                        _DetailRow(label: 'Cliente', value: client),
                        _DetailRow(label: 'Postre a vender', value: dessert),
                        _DetailRow(label: 'Cantidad', value: quantity),
                        _DetailRow(label: 'Lugar', value: place),
                        _DetailRow(label: 'Anotacion', value: note),
                        _DetailRow(label: 'Fecha', value: date),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: 220,
                  child: CustomButton(
                    label: 'Editar',
                    filled: true,
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Editar (UI demo)')),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 220,
                  child: CustomButton(
                    label: 'Volver',
                    filled: true,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
