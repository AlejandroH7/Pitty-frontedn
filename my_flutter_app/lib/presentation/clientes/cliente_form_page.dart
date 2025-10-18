import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/app_primary_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../presentation/shared/snackbars.dart';
import '../../providers/clientes_provider.dart';

class ClienteFormPage extends StatefulWidget {
  const ClienteFormPage({super.key, this.clienteId});

  final int? clienteId;

  @override
  State<ClienteFormPage> createState() => _ClienteFormPageState();
}

class _ClienteFormPageState extends State<ClienteFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _notasController = TextEditingController();
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      if (widget.clienteId != null) {
        final existente =
            context.read<ClientesProvider>().obtenerPorId(widget.clienteId!);
        if (existente != null) {
          _nombreController.text = existente.nombre;
          _telefonoController.text = existente.telefono ?? '';
          _notasController.text = existente.notas ?? '';
        }
      }
    }
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
    final provider = context.watch<ClientesProvider>();
    final isEdit = widget.clienteId != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Editar cliente' : 'Nuevo cliente'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                controller: _nombreController,
                label: 'Nombre *',
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El nombre es obligatorio';
                  }
                  if (value.trim().length < 2) {
                    return 'Debe tener al menos 2 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _telefonoController,
                label: 'Teléfono',
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return null;
                  }
                  final pattern = RegExp(r'^[- +()0-9]{6,20}$');
                  if (!pattern.hasMatch(value.trim())) {
                    return 'Formato de teléfono no válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _notasController,
                label: 'Notas',
                keyboardType: TextInputType.multiline,
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              AppPrimaryButton(
                label: isEdit ? 'Guardar cambios' : 'Crear cliente',
                isLoading: provider.isSaving,
                onPressed: provider.isSaving ? null : _guardar,
              ),
              if (provider.error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    provider.error!,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<ClientesProvider>();
    final exito = await provider.guardar(
      id: widget.clienteId,
      nombre: _nombreController.text,
      telefono: _telefonoController.text,
      notas: _notasController.text,
    );
    if (!mounted) return;
    if (exito) {
      showSuccessSnackBar(
        context,
        widget.clienteId == null ? 'Cliente guardado' : 'Cambios guardados',
      );
      Navigator.pop(context);
    } else {
      final error = provider.error ?? 'No fue posible guardar';
      showErrorSnackBar(context, error);
    }
  }
}