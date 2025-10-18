import 'package:flutter/material.dart';
import 'package:pitty_app/core/widgets/app_loading.dart';
import 'package:pitty_app/core/widgets/app_search_field.dart';
import 'package:pitty_app/core/widgets/empty_state.dart';
import 'package:pitty_app/core/widgets/error_state.dart';
import 'package:pitty_app/core/widgets/pagination_footer.dart';
import 'package:pitty_app/core/widgets/status_chip.dart';
import 'package:pitty_app/providers/postres_provider.dart';
import 'package:pitty_app/routes/app_router.dart';
import 'package:provider/provider.dart';

class PostresListPage extends StatefulWidget {
  const PostresListPage({super.key});

  @override
  State<PostresListPage> createState() => _PostresListPageState();
}

class _PostresListPageState extends State<PostresListPage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostresProvider>().cargar();
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
      appBar: AppBar(title: const Text('Postres')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.of(context).pushNamed<bool>(
            AppRoutes.postreForm,
            arguments: const PostreFormArgs(),
          );
          _handleResult(result);
        },
        label: const Text('Nuevo postre'),
        icon: const Icon(Icons.add),
      ),
      body: Consumer<PostresProvider>(
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
                  label: 'Buscar postre',
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
                    ? const EmptyState(message: 'No hay postres registrados.')
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemBuilder: (context, index) {
                          final postre = items[index];
                          return ListTile(
                            title: Text(postre.nombre),
                            subtitle: Text(
                              'Precio: S/ ${postre.precio.toStringAsFixed(2)} - Porciones: ${postre.porciones}',
                            ),
                            trailing: StatusChip(
                              label: postre.activo ? 'Activo' : 'Inactivo',
                              color: postre.activo
                                  ? Theme.of(context).colorScheme.primaryContainer
                                  : Theme.of(context).colorScheme.errorContainer,
                            ),
                            onTap: () async {
                              final result = await Navigator.of(context).pushNamed<bool>(
                                AppRoutes.postreDetail,
                                arguments: PostreDetailArgs(postreId: postre.id),
                              );
                              _handleResult(result);
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
      context.read<PostresProvider>().limpiarError();
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
