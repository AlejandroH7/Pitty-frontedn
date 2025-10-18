import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:pitty_app/core/theme/app_theme.dart';
import 'package:pitty_app/data/repositories/interfaces/clientes_repository.dart';
import 'package:pitty_app/data/repositories/interfaces/eventos_repository.dart';
import 'package:pitty_app/data/repositories/interfaces/ingredientes_repository.dart';
import 'package:pitty_app/data/repositories/interfaces/postres_repository.dart';
import 'package:pitty_app/data/repositories/interfaces/recetas_repository.dart';
import 'package:pitty_app/data/repositories/memory/clientes_repository_mem.dart';
import 'package:pitty_app/data/repositories/memory/eventos_repository_mem.dart';
import 'package:pitty_app/data/repositories/memory/ingredientes_repository_mem.dart';
import 'package:pitty_app/data/repositories/memory/in_memory_data_source.dart';
import 'package:pitty_app/data/repositories/memory/postres_repository_mem.dart';
import 'package:pitty_app/data/repositories/memory/recetas_repository_mem.dart';
import 'package:pitty_app/data/repositories/pedido_repository.dart';
import 'package:pitty_app/data/repositories/pedido_repository_mem.dart';
import 'package:pitty_app/presentation/shell/welcome_page.dart';
import 'package:pitty_app/providers/clientes_provider.dart';
import 'package:pitty_app/providers/eventos_provider.dart';
import 'package:pitty_app/providers/ingredientes_provider.dart';
import 'package:pitty_app/providers/pedidos_provider.dart';
import 'package:pitty_app/providers/postres_provider.dart';
import 'package:pitty_app/routes/app_router.dart';

void main() {
  final store = InMemoryDataSource();

  runApp(
    MultiProvider(
      providers: [
        Provider<ClientesRepository>(create: (_) => ClientesRepositoryMem(store)),
        Provider<IngredientesRepository>(create: (_) => IngredientesRepositoryMem(store)),
        Provider<PostresRepository>(create: (_) => PostresRepositoryMem(store)),
        Provider<RecetasRepository>(
          create: (context) => RecetasRepositoryMem(
            store,
            context.read<IngredientesRepository>(),
          ),
        ),
        Provider<PedidoRepository>(create: (_) => PedidoRepositoryMem(store)),
        Provider<EventosRepository>(create: (_) => EventosRepositoryMem(store)),
        ChangeNotifierProvider(
          create: (context) => ClientesProvider(context.read<ClientesRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) => IngredientesProvider(context.read<IngredientesRepository>()),
        ),
        ChangeNotifierProvider(
          create: (context) => PostresProvider(
            context.read<PostresRepository>(),
            context.read<RecetasRepository>(),
            context.read<IngredientesRepository>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => PedidosProvider(
            context.read<PedidoRepository>(),
            context.read<ClientesRepository>(),
            context.read<PostresRepository>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => EventosProvider(
            context.read<EventosRepository>(),
            context.read<PedidoRepository>(),
          ),
        ),
      ],
      child: const PittyApp(),
    ),
  );
}

class PittyApp extends StatelessWidget {
  const PittyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pitty',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const WelcomePage(),
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}




