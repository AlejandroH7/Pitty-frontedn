// lib/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:my_flutter_app/presentation/widgets/custom_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background, // ignore: deprecated_member_use
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 24),
                  Image.asset(
                    'assets/images/pitty_logo.jpg',
                    width: 160,
                    height: 160,
                    fit: BoxFit.cover,
                    semanticLabel: 'Logo de Pitty Pâtisserie',
                  ),
                  const SizedBox(height: 40),
                  CustomButton(
                    label: 'Inventario',
                    filled: false,
                    trailingIcon: Icons.inventory_2_outlined,
                    onPressed: () {
                      Navigator.pushNamed(context, '/inventario');
                    },
                  ),
                  const SizedBox(height: 28),
                  CustomButton(
                    label: 'Pedidos',
                    filled: false,
                    trailingIcon: Icons.receipt_long_outlined,
                    onPressed: () {
                      Navigator.pushNamed(context, '/pedidos');
                    },
                  ),
                  const SizedBox(height: 28),
                  CustomButton(
                    label: 'Eventos',
                    filled: false,
                    trailingIcon: Icons.event_available_outlined,
                    onPressed: () {
                      Navigator.pushNamed(context, '/eventos');
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
