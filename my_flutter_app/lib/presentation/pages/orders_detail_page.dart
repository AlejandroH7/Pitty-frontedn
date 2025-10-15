// lib/presentation/pages/orders_detail_page.dart
import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class OrdersDetailPage extends StatelessWidget {
  const OrdersDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Map<Object?, Object?> rawArgs =
        (ModalRoute.of(context)?.settings.arguments as Map<Object?, Object?>?) ??
            <Object?, Object?>{};

    final Map<String, String> data = rawArgs.map((Object? key, Object? value) {
      return MapEntry(key?.toString() ?? '', value?.toString() ?? '');
    });

    final String title = data['title']?.isNotEmpty == true
        ? data['title']!
        : 'Pedido guardado';
    final bool isFromList = title != 'Pedido guardado';

    final String cliente = data['cliente']?.isNotEmpty == true
        ? data['cliente']!
        : '—';
    final String postre = data['postre']?.isNotEmpty == true
        ? data['postre']!
        : '—';
    final String cantidad = data['cantidad']?.isNotEmpty == true
        ? data['cantidad']!
        : '—';
    final String anotacion = data['anotacion']?.isNotEmpty == true
        ? data['anotacion']!
        : '—';
    final String fecha = data['fecha']?.isNotEmpty == true
        ? data['fecha']!
        : (data['fechaEntrega']?.isNotEmpty == true ? data['fechaEntrega']! : '—');

    final String helperText = isFromList
        ? 'Información del pedido seleccionado.'
        : 'Tu pedido se registró correctamente. Estos son los datos ingresados:';

    return Scaffold(
      backgroundColor: theme.colorScheme.background, // ignore: deprecated_member_use
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 24),
                  Text(
                    title,
                    style: theme.textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    helperText,
                    style: theme.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 24,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          _DetailRow(label: 'Cliente', value: cliente),
                          const SizedBox(height: 12),
                          _DetailRow(label: 'Postre', value: postre),
                          const SizedBox(height: 12),
                          _DetailRow(label: 'Cantidad', value: cantidad),
                          const SizedBox(height: 12),
                          _DetailRow(label: 'Anotación', value: anotacion),
                          const SizedBox(height: 12),
                          _DetailRow(label: 'Fecha de entrega', value: fecha),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: 220,
                    child: CustomButton(
                      label: 'Editar',
                      filled: false,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Editar pedido (UI placeholder)'),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 220,
                    child: CustomButton(
                      label: 'Volver al menú de pedidos',
                      filled: true,
                      onPressed: () {
                        Navigator.popUntil(
                          context,
                          ModalRoute.withName('/pedidos'),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 220,
                    child: CustomButton(
                      label: 'Nuevo pedido',
                      filled: false,
                      onPressed: () {
                        Navigator.popUntil(
                          context,
                          ModalRoute.withName('/pedidos'),
                        );
                        Navigator.pushNamed(context, '/pedidos/agregar');
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          label,
          style: theme.textTheme.labelLarge,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.bodyLarge,
        ),
      ],
    );
  }
}
