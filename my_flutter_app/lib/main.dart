import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/config/app_config.dart';
import 'core/http/api_exception.dart';
import 'core/http/auth_service.dart';
import 'core/http/http_client.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/categorias_repository.dart';
import 'data/repositories/categorias_repository_mem.dart';
import 'data/repositories/clientes_repository.dart';
import 'data/repositories/postres_repository.dart';
import 'data/repositories/pedidos_repository.dart';
import 'data/repositories/api/clientes_repository_api.dart';
import 'data/repositories/api/pedidos_repository_api.dart';
import 'data/repositories/api/postres_repository_api.dart';
import 'providers/carrito_provider.dart';
import 'providers/categorias_provider.dart';
import 'providers/clientes_provider.dart';
import 'providers/postres_provider.dart';
import 'routes/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final httpClient = HttpClient(
    baseUrl: AppConfig.apiBaseUrl,
    timeout: Duration(seconds: AppConfig.httpTimeoutSeconds),
  );
  final authService = AuthService(httpClient);

  try {
    await authService.loginIfNeeded();
  } on ApiException catch (e) {
    debugPrint('Autenticación fallida: $e');
    rethrow;
  }

  runApp(PittyApp(
    httpClient: httpClient,
    authService: authService,
  ));
}

class PittyApp extends StatelessWidget {
  const PittyApp({super.key, required this.httpClient, required this.authService});

  final HttpClient httpClient;
  final AuthService authService;

  @override
  Widget build(BuildContext context) {
    final router = AppRouter();
    return MultiProvider(
      providers: [
        Provider<HttpClient>.value(value: httpClient),
        Provider<AuthService>.value(value: authService),
        Provider<ClientesRepository>(
          create: (context) =>
              ClientesRepositoryApi(context.read<HttpClient>()),
        ),
        Provider<CategoriasRepository>(
          create: (_) => CategoriasRepositoryMem(),
        ),
        Provider<PostresRepository>(
          create: (context) =>
              PostresRepositoryApi(context.read<HttpClient>()),
        ),
        Provider<PedidosRepository>(
          create: (context) =>
              PedidosRepositoryApi(context.read<HttpClient>()),
        ),
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