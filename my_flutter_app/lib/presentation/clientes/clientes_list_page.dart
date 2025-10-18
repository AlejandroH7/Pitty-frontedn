import 'package:flutter/material.dart';
import 'package:pitty_app/core/utils/date_formatter.dart';
import 'package:pitty_app/core/widgets/app_loading.dart';
import 'package:pitty_app/core/widgets/app_search_field.dart';
import 'package:pitty_app/core/widgets/empty_state.dart';
import 'package:pitty_app/core/widgets/error_state.dart';
import 'package:pitty_app/core/widgets/pagination_footer.dart';
import 'package:pitty_app/providers/clientes_provider.dart';
import 'package:pitty_app/routes/app_router.dart';
import 'package:provider/provider.dart';

class ClientesListPage extends StatefulWidget {
  const ClientesListPage({super.key});

  @override
  State<ClientesListPage> createState() => _ClientesListPageState();
}

class _ClientesListPageState extends State<ClientesListPage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClientesProvider>().cargar();
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
      appBar: AppBar(title: const Text('Clientes')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.of(context).pushNamed<bool>(
            AppRoutes.clienteForm,
            arguments: const ClienteFormArgs(),
          );
          _handleFormResult(result);
        },
        label: const Text('Nuevo cliente'),
        icon: const Icon(Icons.person_add),
      ),
      body: Consumer<ClientesProvider>(
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
                  label: 'Buscar por nombre o telefono',
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
                    ? const EmptyState(title: 'Sin clientes', message: 'No hay clientes registrados.')
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemBuilder: (context, index) {
                          final cliente = items[index];
                          return ListTile(
                            title: Text(cliente.nombre),
                            subtitle: Text(cliente.telefono ?? 'Sin telefono'),
                            trailing: Text(formatDate(cliente.createdAt)),
                            onTap: () async {
                              final result = await Navigator.of(context).pushNamed<bool>(
                                AppRoutes.clienteDetail,
                                arguments: ClienteDetailArgs(clienteId: cliente.id),
                              );
                              _handleFormResult(result);
                            },
                          );
                        },
                        separatorBuilder: (_, __) => const Divider(),
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
      context.read<ClientesProvider>().limpiarError();
    });
  }

  void _handleFormResult(bool? result) {
    if (result == null) return;
    final message = result ? 'Guardado' : 'Error (simulado)';
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: result ? colorScheme.primary : colorScheme.error,
      ),
    );
  }
}
