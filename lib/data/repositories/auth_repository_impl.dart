import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_api_service.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService apiService;

  AuthRepositoryImpl(this.apiService);

  @override
  Future<User> login(String usuario, String password) async {
    final data = await apiService.login(usuario, password);

    if (data['success'] == true && data['usuario'] != null) {
      return UserModel.fromJson(data['usuario']);
    } else {
      throw Exception(data['message'] ?? 'Error de autenticación');
    }
  }

  @override
  Future<void> logout() async {}

  @override
  Future<User> validateSession() async {
    throw UnimplementedError();
  }

  @override
  Future<bool> validateUser(String usuario, String password) async {
    try {
      final data = await apiService.login(usuario, password);
      return data['success'] == true;
    } catch (_) {
      return false;
    }
  }
}
