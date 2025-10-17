import 'package:flutter/material.dart';

import '../../routes/app_router.dart';

class HomeMenuPage extends StatelessWidget {
  const HomeMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      _MenuItem('Clientes', Icons.people_alt, AppRouter.clientes),
      _MenuItem('Postres', Icons.cake, AppRouter.postres),
      _MenuItem('Categorías', Icons.category, AppRouter.categorias),
      _MenuItem('Pedidos', Icons.shopping_cart, AppRouter.pedidosCatalogo),
      _MenuItem('Inventario', Icons.inventory_2, AppRouter.inventario),
      _MenuItem('Reportes', Icons.bar_chart, AppRouter.reportes),
      _MenuItem('Configuración', Icons.settings, AppRouter.configuracion),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú principal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: MediaQuery.of(context).size.width > 700 ? 3 : 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: menuItems
              .map(
                (item) => _MenuCard(
                  item: item,
                  onTap: () => Navigator.pushNamed(context, item.route),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _MenuItem {
  const _MenuItem(this.title, this.icon, this.route);

  final String title;
  final IconData icon;
  final String route;
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({required this.item, required this.onTap});

  final _MenuItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: theme.colorScheme.primaryContainer,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon,
                  size: 48, color: theme.colorScheme.onPrimaryContainer),
              const SizedBox(height: 16),
              Text(
                item.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
