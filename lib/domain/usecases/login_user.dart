import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository repository;
  LoginUser(this.repository);

  Future<User> call(String usuario, String password) {
    return repository.login(usuario, password);
  }
}
