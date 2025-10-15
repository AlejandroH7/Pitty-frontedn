// lib/main.dart
import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/di/injector.dart';
import 'package:my_flutter_app/core/utils/constants.dart';
import 'package:my_flutter_app/presentation/pages/home_page.dart';
import 'package:my_flutter_app/presentation/pages/inventory_page.dart';
import 'package:my_flutter_app/presentation/pages/login_page.dart';
import 'package:my_flutter_app/presentation/pages/materia_prima_add_page.dart';
import 'package:my_flutter_app/presentation/pages/materia_prima_detail_page.dart';
import 'package:my_flutter_app/presentation/pages/materia_prima_list_page.dart';
import 'package:my_flutter_app/presentation/pages/materia_prima_page.dart';
import 'presentation/pages/event_add_page.dart';
import 'presentation/pages/event_detail_page.dart';
import 'presentation/pages/event_list_page.dart';
import 'presentation/pages/events_menu_page.dart';
import 'presentation/pages/orders_add_page.dart';
import 'presentation/pages/orders_detail_page.dart';
import 'presentation/pages/orders_list_page.dart';
import 'presentation/pages/orders_menu_page.dart';
import 'package:my_flutter_app/presentation/pages/postre_detail_page.dart';
import 'package:my_flutter_app/presentation/pages/postres_add_page.dart';
import 'package:my_flutter_app/presentation/pages/postres_list_page.dart';
import 'package:my_flutter_app/presentation/pages/postres_page.dart';

void main() {
  Injector.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final lightScheme = ColorScheme.fromSeed(seedColor: seedColor);
    final darkScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
    );

    return MaterialApp(
      title: kAppName,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightScheme,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkScheme,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/inventario': (context) => const InventoryPage(),
        '/pedidos': (context) => const OrdersMenuPage(),
        '/pedidos/agregar': (context) => const OrdersAddPage(),
        '/pedidos/lista': (context) => const OrdersListPage(),
        '/pedidos/detalle': (context) => const OrdersDetailPage(),
        '/eventos': (context) => const EventsMenuPage(),
        '/eventos/agregar': (context) => const EventAddPage(),
        '/eventos/lista': (context) => const EventListPage(),
        '/eventos/detalle': (context) => const EventDetailPage(),
        '/inventario/materia-prima': (context) => const MateriaPrimaPage(),
        '/inventario/postres': (context) => const PostresPage(),
        '/inventario/materia-prima/agregar': (context) =>
            const MateriaPrimaAddPage(),
        '/inventario/materia-prima/lista': (context) =>
            const MateriaPrimaListPage(),
        '/inventario/materia-prima/detalle': (context) =>
            const MateriaPrimaDetailPage(),
        '/inventario/postres/agregar': (context) => const PostresAddPage(),
        '/inventario/postres/lista': (context) => const PostresListPage(),
        '/inventario/postres/detalle': (context) => const PostreDetailPage(),
      },
    );
  }
}
