import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../presentation/shared/snackbars.dart';
import '../../providers/carrito_provider.dart';
import '../../providers/clientes_provider.dart';
import '../../routes/app_router.dart';

class ConfirmacionPedidoPage extends StatefulWidget {
  const ConfirmacionPedidoPage({super.key});

  @override
  State<ConfirmacionPedidoPage> createState() => _ConfirmacionPedidoPageState();
}

class _ConfirmacionPedidoPageState extends State<ConfirmacionPedidoPage> {
  final _notasController = TextEditingController();
  DateTime _fechaEntrega = DateTime.now().add(const Duration(hours: 24));
  int? _clienteSeleccionado;

  @override
  void dispose() {
    _notasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CarritoProvider>();
    final clientes =
        context.watch<ClientesProvider>().todosLosClientes;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmar pedido'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<int?>(
              decoration: const InputDecoration(
                labelText: 'Cliente (opcional)',
              ),
              value: _clienteSeleccionado,
              items: [
                const DropdownMenuItem<int?>(
                  value: null,
                  child: Text('Sin cliente asignado'),
                ),
                ...clientes.map(
                  (cliente) => DropdownMenuItem<int?>(
                    value: cliente.id,
                    child: Text(cliente.nombre),
                  ),
                ),
              ],
              onChanged: (value) => setState(() => _clienteSeleccionado = value),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Fecha de entrega'),
              subtitle: Text(_formatDate(_fechaEntrega)),
              trailing: const Icon(Icons.calendar_today_outlined),
              onTap: _seleccionarFecha,
            ),
            const SizedBox(height: 16),
            Text('Resumen', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: provider.items.length,
                itemBuilder: (context, index) {
                  final item = provider.items[index];
                  return ListTile(
                    title: Text(item.postreNombre ?? item.postre?.nombre ?? ''),
                    subtitle: Text('Cantidad: ${item.cantidad}'),
                    trailing: Text('Q${item.total.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
            Text('Total: Q${provider.total.toStringAsFixed(2)}'),
            const SizedBox(height: 16),
            TextField(
              controller: _notasController,
              decoration: const InputDecoration(
                labelText: 'Notas (opcional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: provider.isProcessing ? null : _confirmar,
              icon: provider.isProcessing
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check_circle_outline),
              label: Text(
                  provider.isProcessing ? 'Procesando…' : 'Confirmar pedido'),
            ),
            if (provider.error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  provider.error!,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _seleccionarFecha() async {
    final fechaActual = _fechaEntrega;
    final fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: fechaActual,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (fechaSeleccionada == null) return;
    final horaSeleccionada = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(fechaActual),
    );
    if (horaSeleccionada == null) return;
    setState(() {
      _fechaEntrega = DateTime(
        fechaSeleccionada.year,
        fechaSeleccionada.month,
        fechaSeleccionada.day,
        horaSeleccionada.hour,
        horaSeleccionada.minute,
      );
    });
  }

  Future<void> _confirmar() async {
    final provider = context.read<CarritoProvider>();
    final exito = await provider.confirmarPedido(
      notas: _notasController.text,
      clienteId: _clienteSeleccionado,
      fechaEntrega: _fechaEntrega,
    );
    if (!mounted) return;
    if (exito) {
      final mensaje = provider.ultimoMensaje ?? 'Pedido creado';
      showSuccessSnackBar(context, mensaje);
      Navigator.popUntil(
          context, ModalRoute.withName(AppRouter.pedidosCatalogo));
    } else {
      final error = provider.error ?? 'No fue posible confirmar el pedido';
      showErrorSnackBar(context, error);
    }
  }

  String _formatDate(DateTime value) {
    return value.toLocal().toString().split('.').first;
  }
}