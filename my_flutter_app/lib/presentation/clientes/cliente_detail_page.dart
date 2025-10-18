import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/clientes_provider.dart';
import '../../routes/app_router.dart';

class ClienteDetailPage extends StatelessWidget {
  const ClienteDetailPage({super.key, required this.clienteId});

  final int clienteId;

  @override
  Widget build(BuildContext context) {
    final cliente = context.select<ClientesProvider, _ClienteDetailModel?>(
      (provider) {
        final data = provider.obtenerPorId(clienteId);
        return data == null
            ? null
            : _ClienteDetailModel(
                nombre: data.nombre,
                telefono: data.telefono,
                notas: data.notas,
                createdAt: data.createdAt,
                updatedAt: data.updatedAt,
              );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del cliente'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: cliente == null
                ? null
                : () {
                    Navigator.pushNamed(
                      context,
                      AppRouter.clienteForm,
                      arguments: ClienteFormArgs(id: clienteId),
                    );
                  },
          ),
        ],
      ),
      body: cliente == null
          ? const Center(child: Text('No se encontr� el cliente'))
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cliente.nombre,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      _buildRow('Tel�fono', cliente.telefono ?? 'No registrado'),
                      const SizedBox(height: 8),
                      _buildRow('Notas', cliente.notas?.isNotEmpty == true
                          ? cliente.notas!
                          : 'Sin notas'),
                      const SizedBox(height: 24),
                      if (cliente.createdAt != null)
                        Text(
                          'Creado: ${_formatDate(cliente.createdAt!)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      if (cliente.updatedAt != null)
                        Text(
                          'Actualizado: ${_formatDate(cliente.updatedAt!)}',
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(value),
        ),
      ],
    );
  }

  String _formatDate(DateTime value) {
    return value.toLocal().toString().split('.').first;
  }
}

class _ClienteDetailModel {
  const _ClienteDetailModel({
    required this.nombre,
    this.telefono,
    this.notas,
    this.createdAt,
    this.updatedAt,
  });

  final String nombre;
  final String? telefono;
  final String? notas;
  final DateTime? createdAt;
  final DateTime? updatedAt;
}