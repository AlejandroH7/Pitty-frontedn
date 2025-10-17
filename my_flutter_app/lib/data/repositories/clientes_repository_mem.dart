import 'dart:async';

import '../models/cliente.dart';
import 'clientes_repository.dart';

class ClientesRepositoryMem implements ClientesRepository {
  ClientesRepositoryMem();

  final List<Cliente> _clientes = [
    const Cliente(
        id: 1,
        nombre: 'María López',
        telefono: '555-1010',
        correo: 'maria@pitty.local'),
    const Cliente(id: 2, nombre: 'Carlos Pérez', telefono: '555-2020'),
    const Cliente(
        id: 3,
        nombre: 'Laura Gómez',
        telefono: '555-3030',
        correo: 'laura@pitty.local'),
  ];
  int _sequence = 4;

  @override
  Future<Cliente> crear({
    required String nombre,
    String? telefono,
    String? correo,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (nombre.toLowerCase().contains('error')) {
      throw Exception('Error simulado al crear cliente');
    }
    final nuevo = Cliente(
      id: _sequence++,
      nombre: nombre.trim(),
      telefono: telefono?.trim().isEmpty ?? true ? null : telefono?.trim(),
      correo: correo?.trim().isEmpty ?? true ? null : correo?.trim(),
    );
    _clientes.add(nuevo);
    return nuevo;
  }

  @override
  Future<void> eliminar(int id) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _clientes.removeWhere((c) => c.id == id);
  }

  @override
  Future<Cliente?> obtenerPorId(int id) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    try {
      return _clientes.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Cliente>> obtenerTodos() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return List<Cliente>.unmodifiable(_clientes);
  }

  @override
  Future<Cliente> actualizar({
    required int id,
    required String nombre,
    String? telefono,
    String? correo,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (nombre.toLowerCase().contains('error')) {
      throw Exception('Error simulado al actualizar cliente');
    }
    final index = _clientes.indexWhere((c) => c.id == id);
    if (index == -1) {
      throw Exception('Cliente no encontrado');
    }
    final actualizado = _clientes[index].copyWith(
      nombre: nombre.trim(),
      telefono: telefono?.trim().isEmpty ?? true ? null : telefono?.trim(),
      correo: correo?.trim().isEmpty ?? true ? null : correo?.trim(),
    );
    _clientes[index] = actualizado;
    return actualizado;
  }
}
