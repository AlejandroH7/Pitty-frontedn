import 'package:flutter/material.dart';

import '../presentation/categorias/categoria_form_page.dart';
import '../presentation/categorias/categorias_list_page.dart';
import '../presentation/clientes/cliente_detail_page.dart';
import '../presentation/clientes/cliente_form_page.dart';
import '../presentation/clientes/clientes_list_page.dart';
import '../presentation/pedidos/carrito_page.dart';
import '../presentation/pedidos/confirmacion_pedido_page.dart';
import '../presentation/pedidos/postres_para_pedido_page.dart';
import '../presentation/postres/postre_detail_page.dart';
import '../presentation/postres/postre_form_page.dart';
import '../presentation/postres/postres_list_page.dart';
import '../presentation/shared/under_construction_page.dart';
import '../presentation/shell/home_menu_page.dart';
import '../presentation/shell/welcome_page.dart';

class ClienteDetailArgs {
  const ClienteDetailArgs(this.id);
  final int id;
}

class ClienteFormArgs {
  const ClienteFormArgs({this.id});
  final int? id;
}

class PostreDetailArgs {
  const PostreDetailArgs(this.id);
  final int id;
}

class PostreFormArgs {
  const PostreFormArgs({this.id});
  final int? id;
}

class CategoriaFormArgs {
  const CategoriaFormArgs({this.id});
  final int? id;
}

class AppRouter {
  static const welcome = '/';
  static const home = '/home';
  static const clientes = '/clientes';
  static const clienteDetalle = '/clientes/detalle';
  static const clienteForm = '/clientes/form';
  static const postres = '/postres';
  static const postreDetalle = '/postres/detalle';
  static const postreForm = '/postres/form';
  static const categorias = '/categorias';
  static const categoriaForm = '/categorias/form';
  static const pedidosCatalogo = '/pedidos/catalogo';
  static const carrito = '/pedidos/carrito';
  static const confirmarPedido = '/pedidos/confirmar';
  static const inventario = '/inventario';
  static const reportes = '/reportes';
  static const configuracion = '/configuracion';

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case welcome:
        return _materialRoute(const WelcomePage(), settings);
      case home:
        return _materialRoute(const HomeMenuPage(), settings);
      case clientes:
        return _materialRoute(const ClientesListPage(), settings);
      case clienteDetalle:
        final args = settings.arguments as ClienteDetailArgs;
        return _materialRoute(ClienteDetailPage(clienteId: args.id), settings);
      case clienteForm:
        final args = settings.arguments as ClienteFormArgs?;
        return _materialRoute(ClienteFormPage(clienteId: args?.id), settings);
      case postres:
        return _materialRoute(const PostresListPage(), settings);
      case postreDetalle:
        final args = settings.arguments as PostreDetailArgs;
        return _materialRoute(PostreDetailPage(postreId: args.id), settings);
      case postreForm:
        final args = settings.arguments as PostreFormArgs?;
        return _materialRoute(PostreFormPage(postreId: args?.id), settings);
      case categorias:
        return _materialRoute(const CategoriasListPage(), settings);
      case categoriaForm:
        final args = settings.arguments as CategoriaFormArgs?;
        return _materialRoute(
            CategoriaFormPage(categoriaId: args?.id), settings);
      case pedidosCatalogo:
        return _materialRoute(const PostresParaPedidoPage(), settings);
      case carrito:
        return _materialRoute(const CarritoPage(), settings);
      case confirmarPedido:
        return _materialRoute(const ConfirmacionPedidoPage(), settings);
      case inventario:
        return _materialRoute(
          const UnderConstructionPage(title: 'Inventario'),
          settings,
        );
      case reportes:
        return _materialRoute(
          const UnderConstructionPage(title: 'Reportes'),
          settings,
        );
      case configuracion:
        return _materialRoute(
          const UnderConstructionPage(title: 'Configuración'),
          settings,
        );
      default:
        return _materialRoute(
          Scaffold(
            appBar: AppBar(title: const Text('Ruta no encontrada')),
            body: const Center(child: Text('Pantalla no disponible')),
          ),
          settings,
        );
    }
  }

  MaterialPageRoute<dynamic> _materialRoute(
      Widget page, RouteSettings settings) {
    return MaterialPageRoute<dynamic>(
      builder: (_) => page,
      settings: settings,
    );
  }
}
