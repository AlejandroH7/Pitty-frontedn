import 'package:flutter/material.dart';

import 'package:pitty_app/core/utils/validators.dart';
import 'package:pitty_app/data/models/models.dart';
import 'package:pitty_app/providers/postres_provider.dart';

class RecetaItemForm extends StatefulWidget {
  const RecetaItemForm({
    super.key,
    required this.postreId,
    required this.controller,
    this.ingredienteActual,
  });

  final int postreId;
  final PostresProvider controller;
  final RecetaItem? ingredienteActual;

  @override
  State<RecetaItemForm> createState() => _RecetaItemFormState();
}

class _RecetaItemFormState extends State<RecetaItemForm> {
  final _formKey = GlobalKey<FormState>();
  int? _ingredienteId;
  late final TextEditingController _cantidadController;
  late final TextEditingController _mermaController;
  bool _simulateError = false;
  bool _loading = true;
  List<Ingrediente> _ingredientes = [];

  @override
  void initState() {
    super.initState();
    _cantidadController = TextEditingController(
      text: widget.ingredienteActual?.cantidadPorPostre.toString() ?? '',
    );
    _mermaController = TextEditingController(
      text: widget.ingredienteActual?.mermaPct.toString() ?? '0',
    );
    _ingredienteId = widget.ingredienteActual?.ingredienteId;
    _cargarIngredientes();
  }

  @override
  void dispose() {
    _cantidadController.dispose();
    _mermaController.dispose();
    super.dispose();
  }

  Future<void> _cargarIngredientes() async {
    final data = await widget.controller.ingredientesDisponibles();
    setState(() {
      _ingredientes = data;
      _loading = false;
      _ingredienteId ??= widget.ingredienteActual?.ingredienteId ?? (data.isNotEmpty ? data.first.id : null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.ingredienteActual == null ? 'Agregar ingrediente' : 'Editar ingrediente'),
      content: _loading
          ? const SizedBox(height: 120, child: Center(child: CircularProgressIndicator()))
          : Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<int>(
                    value: _ingredienteId,
                    decoration: const InputDecoration(labelText: 'Ingrediente *'),
                    items: _ingredientes
                        .map((ingrediente) => DropdownMenuItem<int>(
                              value: ingrediente.id,
                              child: Text(ingrediente.nombre),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => _ingredienteId = value),
                    validator: (value) => value == null ? 'Selecciona un ingrediente' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _cantidadController,
                    decoration: const InputDecoration(labelText: 'Cantidad por postre *'),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) => positiveNumber(value, message: 'Debe ser mayor a 0'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _mermaController,
                    decoration: const InputDecoration(labelText: 'Merma % (0-100) *'),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      final number = double.tryParse(value ?? '');
                      if (number == null) return 'Ingresa un numero';
                      if (number < 0 || number > 100) return 'Debe estar entre 0 y 100';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile.adaptive(
                    value: _simulateError,
                    onChanged: (value) => setState(() => _simulateError = value),
                    title: const Text('Simular error al guardar'),
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
          onPressed: _loading ? null : _submit,
          child: const Text('Guardar'),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final ingredienteId = _ingredienteId;
    if (ingredienteId == null) return;
    try {
      await widget.controller.guardarItemReceta(
        postreId: widget.postreId,
        ingredienteId: ingredienteId,
        cantidad: parseDouble(_cantidadController.text),
        merma: parseDouble(_mermaController.text),
        simulateError: _simulateError,
      );
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;
      Navigator.pop(context, false);
    }
  }
}

