import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/categorias_provider.dart';
import '../../providers/postres_provider.dart';
import '../../routes/app_router.dart';

class PostreDetailPage extends StatelessWidget {
  const PostreDetailPage({super.key, required this.postreId});

  final int postreId;

  @override
  Widget build(BuildContext context) {
    final postre = context.select<PostresProvider, _PostreDetailModel?>(
      (provider) {
        final data = provider.obtenerPorId(postreId);
        if (data == null) return null;
        return _PostreDetailModel(
          nombre: data.nombre,
          precio: data.precio,
          categoriaId: data.categoriaId,
          descripcion: data.descripcion,
          imagenUrl: data.imagenUrl,
        );
      },
    );

    final categoriaNombre = context.select<CategoriasProvider, String?>(
      (provider) => postre?.categoriaId == null
          ? null
          : provider.obtenerPorId(postre!.categoriaId!)?.nombre,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del postre'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: postre == null
                ? null
                : () {
                    Navigator.pushNamed(
                      context,
                      AppRouter.postreForm,
                      arguments: PostreFormArgs(id: postreId),
                    );
                  },
          ),
        ],
      ),
      body: postre == null
          ? const Center(child: Text('No se encontró el postre'))
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(postre.nombre,
                          style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 16),
                      _buildRow(
                          'Precio', 'Q${postre.precio.toStringAsFixed(2)}'),
                      const SizedBox(height: 8),
                      _buildRow(
                          'Categoría', categoriaNombre ?? 'Sin categoría'),
                      const SizedBox(height: 8),
                      _buildRow('Descripción',
                          postre.descripcion ?? 'Sin descripción'),
                      if (postre.imagenUrl != null &&
                          postre.imagenUrl!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        _buildRow('Imagen', postre.imagenUrl!),
                      ],
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value),
      ],
    );
  }
}

class _PostreDetailModel {
  const _PostreDetailModel({
    required this.nombre,
    required this.precio,
    this.categoriaId,
    this.descripcion,
    this.imagenUrl,
  });

  final String nombre;
  final double precio;
  final int? categoriaId;
  final String? descripcion;
  final String? imagenUrl;
}
