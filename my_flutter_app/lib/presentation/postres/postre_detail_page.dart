import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          porciones: data.porciones,
          activo: data.activo,
          createdAt: data.createdAt,
          updatedAt: data.updatedAt,
        );
      },
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
                      _buildRow('Porciones', '${postre.porciones}'),
                      const SizedBox(height: 8),
                      _buildRow(
                          'Estado', postre.activo ? 'Disponible' : 'Inactivo'),
                      const SizedBox(height: 24),
                      if (postre.createdAt != null)
                        Text(
                          'Creado: ${_formatDate(postre.createdAt!)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      if (postre.updatedAt != null)
                        Text(
                          'Actualizado: ${_formatDate(postre.updatedAt!)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
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

  String _formatDate(DateTime value) {
    return value.toLocal().toString().split('.').first;
  }
}

class _PostreDetailModel {
  const _PostreDetailModel({
    required this.nombre,
    required this.precio,
    required this.porciones,
    required this.activo,
    this.createdAt,
    this.updatedAt,
  });

  final String nombre;
  final double precio;
  final int porciones;
  final bool activo;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}