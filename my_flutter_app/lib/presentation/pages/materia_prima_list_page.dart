import 'package:flutter/material.dart';
import 'package:my_flutter_app/presentation/widgets/custom_button.dart';

class MateriaPrimaListPage extends StatelessWidget {
  const MateriaPrimaListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List<_InventoryItem> items = <_InventoryItem>[
      const _InventoryItem(
        name: 'LEVADURA',
        quantity: '7 Unidades',
        description: '7 paquetes de levadura (demo).',
      ),
      const _InventoryItem(
        name: 'AZÚCAR',
        quantity: '7 Unidades',
        description: '7 sacos de azúcar refinada (demo).',
      ),
      const _InventoryItem(
        name: 'CREMA',
        quantity: '7 Unidades',
        description: '7 litros de crema batida (demo).',
      ),
      const _InventoryItem(
        name: 'SAL',
        quantity: '7 Unidades',
        description: '7 paquetes de sal marina (demo).',
      ),
      const _InventoryItem(
        name: 'HARINA',
        quantity: '7 Unidades',
        description: '7 costales de harina especial (demo).',
      ),
      const _InventoryItem(
        name: 'MANTEQUILLA',
        quantity: '7 Unidades',
        description: '7 bloques de mantequilla premium (demo).',
      ),
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
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: items.length + 1,
                    itemBuilder: (context, index) {
                      if (index == items.length) {
                        return ListTile(
                          leading: const Icon(Icons.more_horiz),
                          title: const Text('…(Resto de productos)'),
                          trailing: const Icon(Icons.expand_more),
                          onTap: () {},
                        );
                      }

                      final item = items[index];
                      return ListTile(
                        leading: const Icon(Icons.radio_button_unchecked, size: 20),
                        title: Text(item.name),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/inventario/materia-prima/detalle',
                            arguments: <String, String>{
                              'nombre': item.name,
                              'cantidad': item.quantity,
                              'descripcion': item.description,
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),
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

class _InventoryItem {
  const _InventoryItem({
    required this.name,
    required this.quantity,
    required this.description,
  });

  final String name;
  final String quantity;
  final String description;
}
