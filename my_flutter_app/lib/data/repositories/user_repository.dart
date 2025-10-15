import 'package:my_flutter_app/domain/entities/user.dart';

abstract class UserRepository {
  Future<List<User>> getUsers();
}

class InMemoryUserRepository implements UserRepository {
  @override
  Future<List<User>> getUsers() {
    return Future.value(<User>[
      const User(
        id: '1',
        name: 'Ana Pérez',
        email: 'ana@example.com',
      ),
      const User(
        id: '2',
        name: 'Bruno Díaz',
        email: 'bruno@example.com',
      ),
      const User(
        id: '3',
        name: 'Carla López',
        email: 'carla@example.com',
      ),
    ]);
  }
}
