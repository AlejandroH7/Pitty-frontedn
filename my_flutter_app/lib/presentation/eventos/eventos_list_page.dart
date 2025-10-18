import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pitty_app/core/utils/date_formatter.dart';
import 'package:pitty_app/core/widgets/app_loading.dart';
import 'package:pitty_app/core/widgets/app_search_field.dart';
import 'package:pitty_app/core/widgets/empty_state.dart';
import 'package:pitty_app/core/widgets/error_state.dart';
import 'package:pitty_app/core/widgets/pagination_footer.dart';
import 'package:pitty_app/presentation/eventos/evento_detail_page.dart';
import 'package:pitty_app/presentation/eventos/evento_form_page.dart';
import 'package:pitty_app/providers/eventos_provider.dart';

class EventosListPage extends StatefulWidget {
  const EventosListPage({super.key});

  @override
  State<EventosListPage> createState() => _EventosListPageState();
}

class _EventosListPageState extends State<EventosListPage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventosProvider>().cargar();
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
      appBar: AppBar(title: const Text('Eventos')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.of(context).push<bool>(
            MaterialPageRoute(builder: (_) => const EventoFormPage()),
          );
          _handleResult(result);
        },
        label: const Text('Nuevo evento'),
        icon: const Icon(Icons.event_available),
      ),
      body: Consumer<EventosProvider>(
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
                child: AppSearchField(
                  label: 'Buscar evento',
                  controller: _searchController,
                  onChanged: controller.buscar,
                ),
              ),
              if (controller.loading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Cargando...'),
                ),
              Expanded(
                child: items.isEmpty
                    ? const EmptyState(title: 'Sin eventos', message: 'No hay eventos programados.')
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemBuilder: (context, index) {
                          final evento = items[index];
                          return Card(
                            child: ListTile(
                              title: Text(evento.titulo),
                              subtitle: Text(
                                '${evento.lugar ?? 'Sin lugar'}\n${formatDateTime(evento.fechaHora)}'
                                '${evento.pedidoCliente != null ? '\nPedido: ${evento.pedidoCliente}' : ''}',
                              ),
                              onTap: () async {
                                final result = await Navigator.of(context).push<bool>(
                                  MaterialPageRoute(
                                    builder: (_) => EventoDetailPage(eventoId: evento.id),
                                  ),
                                );
                                _handleResult(result);
                              },
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemCount: items.length,
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

  void _maybeShowError(String? error) {
    if (error == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.replaceAll('Exception: ', ''))),
      );
      context.read<EventosProvider>().limpiarError();
    });
  }

  void _handleResult(bool? result) {
    if (result == null) return;
    final scheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result ? 'Guardado' : 'Error (simulado)'),
        backgroundColor: result ? scheme.primary : scheme.error,
      ),
    );
  }
}


