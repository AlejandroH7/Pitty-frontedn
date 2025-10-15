// lib/presentation/pages/event_add_page.dart
import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class EventAddPage extends StatelessWidget {
  const EventAddPage({super.key});

  InputDecoration _decoration(BuildContext context, String label,
      {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      suffixIcon: suffixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 24),
                Text(
                  'Agregar Evento',
                  style: theme.textTheme.headlineLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Nombre del evento
                TextField(
                  decoration: _decoration(context, 'Nombre del evento'),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),

                // Nombre del cliente
                TextField(
                  decoration: _decoration(context, 'Nombre del cliente'),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),

                // Postre a vender
                TextField(
                  decoration: _decoration(context, 'Postre a vender'),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),

                // Cantidad
                TextField(
                  decoration: _decoration(context, 'Cantidad'),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),

                // Lugar
                TextField(
                  decoration: _decoration(context, 'Lugar'),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),

                // Anotación (Opcional)
                TextField(
                  minLines: 2,
                  maxLines: 4,
                  decoration: _decoration(context, 'Anotación (Opcional)'),
                ),
                const SizedBox(height: 16),

                // Fecha
                TextField(
                  readOnly: true,
                  decoration: _decoration(
                    context,
                    'Fecha',
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                ),

                const SizedBox(height: 32),

                // Botones
                SizedBox(
                  width: 220,
                  child: CustomButton(
                    label: 'Guardar',
                    filled: true,
                    onPressed: () {
                      // Solo UI (sin validación ni navegación)
                    },
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 220,
                  child: CustomButton(
                    label: 'Volver',
                    filled: true,
                    onPressed: () => Navigator.pop(context),
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
