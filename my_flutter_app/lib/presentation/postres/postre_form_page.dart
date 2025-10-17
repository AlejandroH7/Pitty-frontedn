import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/app_primary_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../presentation/shared/snackbars.dart';
import '../../providers/categorias_provider.dart';
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
  final _descripcionController = TextEditingController();
  final _imagenController = TextEditingController();
  int? _categoriaId;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final categoriasProvider = context.read<CategoriasProvider>();
      if (!categoriasProvider.isLoading &&
          categoriasProvider.categorias.isEmpty) {
        categoriasProvider.load();
      }
      if (widget.postreId != null) {
        final existente =
            context.read<PostresProvider>().obtenerPorId(widget.postreId!);
        if (existente != null) {
          _nombreController.text = existente.nombre;
          _precioController.text = existente.precio.toStringAsFixed(2);
          _descripcionController.text = existente.descripcion ?? '';
          _imagenController.text = existente.imagenUrl ?? '';
          _categoriaId = existente.categoriaId;
        }
      }
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _precioController.dispose();
    _descripcionController.dispose();
    _imagenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postresProvider = context.watch<PostresProvider>();
    final categoriasProvider = context.watch<CategoriasProvider>();
    final isEdit = widget.postreId != null;
    final categorias = categoriasProvider.categorias;

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
              DropdownButtonFormField<int?>(
                value: _categoriaId,
                items: [
                  const DropdownMenuItem<int?>(
                    value: null,
                    child: Text('Sin categoría'),
                  ),
                  ...categorias.map(
                    (cat) => DropdownMenuItem<int?>(
                      value: cat.id,
                      child: Text(cat.nombre),
                    ),
                  ),
                ],
                onChanged: (value) => setState(() => _categoriaId = value),
                decoration: const InputDecoration(labelText: 'Categoría'),
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _descripcionController,
                label: 'Descripción',
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value != null && value.length > 150) {
                    return 'Máximo 150 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _imagenController,
                label: 'URL de imagen',
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return null;
                  }
                  final pattern = RegExp(r'^(http|https)://');
                  if (!pattern.hasMatch(value.trim())) {
                    return 'Debe iniciar con http:// o https://';
                  }
                  return null;
                },
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
    final precio = double.parse(_precioController.text.replaceAll(',', '.'));
    final exito = await provider.guardar(
      id: widget.postreId,
      nombre: _nombreController.text,
      precio: precio,
      categoriaId: _categoriaId,
      descripcion: _descripcionController.text,
      imagenUrl: _imagenController.text,
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
