import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/date_formatter.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/status_chip.dart';
import '../../data/models/pedido.dart';
import 'package:pitty_app/providers/pedidos_provider.dart';

class PedidoDetailPage extends StatefulWidget {
  const PedidoDetailPage({super.key, required this.pedidoId});

  final int pedidoId;

  @override
  State<PedidoDetailPage> createState() => _PedidoDetailPageState();
}

class _PedidoDetailPageState extends State<PedidoDetailPage> {
  late Future<Pedido> _future;
  bool _simulateErrorEstado = false;

  @override
  void initState() {
    super.initState();
    _future = context.read<PedidosProvider>().obtener(widget.pedidoId);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de pedido')),
      body: FutureBuilder<Pedido>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: Text('Cargando...'));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error al cargar: ${snapshot.error}'));
          }
          final pedido = snapshot.data;
          if (pedido == null) {
            return const Center(child: Text('Pedido no encontrado'));
          }
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(pedido.clienteNombre, style: Theme.of(context).textTheme.headlineSmall),
                              const SizedBox(height: 8),
                              Text('Entrega: ${formatDateTime(pedido.fechaEntrega)}'),
                              Text('Notas: ${pedido.notas?.isNotEmpty == true ? pedido.notas : 'Sin notas'}'),
                            ],
                          ),
                          StatusChip(
                            label: pedido.estado.label,
                            color: _estadoColor(context, pedido.estado),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<PedidoEstado>(
                              value: pedido.estado,
                              items: PedidoEstado.values
                                  .map((estado) => DropdownMenuItem(
                                        value: estado,
                                        child: Text(estado.label),
                                      ))
                                  .toList(),
                              onChanged: (estado) async {
                                if (estado == null) return;
                                final success = await context.read<PedidosProvider>().actualizarEstado(
                                      id: pedido.id,
                                      estado: estado,
                                      simulateError: _simulateErrorEstado,
                                    );
                                if (!mounted) return;
                                if (success) {
                                  setState(() {
                                    _future = context.read<PedidosProvider>().obtener(widget.pedidoId);
                                  });
                                  _showSnackBar('Guardado');
                                } else {
                                  _showSnackBar('Error (simulado)', isError: true);
                                }
                              },
                              decoration: const InputDecoration(labelText: 'Actualizar estado'),
                            ),
                          ),
                        ],
                      ),
                      SwitchListTile.adaptive(
                        value: _simulateErrorEstado,
                        onChanged: (value) => setState(() => _simulateErrorEstado = value),
                        title: const Text('Simular error al actualizar estado'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Items del pedido', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              if (pedido.items.isEmpty)
                const EmptyState(message: 'El pedido no tiene Items.')
              else
                ...pedido.items.map(
                  (item) => Card(
                    margin: const EdgeInsets.only(bottom: 12.0),
                    child: ListTile(
                      title: Text(item.postreNombre),
                      subtitle: Text(
                        'Cantidad: ${item.cantidad}\nPrecio unitario: S/ ${item.precioUnitario.toStringAsFixed(2)}\nSubtotal: S/ ${item.subtotal.toStringAsFixed(2)}',
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Total: S/ ${pedido.total.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Eliminar pedido'),
                      content: const Text(' Deseas eliminar este pedido?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancelar'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Eliminar'),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    final success = await context.read<PedidosProvider>().eliminar(pedido.id);
                    if (!mounted) return;
                    Navigator.of(context).pop(success);
                  }
                },
                icon: const Icon(Icons.delete_forever),
                label: const Text('Eliminar pedido'),
                style: FilledButton.styleFrom(backgroundColor: colorScheme.error),
              ),
            ],
          );
        },
      ),
    );
  }

  Color _estadoColor(BuildContext context, PedidoEstado estado) {
    final scheme = Theme.of(context).colorScheme;
    switch (estado) {
      case PedidoEstado.borrador:
        return scheme.secondaryContainer;
      case PedidoEstado.confirmado:
        return scheme.primaryContainer;
      case PedidoEstado.entregado:
        return scheme.tertiaryContainer;
      case PedidoEstado.cancelado:
        return scheme.errorContainer;
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    final scheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? scheme.error : scheme.primary,
      ),
    );
  }
}
