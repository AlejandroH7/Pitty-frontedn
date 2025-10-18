import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/widgets.dart';
import '../../presentation/shared/dialogs.dart';
import '../../presentation/shared/empty_view.dart';
import '../../presentation/shared/loading_view.dart';
import '../../presentation/shared/snackbars.dart';
import '../../providers/clientes_provider.dart';
import '../../routes/app_router.dart';

class ClientesListPage extends StatefulWidget {
  const ClientesListPage({super.key});

  @override
  State<ClientesListPage> createState() => _ClientesListPageState();
}

class _ClientesListPageState extends State<ClientesListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<ClientesProvider>().loadClientes(),
            tooltip: 'Refrescar',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(
            context,
            AppRouter.clienteForm,
            arguments: const ClienteFormArgs(),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Nuevo cliente'),
      ),
      body: Consumer<ClientesProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const LoadingView();
          }
          if (provider.error != null) {
            return _ErrorView(message: provider.error!);
          }
          if (provider.clientes.isEmpty) {
            return const EmptyView(message: 'No hay clientes registrados');
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: AppSearchField(
                  hintText: 'Buscar por nombre, teléfono o notas…',
                  onChanged: provider.buscar,
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: provider.loadClientes,
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final cliente = provider.clientes[index];
                      return ListTile(
                        title: Text(cliente.nombre),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (cliente.telefono != null)
                              Text('Teléfono: ${cliente.telefono}'),
                            if (cliente.notas != null && cliente.notas!.isNotEmpty)
                              Text('Notas: ${cliente.notas}'),
                          ],
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) =>
                              _onOptionSelected(value, cliente.id),
                          itemBuilder: (context) => const [
                            PopupMenuItem(
                                value: 'detalle', child: Text('Ver detalle')),
                            PopupMenuItem(
                                value: 'editar', child: Text('Editar')),
                            PopupMenuItem(
                                value: 'eliminar', child: Text('Eliminar')),
                          ],
                        ),
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRouter.clienteDetalle,
                          arguments: ClienteDetailArgs(cliente.id),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const Divider(height: 0),
                    itemCount: provider.clientes.length,
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
                        'Página ${provider.currentPage + 1} de ${provider.totalPages}'),
                    Row(
                      children: [
                        IconButton(
                          onPressed: provider.hasPreviousPage
                              ? provider.previousPage
                              : null,
                          icon: const Icon(Icons.arrow_back_ios),
                        ),
                        IconButton(
                          onPressed:
                              provider.hasNextPage ? provider.nextPage : null,
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

  Future<void> _onOptionSelected(String action, int clienteId) async {
    switch (action) {
      case 'detalle':
        Navigator.pushNamed(
          context,
          AppRouter.clienteDetalle,
          arguments: ClienteDetailArgs(clienteId),
        );
        break;
      case 'editar':
        Navigator.pushNamed(
          context,
          AppRouter.clienteForm,
          arguments: ClienteFormArgs(id: clienteId),
        );
        break;
      case 'eliminar':
        final confirmed = await showConfirmDeleteDialog(
          context: context,
          title: 'Eliminar cliente',
          message: '¿Deseas eliminar este cliente?',
        );
        if (!confirmed) return;
        final success =
            await context.read<ClientesProvider>().eliminar(clienteId);
        if (success) {
          if (mounted) {
            showSuccessSnackBar(context, 'Cliente eliminado');
          }
        } else {
          if (mounted) {
            final error =
                context.read<ClientesProvider>().error ?? 'No se pudo eliminar';
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
              onPressed: () => context.read<ClientesProvider>().loadClientes(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}