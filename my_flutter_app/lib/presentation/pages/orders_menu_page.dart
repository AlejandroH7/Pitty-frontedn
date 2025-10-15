// lib/presentation/pages/orders_menu_page.dart
import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

class OrdersMenuPage extends StatelessWidget {
  const OrdersMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background, // ignore: deprecated_member_use
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 24),
                  Text(
                    'Pedidos',
                    style: theme.textTheme.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: 220,
                    child: CustomButton(
                      label: 'Agregar pedido',
                      filled: false,
                      onPressed: () {
                        Navigator.pushNamed(context, '/pedidos/agregar');
                      },
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: 220,
                    child: CustomButton(
                      label: 'Ver pedidos',
                      filled: false,
                      onPressed: () {
                        Navigator.pushNamed(context, '/pedidos/lista');
                      },
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: 220,
                    child: CustomButton(
                      label: 'Volver',
                      filled: true,
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
      ),
    );
  }
}
