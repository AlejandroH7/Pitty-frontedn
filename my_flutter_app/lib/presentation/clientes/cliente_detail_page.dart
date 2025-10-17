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
                correo: data.correo,
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
          ? const Center(child: Text('No se encontró el cliente'))
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
                      _buildRow(
                          'Teléfono', cliente.telefono ?? 'No registrado'),
                      const SizedBox(height: 8),
                      _buildRow('Correo', cliente.correo ?? 'No registrado'),
                      const SizedBox(height: 32),
                      Text(
                        'Última actualización simulada: ${DateTime.now().toLocal()}'
                            .split('.')
                            .first,
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
}

class _ClienteDetailModel {
  const _ClienteDetailModel({
    required this.nombre,
    this.telefono,
    this.correo,
  });

  final String nombre;
  final String? telefono;
  final String? correo;
}
