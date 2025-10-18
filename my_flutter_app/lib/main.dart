import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'data/repositories/interfaces/clientes_repository.dart';
import 'data/repositories/interfaces/ingredientes_repository.dart';
import 'data/repositories/interfaces/postres_repository.dart';
import 'data/repositories/interfaces/recetas_repository.dart';
import 'data/repositories/interfaces/pedidos_repository.dart';
import 'data/repositories/interfaces/eventos_repository.dart';
import 'data/repositories/memory/clientes_repository_mem.dart';
import 'data/repositories/memory/ingredientes_repository_mem.dart';
import 'data/repositories/memory/postres_repository_mem.dart';
import 'data/repositories/memory/recetas_repository_mem.dart';
import 'data/repositories/memory/pedidos_repository_mem.dart';
import 'data/repositories/memory/eventos_repository_mem.dart';
import 'data/repositories/memory/in_memory_data_source.dart';
import 'providers/clientes_provider.dart';
import 'providers/ingredientes_provider.dart';
import 'providers/postres_provider.dart';
import 'providers/pedidos_provider.dart';
import 'providers/eventos_provider.dart';
import 'routes/app_router.dart';

void main() {
  final store = InMemoryDataSource();
  final clientesRepository = ClientesRepositoryMem(store);
  final ingredientesRepository = IngredientesRepositoryMem(store);
  final postresRepository = PostresRepositoryMem(store);
  final recetasRepository = RecetasRepositoryMem(store, ingredientesRepository);
  final pedidosRepository = PedidosRepositoryMem(store);
  final eventosRepository = EventosRepositoryMem(store);

  runApp(
    MultiProvider(
      providers: [
        Provider<ClientesRepository>.value(value: clientesRepository),
        Provider<IngredientesRepository>.value(value: ingredientesRepository),
        Provider<PostresRepository>.value(value: postresRepository),
        Provider<RecetasRepository>.value(value: recetasRepository),
        Provider<PedidosRepository>.value(value: pedidosRepository),
        Provider<EventosRepository>.value(value: eventosRepository),
        ChangeNotifierProvider(
          create: (_) => ClientesProvider(clientesRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => IngredientesProvider(ingredientesRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => PostresProvider(
            postresRepository,
            recetasRepository,
            ingredientesRepository,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => PedidosProvider(
            pedidosRepository,
            clientesRepository,
            postresRepository,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => EventosProvider(
            eventosRepository,
            pedidosRepository,
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
      initialRoute: AppRoutes.welcome,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
