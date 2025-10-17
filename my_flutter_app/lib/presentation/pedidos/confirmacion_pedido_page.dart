import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../presentation/shared/snackbars.dart';
import '../../providers/carrito_provider.dart';
import '../../routes/app_router.dart';

class ConfirmacionPedidoPage extends StatefulWidget {
  const ConfirmacionPedidoPage({super.key});

  @override
  State<ConfirmacionPedidoPage> createState() => _ConfirmacionPedidoPageState();
}

class _ConfirmacionPedidoPageState extends State<ConfirmacionPedidoPage> {
  final _notasController = TextEditingController();

  @override
  void dispose() {
    _notasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CarritoProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmar pedido'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Resumen', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: provider.items.length,
                itemBuilder: (context, index) {
                  final item = provider.items[index];
                  return ListTile(
                    title: Text(item.postre.nombre),
                    subtitle: Text('Cantidad: ${item.cantidad}'),
                    trailing: Text('Q${item.subtotal.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
            Text('Total: Q${provider.total.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            TextField(
              controller: _notasController,
              decoration: const InputDecoration(
                labelText: 'Notas (opcional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: provider.isProcessing ? null : _confirmar,
              icon: provider.isProcessing
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check_circle_outline),
              label: Text(
                  provider.isProcessing ? 'Procesando…' : 'Confirmar pedido'),
            ),
            if (provider.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  provider.error!,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmar() async {
    final provider = context.read<CarritoProvider>();
    final exito = await provider.confirmarPedido(notas: _notasController.text);
    if (!mounted) return;
    if (exito) {
      final mensaje = provider.ultimoMensaje ?? 'Pedido creado (simulado)';
      showSuccessSnackBar(context, mensaje);
      Navigator.popUntil(
          context, ModalRoute.withName(AppRouter.pedidosCatalogo));
    } else {
      final error = provider.error ?? 'No fue posible confirmar el pedido';
      showErrorSnackBar(context, error);
    }
  }
}
