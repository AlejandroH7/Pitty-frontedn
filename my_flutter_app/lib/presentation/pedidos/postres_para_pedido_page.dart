import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/app_search_field.dart';
import '../../presentation/shared/empty_view.dart';
import '../../presentation/shared/loading_view.dart';
import '../../presentation/shared/snackbars.dart';
import '../../providers/carrito_provider.dart';
import '../../providers/postres_provider.dart';
import '../../routes/app_router.dart';

class PostresParaPedidoPage extends StatefulWidget {
  const PostresParaPedidoPage({super.key});

  @override
  State<PostresParaPedidoPage> createState() => _PostresParaPedidoPageState();
}

class _PostresParaPedidoPageState extends State<PostresParaPedidoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona postres'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, AppRouter.carrito),
          ),
        ],
      ),
      body: Consumer<PostresProvider>(
        builder: (context, postresProvider, _) {
          if (postresProvider.isLoading) {
            return const LoadingView();
          }
          if (postresProvider.error != null) {
            return Center(child: Text(postresProvider.error!));
          }
          if (postresProvider.postres.isEmpty) {
            return const EmptyView(message: 'No hay postres para mostrar');
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
                child: ListView.separated(
                  itemCount: postresProvider.postres.length,
                  separatorBuilder: (_, __) => const Divider(height: 0),
                  itemBuilder: (context, index) {
                    final postre = postresProvider.postres[index];
                    final puedeAgregar = postre.activo;
                    return ListTile(
                      title: Text(postre.nombre),
                      subtitle: Text(
                          '${postre.porciones} porciones · Q${postre.precio.toStringAsFixed(2)}'),
                      trailing: FilledButton.icon(
                        onPressed: puedeAgregar
                            ? () {
                                context
                                    .read<CarritoProvider>()
                                    .agregarPostre(postre);
                                showSuccessSnackBar(
                                    context, 'Postre agregado al carrito');
                              }
                            : null,
                        icon: const Icon(Icons.add),
                        label: Text(puedeAgregar ? 'Agregar' : 'Inactivo'),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: FilledButton.icon(
          onPressed: () => Navigator.pushNamed(context, AppRouter.carrito),
          icon: const Icon(Icons.shopping_cart_checkout),
          label: const Text('Ver carrito'),
        ),
      ),
    );
  }
}