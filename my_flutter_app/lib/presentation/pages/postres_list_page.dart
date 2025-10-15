import 'package:flutter/material.dart';
import 'package:my_flutter_app/presentation/widgets/custom_button.dart';

class PostresListPage extends StatelessWidget {
  const PostresListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List<Map<String, Object>> items = <Map<String, Object>>[
      <String, Object>{
        'nombre': 'Chunkys de fresa',
        'cantidad': '7 Unidades',
        'materias': <String>['HARINA', 'AZÚCAR', 'MANTEQUILLA', 'FRESA'],
        'descripcion': 'Base de vainilla con trozos de fresa.',
      },
      <String, Object>{
        'nombre': 'Chunkys de limón',
        'cantidad': '5 Unidades',
        'materias': <String>['HARINA', 'AZÚCAR', 'MANTEQUILLA', 'LIMÓN'],
        'descripcion': 'Postre cítrico con ralladura de limón.',
      },
      <String, Object>{
        'nombre': 'Chunkys de queso',
        'cantidad': '6 Unidades',
        'materias': <String>['HARINA', 'AZÚCAR', 'MANTEQUILLA', 'QUESO CREMA'],
        'descripcion': 'Suave y cremoso.',
      },
      <String, Object>{
        'nombre': 'Chunkys de galleta',
        'cantidad': '9 Unidades',
        'materias': <String>['HARINA', 'AZÚCAR', 'MANTEQUILLA', 'GALLETAS'],
        'descripcion': 'Con trozos de galleta.',
      },
    ];

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
                  'Inventario de Postres',
                  style: theme.textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: items.length + 1,
                      itemBuilder: (context, index) {
                        if (index == items.length) {
                          return ListTile(
                            dense: true,
                            leading: const Icon(Icons.more_horiz),
                            title: const Text('…(Resto de productos)'),
                            trailing: const Icon(Icons.expand_more),
                            onTap: () {},
                          );
                        }

                        final item = items[index];
                        return ListTile(
                          dense: true,
                          leading: const Icon(Icons.radio_button_unchecked, size: 20),
                          title: Text((item['nombre'] as String).toUpperCase()),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/inventario/postres/detalle',
                              arguments: item,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: 220,
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
