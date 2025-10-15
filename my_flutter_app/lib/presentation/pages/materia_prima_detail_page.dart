import 'package:flutter/material.dart';
import 'package:my_flutter_app/presentation/widgets/custom_button.dart';

class MateriaPrimaDetailPage extends StatelessWidget {
  const MateriaPrimaDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
    final nombre = args?['nombre'] ?? 'MATERIA';
    final cantidad = args?['cantidad'] ?? '0 Unidades';
    final descripcion = args?['descripcion'] ?? 'Sin descripción.';

    return Scaffold(
      backgroundColor: theme.colorScheme.background, // ignore: deprecated_member_use
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
                  'Inventario de materias primas',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Materia: $nombre',
                          style: theme.textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Cantidad: $cantidad',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Descripción: $descripcion',
                          style: theme.textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Semantics(
                  button: true,
                  label: 'Editar',
                  child: CustomButton(
                    label: 'Editar',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Editar (UI demo)')),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Semantics(
                  button: true,
                  label: 'Volver',
                  child: CustomButton(
                    label: 'Volver',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
