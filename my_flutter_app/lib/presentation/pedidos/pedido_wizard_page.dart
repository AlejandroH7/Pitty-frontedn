import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/date_formatter.dart';
import '../../core/utils/validators.dart';
import '../../data/models/models.dart';
import '../../data/repositories/pedido_repository.dart';
import 'package:pitty_app/providers/pedidos_provider.dart';

class PedidoWizardPage extends StatefulWidget {
  const PedidoWizardPage({super.key});

  @override
  State<PedidoWizardPage> createState() => _PedidoWizardPageState();
}

class _PedidoWizardPageState extends State<PedidoWizardPage> {
  int _currentStep = 0;
  List<Cliente> _clientes = [];
  List<Postre> _postres = [];
  Cliente? _clienteSeleccionado;
  final List<_PedidoItemDraft> _items = [];
  DateTime? _fechaEntrega;
  final TextEditingController _notasController = TextEditingController();
  bool _simulateError = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final controller = context.read<PedidosProvider>();
    final clientes = await controller.listarClientes();
    final postres = await controller.listarPostres();
    setState(() {
      _clientes = clientes;
      _postres = postres;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _notasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo pedido')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Stepper(
              currentStep: _currentStep,
              onStepCancel: _currentStep == 0 ? null : () => setState(() => _currentStep -= 1),
              onStepContinue: _onContinue,
              controlsBuilder: (context, details) {
                return Row(
                  children: [
                    FilledButton(
                      onPressed: details.onStepContinue,
                      child: Text(_currentStep == 2 ? 'Confirmar pedido' : 'Siguiente'),
                    ),
                    const SizedBox(width: 12),
                    if (_currentStep > 0)
                      TextButton(
                        onPressed: details.onStepCancel,
                        child: const Text('Atras'),
                      ),
                  ],
                );
              },
              steps: [
                Step(
                  title: const Text('Cliente'),
                  isActive: _currentStep >= 0,
                  content: _stepClientes(),
                ),
                Step(
                  title: const Text('Items'),
                  isActive: _currentStep >= 1,
                  content: _stepItems(),
                ),
                Step(
                  title: const Text('Resumen'),
                  isActive: _currentStep >= 2,
                  content: _stepResumen(),
                ),
              ],
            ),
    );
  }

  Widget _stepClientes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<int>(
          decoration: const InputDecoration(labelText: 'Selecciona un cliente'),
          value: _clienteSeleccionado?.id,
          items: _clientes
              .map((cliente) => DropdownMenuItem(
                    value: cliente.id,
                    child: Text(cliente.nombre),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _clienteSeleccionado = _clientes.firstWhere((cliente) => cliente.id == value);
            });
          },
        ),
        const SizedBox(height: 12),
        if (_clienteSeleccionado != null)
          Card(
            child: ListTile(
              title: Text(_clienteSeleccionado!.nombre),
              subtitle: Text(_clienteSeleccionado!.telefono ?? 'Sin Telefono'),
            ),
          ),
      ],
    );
  }

  Widget _stepItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_items.isEmpty)
          const EmptyState(message: 'Agrega al menos un postre al pedido.')
        else
          ..._items.asMap().entries.map(
            (entry) {
              final index = entry.key;
              final item = entry.value;
              final postre = _postres.firstWhere((p) => p.id == item.postreId);
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(postre.nombre),
                  subtitle: Text(
                    'Cantidad: ${item.cantidad}\nPrecio unitario: S/ ${item.precioUnitario.toStringAsFixed(2)}\nSubtotal: S/ ${(item.cantidad * item.precioUnitario).toStringAsFixed(2)}',
                  ),
                  trailing: Wrap(
                    spacing: 4,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _openItemDialog(index: index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => setState(() => _items.removeAt(index)),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: () => _openItemDialog(),
          icon: const Icon(Icons.add),
          label: const Text('Agregar postre'),
        ),
      ],
    );
  }

  Widget _stepResumen() {
    final total = _items.fold<double>(0, (sum, item) => sum + item.cantidad * item.precioUnitario);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: const Text('Cliente'),
          subtitle: Text(_clienteSeleccionado?.nombre ?? 'No seleccionado'),
        ),
        const SizedBox(height: 8),
        ListTile(
          title: const Text('Fecha de entrega *'),
          subtitle: Text(_fechaEntrega != null ? formatDateTime(_fechaEntrega) : 'Selecciona una fecha'),
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
              initialDate: _fechaEntrega ?? DateTime.now().add(const Duration(days: 1)),
            );
            if (picked != null) {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(_fechaEntrega ?? DateTime.now()),
              );
              setState(() {
                _fechaEntrega = DateTime(
                  picked.year,
                  picked.month,
                  picked.day,
                  time?.hour ?? 9,
                  time?.minute ?? 0,
                );
              });
            }
          },
        ),
        TextField(
          controller: _notasController,
          decoration: const InputDecoration(labelText: 'Notas (opcional)'),
          maxLines: 3,
        ),
        const SizedBox(height: 8),
        SwitchListTile.adaptive(
          value: _simulateError,
          onChanged: (value) => setState(() => _simulateError = value),
          title: const Text('Simular error al confirmar'),
        ),
        const SizedBox(height: 16),
        Text('Resumen de Items', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        if (_items.isEmpty)
          const EmptyState(message: 'Sin Items')
        else
          ..._items.map((item) {
            final postre = _postres.firstWhere((p) => p.id == item.postreId);
            return ListTile(
              title: Text(postre.nombre),
              trailing: Text('S/ ${(item.cantidad * item.precioUnitario).toStringAsFixed(2)}'),
              subtitle: Text('x${item.cantidad} - S/ ${item.precioUnitario.toStringAsFixed(2)}'),
            );
          }),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'Total estimado: S/ ${total.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ],
    );
  }

  Future<void> _onContinue() async {
    if (_currentStep == 0) {
      if (_clienteSeleccionado == null) {
        _showSnackBar('Selecciona un cliente para continuar', isError: true);
        return;
      }
      setState(() => _currentStep = 1);
    } else if (_currentStep == 1) {
      if (_items.isEmpty) {
        _showSnackBar('Agrega al menos un postre', isError: true);
        return;
      }
      setState(() => _currentStep = 2);
    } else {
      if (_fechaEntrega == null) {
        _showSnackBar('Define la fecha de entrega', isError: true);
        return;
      }
      final controller = context.read<PedidosProvider>();
      final inputs = _items
          .map((item) => PedidoItemInput(
                postreId: item.postreId,
                cantidad: item.cantidad,
                precioUnitario: item.precioUnitario,
              ))
          .toList();
      final success = await controller.crear(
        clienteId: _clienteSeleccionado!.id,
        fechaEntrega: _fechaEntrega!,
        notas: _notasController.text,
        items: inputs,
        simulateError: _simulateError,
      );
      if (!mounted) return;
      Navigator.of(context).pop(success);
    }
  }

  Future<void> _openItemDialog({int? index}) async {
    final initial = index != null ? _items[index] : null;
    final result = await showDialog<_PedidoItemDraft>(
      context: context,
      builder: (_) => _PedidoItemDialog(postres: _postres, initial: initial),
    );
    if (result != null) {
      setState(() {
        if (index != null) {
          _items[index] = result;
        } else {
          _items.add(result);
        }
      });
    }
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

class _PedidoItemDraft {
  _PedidoItemDraft({required this.postreId, required this.cantidad, required this.precioUnitario});

  final int postreId;
  final int cantidad;
  final double precioUnitario;
}

class _PedidoItemDialog extends StatefulWidget {
  const _PedidoItemDialog({required this.postres, this.initial});

  final List<Postre> postres;
  final _PedidoItemDraft? initial;

  @override
  State<_PedidoItemDialog> createState() => _PedidoItemDialogState();
}

class _PedidoItemDialogState extends State<_PedidoItemDialog> {
  final _formKey = GlobalKey<FormState>();
  late int? _postreId;
  late final TextEditingController _cantidadController;
  late final TextEditingController _precioController;

  @override
  void initState() {
    super.initState();
    _postreId = widget.initial?.postreId ?? (widget.postres.isNotEmpty ? widget.postres.first.id : null);
    _cantidadController = TextEditingController(text: widget.initial?.cantidad.toString() ?? '1');
    _precioController = TextEditingController(
      text: widget.initial?.precioUnitario.toStringAsFixed(2) ??
          (_postreSeleccionado?.precio.toStringAsFixed(2) ?? '0'),
    );
  }

  Postre? get _postreSeleccionado =>
      widget.postres.firstWhere((postre) => postre.id == _postreId, orElse: () => widget.postres.first);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Agregar postre'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<int>(
              value: _postreId,
              items: widget.postres
                  .map((postre) => DropdownMenuItem(
                        value: postre.id,
                        child: Text('${postre.nombre} - S/ ${postre.precio.toStringAsFixed(2)}'),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _postreId = value;
                  final precio = _postreSeleccionado?.precio ?? 0;
                  _precioController.text = precio.toStringAsFixed(2);
                });
              },
              validator: (value) => value == null ? 'Selecciona un postre' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cantidadController,
              decoration: const InputDecoration(labelText: 'Cantidad *'),
              keyboardType: TextInputType.number,
              validator: (value) {
                final number = int.tryParse(value ?? '');
                if (number == null || number < 1) {
                  return 'La cantidad debe ser mayor a 0';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _precioController,
              decoration: const InputDecoration(labelText: 'Precio unitario *'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) => positiveNumber(value, message: 'Precio invalido'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            Navigator.pop(
              context,
              _PedidoItemDraft(
                postreId: _postreId!,
                cantidad: int.parse(_cantidadController.text),
                precioUnitario: parseDouble(_precioController.text),
              ),
            );
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
