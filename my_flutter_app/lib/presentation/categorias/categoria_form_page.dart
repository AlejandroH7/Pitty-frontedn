import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/app_primary_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../presentation/shared/snackbars.dart';
import '../../providers/categorias_provider.dart';

class CategoriaFormPage extends StatefulWidget {
  const CategoriaFormPage({super.key, this.categoriaId});

  final int? categoriaId;

  @override
  State<CategoriaFormPage> createState() => _CategoriaFormPageState();
}

class _CategoriaFormPageState extends State<CategoriaFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      if (widget.categoriaId != null) {
        final existente = context
            .read<CategoriasProvider>()
            .obtenerPorId(widget.categoriaId!);
        if (existente != null) {
          _nombreController.text = existente.nombre;
        }
      }
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CategoriasProvider>();
    final isEdit = widget.categoriaId != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Editar categoría' : 'Nueva categoría'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                controller: _nombreController,
                label: 'Nombre *',
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
              const SizedBox(height: 24),
              AppPrimaryButton(
                label: isEdit ? 'Guardar cambios' : 'Crear categoría',
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
    final provider = context.read<CategoriasProvider>();
    final exito = await provider.guardar(
      id: widget.categoriaId,
      nombre: _nombreController.text,
    );
    if (!mounted) return;
    if (exito) {
      showSuccessSnackBar(
        context,
        widget.categoriaId == null ? 'Categoría creada' : 'Cambios guardados',
      );
      Navigator.pop(context);
    } else {
      final error = provider.error ?? 'No fue posible guardar';
      showErrorSnackBar(context, error);
    }
  }
}
