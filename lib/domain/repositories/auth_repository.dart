import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String usuario, String password);
  Future<void> logout();
  Future<User> validateSession();

  // 👇 Agrega la misma firma que en la implementación
  Future<bool> validateUser(String usuario, String password);
}
