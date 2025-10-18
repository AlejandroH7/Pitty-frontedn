import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pitty_app/core/utils/date_formatter.dart';
import 'package:pitty_app/core/utils/validators.dart';
import 'package:pitty_app/data/models/evento.dart';
import 'package:pitty_app/data/models/pedido.dart';
import 'package:pitty_app/providers/eventos_provider.dart';

class EventoFormPage extends StatefulWidget {
  const EventoFormPage({super.key, this.evento});

  final Evento? evento;

  @override
  State<EventoFormPage> createState() => _EventoFormPageState();
}

class _EventoFormPageState extends State<EventoFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _tituloController;
  late final TextEditingController _lugarController;
  late final TextEditingController _notasController;
  DateTime? _fechaHora;
  int? _pedidoId;
  bool _simulateError = false;
  bool _loadingPedidos = true;
  List<Pedido> _pedidos = [];

  @override
  void initState() {
    super.initState();
    final evento = widget.evento;
    _tituloController = TextEditingController(text: evento?.titulo ?? '');
    _lugarController = TextEditingController(text: evento?.lugar ?? '');
    _notasController = TextEditingController(text: evento?.notas ?? '');
    _fechaHora = evento?.fechaHora;
    _pedidoId = evento?.pedidoId;
    _cargarPedidos();
  }

  Future<void> _cargarPedidos() async {
    final pedidos = await context.read<EventosProvider>().listarPedidos();
    setState(() {
      _pedidos = pedidos;
      _loadingPedidos = false;
    });
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _lugarController.dispose();
    _notasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.evento != null;
    final controller = context.watch<EventosProvider>();
    return Scaffold(
      appBar: AppBar(title: Text(editing ? 'Editar evento' : 'Nuevo evento')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _tituloController,
              decoration: const InputDecoration(labelText: 'Titulo *'),
              validator: (value) {
                final requiredResult = requiredField(value, message: 'El Titulo es obligatorio');
                if (requiredResult != null) return requiredResult;
                if ((value ?? '').length > 150) {
                  return 'El Titulo no puede superar 150 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _lugarController,
              decoration: const InputDecoration(labelText: 'Lugar'),
              maxLength: 150,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Fecha y hora *'),
              subtitle: Text(_fechaHora != null ? formatDateTime(_fechaHora) : 'Selecciona fecha y hora'),
              trailing: const Icon(Icons.schedule),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                  initialDate: _fechaHora ?? DateTime.now().add(const Duration(days: 1)),
                );
                if (date != null) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(_fechaHora ?? DateTime.now()),
                  );
                  setState(() {
                    _fechaHora = DateTime(
                      date.year,
                      date.month,
                      date.day,
                      time?.hour ?? 9,
                      time?.minute ?? 0,
                    );
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            if (_loadingPedidos)
              const Center(child: CircularProgressIndicator())
            else
              DropdownButtonFormField<int?>(
                decoration: const InputDecoration(labelText: 'Pedido asociado'),
                value: _pedidoId,
                items: [
                  const DropdownMenuItem<int?>(value: null, child: Text('Ninguno')),
                  ..._pedidos.map(
                    (pedido) => DropdownMenuItem<int?>(
                      value: pedido.id,
                      child: Text('#${pedido.id} - ${pedido.clienteNombre}'),
                    ),
                  ),
                ],
                onChanged: (value) => setState(() => _pedidoId = value),
              ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notasController,
              decoration: const InputDecoration(labelText: 'Notas'),
              maxLines: 3,
              maxLength: 500,
            ),
            const SizedBox(height: 16),
            SwitchListTile.adaptive(
              value: _simulateError,
              onChanged: (value) => setState(() => _simulateError = value),
              title: const Text('Simular error al guardar'),
            ),
            const SizedBox(height: 16),
            if (controller.loading)
              const Padding(
                padding: EdgeInsets.only(bottom: 12.0),
                child: Text('Cargando...'),
              ),
            FilledButton.icon(
              onPressed: controller.loading ? null : _submit,
              icon: const Icon(Icons.save),
              label: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_fechaHora == null) {
      _showSnackBar('Selecciona fecha y hora', isError: true);
      return;
    }
    final controller = context.read<EventosProvider>();
    final success = await controller.guardar(
      id: widget.evento?.id,
      titulo: _tituloController.text,
      lugar: _lugarController.text,
      fechaHora: _fechaHora!,
      pedidoId: _pedidoId,
      notas: _notasController.text,
      simulateError: _simulateError,
    );
    if (!mounted) return;
    Navigator.of(context).pop(success);
  }

  void _showSnackBar(String message, {bool isError = false}) {
    final scheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? scheme.error : scheme.primary,
      ),
    );
  }
}

