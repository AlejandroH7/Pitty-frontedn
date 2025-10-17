import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../presentation/shared/empty_view.dart';
import '../../presentation/shared/snackbars.dart';
import '../../providers/carrito_provider.dart';
import '../../routes/app_router.dart';

class CarritoPage extends StatelessWidget {
  const CarritoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito de pedido'),
      ),
      body: Consumer<CarritoProvider>(
        builder: (context, provider, _) {
          if (provider.items.isEmpty) {
            return const EmptyView(message: 'Agrega postres desde el catálogo');
          }
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: provider.items.length,
                  separatorBuilder: (_, __) => const Divider(height: 0),
                  itemBuilder: (context, index) {
                    final item = provider.items[index];
                    return ListTile(
                      title: Text(item.postre.nombre),
                      subtitle:
                          Text('Q${item.postre.precio.toStringAsFixed(2)} c/u'),
                      trailing: _QuantitySelector(
                          itemId: item.postre.id, cantidad: item.cantidad),
                    );
                  },
                ),
              ),
              _CarritoSummary(total: provider.total),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: Consumer<CarritoProvider>(
          builder: (context, provider, _) {
            return FilledButton.icon(
              onPressed: provider.items.isEmpty
                  ? null
                  : () =>
                      Navigator.pushNamed(context, AppRouter.confirmarPedido),
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Confirmar pedido'),
            );
          },
        ),
      ),
    );
  }
}

class _QuantitySelector extends StatelessWidget {
  const _QuantitySelector({required this.itemId, required this.cantidad});

  final int itemId;
  final int cantidad;

  @override
  Widget build(BuildContext context) {
    final provider = context.read<CarritoProvider>();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: () {
            final item =
                provider.items.firstWhere((e) => e.postre.id == itemId);
            provider.actualizarCantidad(item.postre, item.cantidad - 1);
          },
        ),
        Text('$cantidad'),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () {
            final item =
                provider.items.firstWhere((e) => e.postre.id == itemId);
            provider.actualizarCantidad(item.postre, item.cantidad + 1);
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () {
            provider.eliminarPostre(itemId);
            showSuccessSnackBar(context, 'Postre eliminado del carrito');
          },
        ),
      ],
    );
  }
}

class _CarritoSummary extends StatelessWidget {
  const _CarritoSummary({required this.total});

  final double total;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Total', style: Theme.of(context).textTheme.titleLarge),
          Text('Q${total.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}
