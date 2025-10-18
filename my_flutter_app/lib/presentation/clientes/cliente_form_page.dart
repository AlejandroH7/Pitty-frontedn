import 'package:flutter/material.dart';
import 'package:pitty_app/core/utils/validators.dart';
import 'package:pitty_app/data/models/cliente.dart';
import 'package:pitty_app/providers/clientes_provider.dart';
import 'package:provider/provider.dart';

class ClienteFormPage extends StatefulWidget {
  const ClienteFormPage({super.key, this.cliente});

  final Cliente? cliente;

  @override
  State<ClienteFormPage> createState() => _ClienteFormPageState();
}

class _ClienteFormPageState extends State<ClienteFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreController;
  late final TextEditingController _telefonoController;
  late final TextEditingController _notasController;
  bool _simulateError = false;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.cliente?.nombre ?? '');
    _telefonoController = TextEditingController(text: widget.cliente?.telefono ?? '');
    _notasController = TextEditingController(text: widget.cliente?.notas ?? '');
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _telefonoController.dispose();
    _notasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.cliente != null;
    final controller = context.watch<ClientesProvider>();
    return Scaffold(
      appBar: AppBar(title: Text(editing ? 'Editar cliente' : 'Nuevo cliente')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre *'),
              validator: (value) {
                final requiredResult = requiredField(value, message: 'El nombre es obligatorio');
                if (requiredResult != null) return requiredResult;
                if ((value ?? '').length > 120) {
                  return 'El nombre no debe exceder 120 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _telefonoController,
              decoration: const InputDecoration(labelText: 'Telefono'),
              maxLength: 30,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notasController,
              decoration: const InputDecoration(labelText: 'Notas'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            SwitchListTile.adaptive(
              value: _simulateError,
              onChanged: (value) => setState(() => _simulateError = value),
              title: const Text('Simular error al guardar'),
              subtitle: const Text('Util para probar el estado "Error (simulado)"'),
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
    final controller = context.read<ClientesProvider>();
    final success = await controller.guardar(
      id: widget.cliente?.id,
      nombre: _nombreController.text,
      telefono: _telefonoController.text,
      notas: _notasController.text,
      simulateError: _simulateError,
    );
    if (!mounted) return;
    Navigator.of(context).pop(success);
  }
}
