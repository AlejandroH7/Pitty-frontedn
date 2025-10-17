import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/app_search_field.dart';
import '../../presentation/shared/dialogs.dart';
import '../../presentation/shared/empty_view.dart';
import '../../presentation/shared/loading_view.dart';
import '../../presentation/shared/snackbars.dart';
import '../../providers/categorias_provider.dart';
import '../../routes/app_router.dart';

class CategoriasListPage extends StatefulWidget {
  const CategoriasListPage({super.key});

  @override
  State<CategoriasListPage> createState() => _CategoriasListPageState();
}

class _CategoriasListPageState extends State<CategoriasListPage> {
  String _search = '';
  int _page = 0;
  static const int _pageSize = 8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<CategoriasProvider>().load(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(
          context,
          AppRouter.categoriaForm,
          arguments: const CategoriaFormArgs(),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Nueva categoría'),
      ),
      body: Consumer<CategoriasProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const LoadingView();
          }
          if (provider.error != null) {
            return _ErrorView(message: provider.error!);
          }
          if (provider.categorias.isEmpty) {
            return const EmptyView(message: 'No hay categorías');
          }
          final filtradas = provider.categorias
              .where(
                  (c) => c.nombre.toLowerCase().contains(_search.toLowerCase()))
              .toList();
          final totalPaginas =
              (filtradas.length / _pageSize).ceil().clamp(1, 999);
          if (_page >= totalPaginas) {
            _page = totalPaginas - 1;
          }
          final start = (_page * _pageSize).clamp(0, filtradas.length);
          var end = start + _pageSize;
          if (end > filtradas.length) {
            end = filtradas.length;
          }
          final visibles = filtradas.sublist(start, end);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: AppSearchField(
                  hintText: 'Buscar categorías…',
                  onChanged: (value) => setState(() {
                    _search = value;
                    _page = 0;
                  }),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: visibles.length,
                  separatorBuilder: (_, __) => const Divider(height: 0),
                  itemBuilder: (context, index) {
                    final categoria = visibles[index];
                    return ListTile(
                      title: Text(categoria.nombre),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) =>
                            _onOptionSelected(value, categoria.id),
                        itemBuilder: (context) => const [
                          PopupMenuItem(value: 'editar', child: Text('Editar')),
                          PopupMenuItem(
                              value: 'eliminar', child: Text('Eliminar')),
                        ],
                      ),
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRouter.categoriaForm,
                        arguments: CategoriaFormArgs(id: categoria.id),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Página ${_page + 1} de $totalPaginas'),
                    Row(
                      children: [
                        IconButton(
                          onPressed: _page > 0
                              ? () => setState(() => _page -= 1)
                              : null,
                          icon: const Icon(Icons.arrow_back_ios),
                        ),
                        IconButton(
                          onPressed: _page < totalPaginas - 1
                              ? () => setState(() => _page += 1)
                              : null,
                          icon: const Icon(Icons.arrow_forward_ios),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (provider.isSaving)
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

  Future<void> _onOptionSelected(String action, int categoriaId) async {
    switch (action) {
      case 'editar':
        Navigator.pushNamed(
          context,
          AppRouter.categoriaForm,
          arguments: CategoriaFormArgs(id: categoriaId),
        );
        break;
      case 'eliminar':
        final confirmed = await showConfirmDeleteDialog(
          context: context,
          title: 'Eliminar categoría',
          message: '¿Deseas eliminar esta categoría?',
        );
        if (!confirmed) return;
        final success =
            await context.read<CategoriasProvider>().eliminar(categoriaId);
        if (context.mounted) {
          if (success) {
            showSuccessSnackBar(context, 'Categoría eliminada');
          } else {
            final error = context.read<CategoriasProvider>().error ??
                'No se pudo eliminar';
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
              onPressed: () => context.read<CategoriasProvider>().load(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
