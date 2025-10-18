import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/widgets.dart';
import '../../presentation/shared/dialogs.dart';
import '../../presentation/shared/empty_view.dart';
import '../../presentation/shared/loading_view.dart';
import '../../presentation/shared/snackbars.dart';
import '../../providers/postres_provider.dart';
import '../../routes/app_router.dart';

class PostresListPage extends StatelessWidget {
  const PostresListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Postres'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<PostresProvider>().load(),
            tooltip: 'Refrescar',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(
          context,
          AppRouter.postreForm,
          arguments: const PostreFormArgs(),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo postre'),
      ),
      body: Consumer<PostresProvider>(
        builder: (context, postresProvider, _) {
          if (postresProvider.isLoading) {
            return const LoadingView();
          }
          if (postresProvider.error != null) {
            return _ErrorView(message: postresProvider.error!);
          }
          if (postresProvider.postres.isEmpty) {
            return const EmptyView(message: 'No hay postres registrados');
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: AppSearchField(
                  hintText: 'Buscar postres…',
                  onChanged: postresProvider.buscar,
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: postresProvider.load,
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final postre = postresProvider.postres[index];
                      return ListTile(
                        title: Text(postre.nombre),
                        subtitle: Text(
                          '${postre.porciones} porciones · ${postre.activo ? 'Disponible' : 'Inactivo'}',
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Q${postre.precio.toStringAsFixed(2)}'),
                            PopupMenuButton<String>(
                              onSelected: (value) => _onOptionSelected(
                                context,
                                value,
                                postre.id,
                              ),
                              itemBuilder: (context) => const [
                                PopupMenuItem(
                                    value: 'detalle',
                                    child: Text('Ver detalle')),
                                PopupMenuItem(
                                    value: 'editar', child: Text('Editar')),
                                PopupMenuItem(
                                    value: 'eliminar', child: Text('Eliminar')),
                              ],
                              icon: const Icon(Icons.more_vert),
                            ),
                          ],
                        ),
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRouter.postreDetalle,
                          arguments: PostreDetailArgs(postre.id),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const Divider(height: 0),
                    itemCount: postresProvider.postres.length,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        'Página ${postresProvider.currentPage + 1} de ${postresProvider.totalPages}'),
                    Row(
                      children: [
                        IconButton(
                          onPressed: postresProvider.hasPreviousPage
                              ? postresProvider.previousPage
                              : null,
                          icon: const Icon(Icons.arrow_back_ios),
                        ),
                        IconButton(
                          onPressed: postresProvider.hasNextPage
                              ? postresProvider.nextPage
                              : null,
                          icon: const Icon(Icons.arrow_forward_ios),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (postresProvider.isSaving)
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text('Guardando…',
                      style: TextStyle(fontStyle: FontStyle.italic)),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _onOptionSelected(
      BuildContext context, String action, int postreId) async {
    switch (action) {
      case 'detalle':
        Navigator.pushNamed(
          context,
          AppRouter.postreDetalle,
          arguments: PostreDetailArgs(postreId),
        );
        break;
      case 'editar':
        Navigator.pushNamed(
          context,
          AppRouter.postreForm,
          arguments: PostreFormArgs(id: postreId),
        );
        break;
      case 'eliminar':
        final confirmed = await showConfirmDeleteDialog(
          context: context,
          title: 'Eliminar postre',
          message: '¿Deseas eliminar este postre?',
        );
        if (!confirmed) return;
        final success =
            await context.read<PostresProvider>().eliminar(postreId);
        if (context.mounted) {
          if (success) {
            showSuccessSnackBar(context, 'Postre eliminado');
          } else {
            final error =
                context.read<PostresProvider>().error ?? 'No se pudo eliminar';
            showErrorSnackBar(context, error);
          }
        }
        break;
    }
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.read<PostresProvider>().load(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}