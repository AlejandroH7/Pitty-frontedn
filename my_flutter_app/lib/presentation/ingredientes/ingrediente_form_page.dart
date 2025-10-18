import 'package:flutter/material.dart';
import 'package:pitty_app/core/utils/validators.dart';
import 'package:pitty_app/data/models/ingrediente.dart';
import 'package:pitty_app/providers/ingredientes_provider.dart';
import 'package:provider/provider.dart';

class IngredienteFormPage extends StatefulWidget {
  const IngredienteFormPage({super.key, this.ingrediente});

  final Ingrediente? ingrediente;

  @override
  State<IngredienteFormPage> createState() => _IngredienteFormPageState();
}

class _IngredienteFormPageState extends State<IngredienteFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreController;
  late final TextEditingController _unidadController;
  late final TextEditingController _stockMinimoController;
  late final TextEditingController _stockActualController;
  bool _activo = true;
  bool _simulateError = false;

  @override
  void initState() {
    super.initState();
    final ingrediente = widget.ingrediente;
    _nombreController = TextEditingController(text: ingrediente?.nombre ?? '');
    _unidadController = TextEditingController(text: ingrediente?.unidad ?? '');
    _stockMinimoController = TextEditingController(
      text: ingrediente != null ? ingrediente.stockMinimo.toString() : '',
    );
    _stockActualController = TextEditingController(
      text: ingrediente != null ? ingrediente.stockActual.toString() : '',
    );
    _activo = ingrediente?.activo ?? true;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _unidadController.dispose();
    _stockMinimoController.dispose();
    _stockActualController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.ingrediente != null;
    final controller = context.watch<IngredientesProvider>();
    return Scaffold(
      appBar: AppBar(title: Text(editing ? 'Editar ingrediente' : 'Nuevo ingrediente')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre *'),
              validator: (value) => requiredField(value, message: 'El nombre es obligatorio'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _unidadController,
              decoration: const InputDecoration(labelText: 'Unidad *'),
              validator: (value) => requiredField(value, message: 'La unidad es obligatoria'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _stockMinimoController,
              decoration: const InputDecoration(labelText: 'Stock minimo *'),
              keyboardType: TextInputType.number,
              validator: (value) => nonNegativeNumber(value, message: 'El stock minimo no puede ser negativo'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _stockActualController,
              decoration: const InputDecoration(labelText: 'Stock actual *'),
              keyboardType: TextInputType.number,
              validator: (value) => nonNegativeNumber(value, message: 'El stock actual no puede ser negativo'),
            ),
            const SizedBox(height: 16),
            SwitchListTile.adaptive(
              value: _activo,
              onChanged: (value) => setState(() => _activo = value),
              title: const Text('Ingrediente activo'),
            ),
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
    final controller = context.read<IngredientesProvider>();
    final success = await controller.guardar(
      id: widget.ingrediente?.id,
      nombre: _nombreController.text,
      unidad: _unidadController.text,
      stockMinimo: parseDouble(_stockMinimoController.text),
      stockActual: parseDouble(_stockActualController.text),
      activo: _activo,
      simulateError: _simulateError,
    );
    if (!mounted) return;
    Navigator.of(context).pop(success);
  }
}
