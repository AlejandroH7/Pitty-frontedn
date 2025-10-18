import 'package:flutter/material.dart';
import 'package:pitty_app/routes/app_router.dart';

class HomeMenuPage extends StatelessWidget {
  const HomeMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = _menuItems();
    return Scaffold(
      appBar: AppBar(title: const Text('Menu principal')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.1,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) => items[index],
        ),
      ),
    );
  }

  List<_MenuCard> _menuItems() {
    return const [
      _MenuCard(title: 'Clientes', icon: Icons.people_alt, routeName: AppRoutes.clientes),
      _MenuCard(title: 'Ingredientes', icon: Icons.spa, routeName: AppRoutes.ingredientes),
      _MenuCard(title: 'Postres', icon: Icons.cake, routeName: AppRoutes.postres),
      _MenuCard(title: 'Pedidos', icon: Icons.receipt_long, routeName: AppRoutes.pedidos),
      _MenuCard(title: 'Eventos', icon: Icons.event, routeName: AppRoutes.eventos),
    ];
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({
    required this.title,
    required this.icon,
    required this.routeName,
  });

  final String title;
  final IconData icon;
  final String routeName;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(routeName),
      child: Card(
        color: colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: colorScheme.onPrimaryContainer),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
