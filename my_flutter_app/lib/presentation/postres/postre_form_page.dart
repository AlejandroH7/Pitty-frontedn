import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pitty_app/core/utils/validators.dart';
import 'package:pitty_app/data/models/postre.dart';
import 'package:pitty_app/providers/postres_provider.dart';

class PostreFormPage extends StatefulWidget {
  const PostreFormPage({super.key, this.postre});

  final Postre? postre;

  @override
  State<PostreFormPage> createState() => _PostreFormPageState();
}

class _PostreFormPageState extends State<PostreFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreController;
  late final TextEditingController _precioController;
  late final TextEditingController _porcionesController;
  bool _activo = true;
  bool _simulateError = false;

  @override
  void initState() {
    super.initState();
    final postre = widget.postre;
    _nombreController = TextEditingController(text: postre?.nombre ?? '');
    _precioController = TextEditingController(
      text: postre != null ? postre.precio.toStringAsFixed(2) : '',
    );
    _porcionesController = TextEditingController(
      text: postre != null ? postre.porciones.toString() : '',
    );
    _activo = postre?.activo ?? true;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _precioController.dispose();
    _porcionesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.postre != null;
    final controller = context.watch<PostresProvider>();
    return Scaffold(
      appBar: AppBar(title: Text(editing ? 'Editar postre' : 'Nuevo postre')),
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
              controller: _precioController,
              decoration: const InputDecoration(labelText: 'Precio (S/) *'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) => positiveNumber(value, message: 'El precio debe ser mayor a 0'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _porcionesController,
              decoration: const InputDecoration(labelText: 'Porciones *'),
              keyboardType: TextInputType.number,
              validator: (value) {
                final number = int.tryParse(value ?? '');
                if (number == null || number < 1) {
                  return 'Las porciones deben ser al menos 1';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile.adaptive(
              value: _activo,
              onChanged: (value) => setState(() => _activo = value),
              title: const Text('Postre activo'),
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
    final controller = context.read<PostresProvider>();
    final success = await controller.guardar(
      id: widget.postre?.id,
      nombre: _nombreController.text,
      precio: parseDouble(_precioController.text),
      porciones: int.parse(_porcionesController.text),
      activo: _activo,
      simulateError: _simulateError,
    );
    if (!mounted) return;
    Navigator.of(context).pop(success);
  }
}

