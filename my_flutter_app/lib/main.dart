import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'data/repositories/categorias_repository.dart';
import 'data/repositories/categorias_repository_mem.dart';
import 'data/repositories/clientes_repository.dart';
import 'data/repositories/clientes_repository_mem.dart';
import 'data/repositories/pedidos_repository.dart';
import 'data/repositories/pedidos_repository_mem.dart';
import 'data/repositories/postres_repository.dart';
import 'data/repositories/postres_repository_mem.dart';
import 'providers/carrito_provider.dart';
import 'providers/categorias_provider.dart';
import 'providers/clientes_provider.dart';
import 'providers/postres_provider.dart';
import 'routes/app_router.dart';

void main() {
  runApp(const PittyApp());
}

class PittyApp extends StatelessWidget {
  const PittyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter();
    return MultiProvider(
      providers: [
        Provider<ClientesRepository>(create: (_) => ClientesRepositoryMem()),
        Provider<CategoriasRepository>(
            create: (_) => CategoriasRepositoryMem()),
        Provider<PostresRepository>(create: (_) => PostresRepositoryMem()),
        Provider<PedidosRepository>(create: (_) => PedidosRepositoryMem()),
        ChangeNotifierProvider(
          create: (context) =>
              ClientesProvider(context.read<ClientesRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              CategoriasProvider(context.read<CategoriasRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              PostresProvider(context.read<PostresRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              CarritoProvider(context.read<PedidosRepository>()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pitty Pastelería',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: AppRouter.welcome,
        onGenerateRoute: router.onGenerateRoute,
      ),
    );
  }
}
