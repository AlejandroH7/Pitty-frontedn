import 'package:my_flutter_app/data/repositories/user_repository.dart';
import 'package:my_flutter_app/domain/use_cases/get_users.dart';

class Injector {
  static bool _initialized = false;
  static late final UserRepository userRepository;
  static late final GetUsers getUsersUseCase;

  static void init() {
    if (_initialized) {
      return;
    }

    userRepository = InMemoryUserRepository();
    getUsersUseCase = GetUsers(userRepository);
    _initialized = true;
  }
}
