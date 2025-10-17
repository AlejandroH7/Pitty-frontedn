import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/categorias_provider.dart';
import '../../providers/clientes_provider.dart';
import '../../providers/postres_provider.dart';
import '../../routes/app_router.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _preloadData();
    }
  }

  Future<void> _preloadData() async {
    await Future.wait([
      context.read<ClientesProvider>().loadClientes(),
      context.read<CategoriasProvider>().load(),
      context.read<PostresProvider>().load(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primaryContainer,
              theme.colorScheme.secondaryContainer,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Pitty Pastelería',
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Gestiona tus clientes, postres y pedidos desde un mismo lugar.',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            FilledButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, AppRouter.home),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                child: Text('Ingresar', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
