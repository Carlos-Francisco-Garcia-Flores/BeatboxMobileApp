import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class ValidateSession {
  final AuthRepository repository;
  ValidateSession(this.repository);

  Future<User> call() {
    return repository.validateSession(); // ✅ CORREGIDO
  }
}
