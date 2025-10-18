import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/app_primary_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../presentation/shared/snackbars.dart';
import '../../providers/postres_provider.dart';

class PostreFormPage extends StatefulWidget {
  const PostreFormPage({super.key, this.postreId});

  final int? postreId;

  @override
  State<PostreFormPage> createState() => _PostreFormPageState();
}

class _PostreFormPageState extends State<PostreFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _precioController = TextEditingController();
  final _porcionesController = TextEditingController(text: '1');
  bool _activo = true;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      if (widget.postreId != null) {
        final existente =
            context.read<PostresProvider>().obtenerPorId(widget.postreId!);
        if (existente != null) {
          _nombreController.text = existente.nombre;
          _precioController.text = existente.precio.toStringAsFixed(2);
          _porcionesController.text = existente.porciones.toString();
          _activo = existente.activo;
        }
      }
    }
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
    final postresProvider = context.watch<PostresProvider>();
    final isEdit = widget.postreId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Editar postre' : 'Nuevo postre'),
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
                controller: _precioController,
                label: 'Precio *',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El precio es obligatorio';
                  }
                  final parsed = double.tryParse(value.replaceAll(',', '.'));
                  if (parsed == null || parsed <= 0) {
                    return 'Ingresa un número válido mayor a 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _porcionesController,
                label: 'Porciones *',
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Las porciones son obligatorias';
                  }
                  final parsed = int.tryParse(value.trim());
                  if (parsed == null || parsed <= 0) {
                    return 'Ingresa un número entero mayor a 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Disponible (activo)'),
                value: _activo,
                onChanged: (value) => setState(() => _activo = value),
              ),
              const SizedBox(height: 24),
              AppPrimaryButton(
                label: isEdit ? 'Guardar cambios' : 'Crear postre',
                isLoading: postresProvider.isSaving,
                onPressed: postresProvider.isSaving ? null : _guardar,
              ),
              if (postresProvider.error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    postresProvider.error!,
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
    final provider = context.read<PostresProvider>();
    final precio =
        double.parse(_precioController.text.replaceAll(',', '.'));
    final porciones = int.parse(_porcionesController.text.trim());
    final exito = await provider.guardar(
      id: widget.postreId,
      nombre: _nombreController.text,
      precio: precio,
      porciones: porciones,
      activo: _activo,
    );
    if (!mounted) return;
    if (exito) {
      showSuccessSnackBar(
        context,
        widget.postreId == null ? 'Postre creado' : 'Cambios guardados',
      );
      Navigator.pop(context);
    } else {
      final error = provider.error ?? 'No fue posible guardar';
      showErrorSnackBar(context, error);
    }
  }
}