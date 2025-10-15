import 'package:my_flutter_app/data/repositories/user_repository.dart';
import 'package:my_flutter_app/domain/entities/user.dart';

class GetUsers {
  const GetUsers(this._repository);

  final UserRepository _repository;

  Future<List<User>> call() {
    return _repository.getUsers();
  }
}
