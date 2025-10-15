// lib/presentation/pages/inventory_page.dart
import 'package:flutter/material.dart';
import 'package:my_flutter_app/presentation/widgets/custom_button.dart';
import 'package:my_flutter_app/presentation/widgets/section_menu_card.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background, // ignore: deprecated_member_use
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 24),
                  Text(
                    'Inventario',
                    style: theme.textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SectionMenuCard(
                    title: 'Materia Prima',
                    children: <Widget>[
                      _MenuActionTile(
                        label: 'Agregar materia',
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/inventario/materia-prima/agregar',
                          );
                        },
                      ),
                      const Divider(height: 1),
                      _MenuActionTile(
                        label: 'Ver inventario',
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/inventario/materia-prima/lista',
                          );
                        },
                      ),
                    ],
                  ),
                  SectionMenuCard(
                    title: 'Postres',
                    children: <Widget>[
                      _MenuActionTile(
                        label: 'Agregar postre',
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/inventario/postres/agregar',
                          );
                        },
                      ),
                      const Divider(height: 1),
                      _MenuActionTile(
                        label: 'Ver inventario',
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/inventario/postres/lista',
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: 220,
                    child: CustomButton(
                      label: 'Volver al menú',
                      filled: true,
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/home',
                          (route) => false,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuActionTile extends StatelessWidget {
  const _MenuActionTile({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: ListTile(
        onTap: onTap,
        minTileHeight: 48,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: const Icon(Icons.radio_button_unchecked, size: 18),
        title: Text(label),
      ),
    );
  }
}
