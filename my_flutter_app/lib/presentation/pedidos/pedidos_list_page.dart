import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pitty_app/core/utils/date_formatter.dart';
import 'package:pitty_app/core/widgets/app_loading.dart';
import 'package:pitty_app/core/widgets/app_search_field.dart';
import 'package:pitty_app/core/widgets/empty_state.dart';
import 'package:pitty_app/core/widgets/error_state.dart';
import 'package:pitty_app/core/widgets/pagination_footer.dart';
import 'package:pitty_app/core/widgets/status_chip.dart';
import 'package:pitty_app/data/models/pedido.dart';
import 'package:pitty_app/presentation/pedidos/pedido_detail_page.dart';
import 'package:pitty_app/presentation/pedidos/pedido_wizard_page.dart';
import 'package:pitty_app/providers/pedidos_provider.dart';

class PedidosListPage extends StatefulWidget {
  const PedidosListPage({super.key});

  @override
  State<PedidosListPage> createState() => _PedidosListPageState();
}

class _PedidosListPageState extends State<PedidosListPage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PedidosProvider>().cargar();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pedidos')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => const PedidoWizardPage()),
          );
          _handleResult(result);
        },
        label: const Text('Nuevo pedido'),
        icon: const Icon(Icons.add_shopping_cart),
      ),
      body: Consumer<PedidosProvider>(
        builder: (context, controller, _) {
          _maybeShowError(controller.error);

          if (controller.loading && controller.totalItems == 0) {
            return const AppLoading();
          }

          if (controller.error != null && controller.totalItems == 0) {
            return ErrorState(
              message: controller.error ?? 'Error (simulado)',
              onRetry: controller.cargar,
            );
          }

          final items = controller.pageItems;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    AppSearchField(
                      label: 'Buscar por cliente o estado',
                      controller: _searchController,
                      onChanged: controller.buscar,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _DateFilterButton(
                            label: 'Desde',
                            value: controller.desde,
                            onChanged: (date) => controller.actualizarRango(
                              desde: date,
                              hasta: controller.hasta,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _DateFilterButton(
                            label: 'Hasta',
                            value: controller.hasta,
                            onChanged: (date) => controller.actualizarRango(
                              desde: controller.desde,
                              hasta: date,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => controller.actualizarRango(desde: null, hasta: null),
                        child: const Text('Limpiar filtros'),
                      ),
                    ),
                  ],
                ),
              ),
              if (controller.loading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Cargando...'),
                ),
              Expanded(
                child: items.isEmpty
                    ? const EmptyState(title: 'Sin pedidos', message: 'No hay pedidos registrados.')
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final pedido = items[index];
                          return Card(
                            child: ListTile(
                              title: Text(pedido.clienteNombre),
                              subtitle: Text(
                                'Entrega: ${formatDateTime(pedido.fechaEntrega)}\nTotal: S/ ${pedido.total.toStringAsFixed(2)}',
                              ),
                              trailing: StatusChip(
                                label: pedido.estado.label,
                                color: _estadoColor(context, pedido.estado),
                              ),
                              onTap: () async {
                                final result = await Navigator.of(context).push<bool>(
                                  MaterialPageRoute(
                                    builder: (_) => PedidoDetailPage(pedidoId: pedido.id),
                                  ),
                                );
                                _handleResult(result);
                              },
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: PaginationFooter(
                  currentPage: controller.page,
                  totalPages: controller.totalPages,
                  onPageSelected: controller.irAPagina,
                ),
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

  void _maybeShowError(String? error) {
    if (error == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.replaceAll('Exception: ', ''))),
      );
      context.read<PedidosProvider>().limpiarError();
    });
  }

  void _handleResult(bool? result) {
    if (result == null) return;
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result ? 'Guardado' : 'Error (simulado)'),
        backgroundColor: result ? colorScheme.primary : colorScheme.error,
      ),
    );
  }
}

class _DateFilterButton extends StatelessWidget {
  const _DateFilterButton({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  @override
  Widget build(BuildContext context) {
    final text = value != null ? formatDate(value) : label;
    return OutlinedButton.icon(
      onPressed: () async {
        final picked = await showDatePicker(
          context: context,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          initialDate: value ?? DateTime.now(),
        );
        onChanged(picked);
      },
      icon: const Icon(Icons.date_range),
      label: Text(text),
    );
  }
}


