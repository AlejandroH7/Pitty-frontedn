import 'package:flutter/material.dart';
import 'package:my_flutter_app/presentation/widgets/custom_button.dart';

class PostresAddPage extends StatefulWidget {
  const PostresAddPage({super.key});

  @override
  State<PostresAddPage> createState() => _PostresAddPageState();
}

class _PostresAddPageState extends State<PostresAddPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _qtyCtrl = TextEditingController();
  final TextEditingController _noteCtrl = TextEditingController();
  List<String> _selectedMaterias = <String>[];

  final List<String> _materias = <String>[
    'HARINA',
    'AZÚCAR',
    'MANTEQUILLA',
    'HUEVOS',
    'LECHE',
    'CREMA',
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _qtyCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(BuildContext context, String label) {
    final colorScheme = Theme.of(context).colorScheme;
    return InputDecoration(
      labelText: label,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
      ),
    );
  }

  void _handleSave() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final data = <String, String>{
      'nombre': _nameCtrl.text.trim(),
      'cantidad': _qtyCtrl.text.trim(),
      'materiasPrimas': _selectedMaterias.join(', '),
      'nota': _noteCtrl.text.trim(),
    };

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Postre registrado',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 140,
                child: CustomButton(
                  label: 'Aceptar',
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacementNamed(
                      context,
                      '/inventario/postres/detalle',
                      arguments: data,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background, // ignore: deprecated_member_use
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 24),
                Text(
                  'Agregar postre a inventario',
                  style: theme.textTheme.headlineLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      TextFormField(
                        controller: _nameCtrl,
                        textInputAction: TextInputAction.next,
                        decoration: _inputDecoration(context, 'Nombre'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Campo obligatorio';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _qtyCtrl,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        decoration: _inputDecoration(context, 'Cantidad'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Campo obligatorio';
                          }
                          final parsed = num.tryParse(value.trim());
                          if (parsed == null || parsed <= 0) {
                            return 'Ingrese un número válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      FormField<List<String>>(
                        initialValue: _selectedMaterias,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Selecciona al menos una opción';
                          }
                          return null;
                        },
                        builder: (state) {
                          return InputDecorator(
                            decoration: _inputDecoration(
                              context,
                              'Materias primas a utilizar',
                            ).copyWith(
                              errorText: state.errorText,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                            ),
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _materias.map((materia) {
                                final selected = state.value!.contains(materia);
                                return FilterChip(
                                  label: Text(materia),
                                  selected: selected,
                                  selectedColor:
                                      colorScheme.primary.withValues(alpha: 0.12),
                                  checkmarkColor: colorScheme.primary,
                                  onSelected: (isSelected) {
                                    setState(() {
                                      final updated = List<String>.from(state.value!);
                                      if (isSelected) {
                                        updated.add(materia);
                                      } else {
                                        updated.remove(materia);
                                      }
                                      _selectedMaterias = updated;
                                      state.didChange(updated);
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _noteCtrl,
                        minLines: 2,
                        maxLines: 4,
                        decoration: _inputDecoration(context, 'Anotación'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Campo obligatorio';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: 220,
                  child: CustomButton(
                    label: 'Guardar',
                    onPressed: _handleSave,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 220,
                  child: CustomButton(
                    label: 'Volver',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
