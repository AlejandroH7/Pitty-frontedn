import 'package:flutter/material.dart';

import 'package:pitty_app/data/models/models.dart';
import 'package:pitty_app/presentation/clientes/cliente_detail_page.dart';
import 'package:pitty_app/presentation/clientes/cliente_form_page.dart';
import 'package:pitty_app/presentation/clientes/clientes_list_page.dart';
import 'package:pitty_app/presentation/eventos/evento_detail_page.dart';
import 'package:pitty_app/presentation/eventos/evento_form_page.dart';
import 'package:pitty_app/presentation/eventos/eventos_list_page.dart';
import 'package:pitty_app/presentation/ingredientes/ingrediente_detail_page.dart';
import 'package:pitty_app/presentation/ingredientes/ingrediente_form_page.dart';
import 'package:pitty_app/presentation/ingredientes/ingredientes_list_page.dart';
import 'package:pitty_app/presentation/pedidos/pedido_detail_page.dart';
import 'package:pitty_app/presentation/pedidos/pedido_wizard_page.dart';
import 'package:pitty_app/presentation/pedidos/pedidos_list_page.dart';
import 'package:pitty_app/presentation/postres/postre_detail_page.dart';
import 'package:pitty_app/presentation/postres/postre_form_page.dart';
import 'package:pitty_app/presentation/postres/postres_list_page.dart';
import 'package:pitty_app/presentation/shell/home_menu_page.dart';
import 'package:pitty_app/presentation/shell/welcome_page.dart';

class AppRoutes {
  static const welcome = '/';
  static const home = '/home';
  static const clientes = '/clientes';
  static const clienteDetail = '/clientes/detalle';
  static const clienteForm = '/clientes/form';
  static const ingredientes = '/ingredientes';
  static const ingredienteDetail = '/ingredientes/detalle';
  static const ingredienteForm = '/ingredientes/form';
  static const postres = '/postres';
  static const postreDetail = '/postres/detalle';
  static const postreForm = '/postres/form';
  static const pedidos = '/pedidos';
  static const pedidoDetail = '/pedidos/detalle';
  static const pedidoWizard = '/pedidos/nuevo';
  static const eventos = '/eventos';
  static const eventoDetail = '/eventos/detalle';
  static const eventoForm = '/eventos/form';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.welcome:
        return MaterialPageRoute(
          builder: (_) => const WelcomePage(),
          settings: settings,
        );
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const HomeMenuPage(),
          settings: settings,
        );
      case AppRoutes.clientes:
        return MaterialPageRoute(
          builder: (_) => const ClientesListPage(),
          settings: settings,
        );
      case AppRoutes.clienteDetail:
        final args = settings.arguments as ClienteDetailArgs;
        return MaterialPageRoute(
          builder: (_) => ClienteDetailPage(clienteId: args.clienteId),
          settings: settings,
        );
      case AppRoutes.clienteForm:
        final args = settings.arguments as ClienteFormArgs?;
        return MaterialPageRoute(
          builder: (_) => ClienteFormPage(cliente: args?.cliente),
          settings: settings,
        );
      case AppRoutes.ingredientes:
        return MaterialPageRoute(
          builder: (_) => const IngredientesListPage(),
          settings: settings,
        );
      case AppRoutes.ingredienteDetail:
        final args = settings.arguments as IngredienteDetailArgs;
        return MaterialPageRoute(
          builder: (_) => IngredienteDetailPage(ingredienteId: args.ingredienteId),
          settings: settings,
        );
      case AppRoutes.ingredienteForm:
        final args = settings.arguments as IngredienteFormArgs?;
        return MaterialPageRoute(
          builder: (_) => IngredienteFormPage(ingrediente: args?.ingrediente),
          settings: settings,
        );
      case AppRoutes.postres:
        return MaterialPageRoute(
          builder: (_) => const PostresListPage(),
          settings: settings,
        );
      case AppRoutes.postreDetail:
        final args = settings.arguments as PostreDetailArgs;
        return MaterialPageRoute(
          builder: (_) => PostreDetailPage(postreId: args.postreId),
          settings: settings,
        );
      case AppRoutes.postreForm:
        final args = settings.arguments as PostreFormArgs?;
        return MaterialPageRoute(
          builder: (_) => PostreFormPage(postre: args?.postre),
          settings: settings,
        );
      case AppRoutes.pedidos:
        return MaterialPageRoute(
          builder: (_) => const PedidosListPage(),
          settings: settings,
        );
      case AppRoutes.pedidoDetail:
        final args = settings.arguments as PedidoDetailArgs;
        return MaterialPageRoute(
          builder: (_) => PedidoDetailPage(pedidoId: args.pedidoId),
          settings: settings,
        );
      case AppRoutes.pedidoWizard:
        return MaterialPageRoute(
          builder: (_) => const PedidoWizardPage(),
          settings: settings,
        );
      case AppRoutes.eventos:
        return MaterialPageRoute(
          builder: (_) => const EventosListPage(),
          settings: settings,
        );
      case AppRoutes.eventoDetail:
        final args = settings.arguments as EventoDetailArgs;
        return MaterialPageRoute(
          builder: (_) => EventoDetailPage(eventoId: args.eventoId),
          settings: settings,
        );
      case AppRoutes.eventoForm:
        final args = settings.arguments as EventoFormArgs?;
        return MaterialPageRoute(
          builder: (_) => EventoFormPage(evento: args?.evento),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const WelcomePage(),
          settings: settings,
        );
    }
  }
}

class ClienteDetailArgs {
  const ClienteDetailArgs({required this.clienteId});

  final int clienteId;
}

class ClienteFormArgs {
  const ClienteFormArgs({this.cliente});

  final Cliente? cliente;
}

class IngredienteDetailArgs {
  const IngredienteDetailArgs({required this.ingredienteId});

  final int ingredienteId;
}

class IngredienteFormArgs {
  const IngredienteFormArgs({this.ingrediente});

  final Ingrediente? ingrediente;
}

class PostreDetailArgs {
  const PostreDetailArgs({required this.postreId});

  final int postreId;
}

class PostreFormArgs {
  const PostreFormArgs({this.postre});

  final Postre? postre;
}

class PedidoDetailArgs {
  const PedidoDetailArgs({required this.pedidoId});

  final int pedidoId;
}

class EventoDetailArgs {
  const EventoDetailArgs({required this.eventoId});

  final int eventoId;
}

class EventoFormArgs {
  const EventoFormArgs({this.evento});

  final Evento? evento;
}
