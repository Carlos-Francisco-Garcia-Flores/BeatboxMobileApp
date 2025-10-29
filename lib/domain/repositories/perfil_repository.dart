import '../entities/perfil.dart';

abstract class PerfilRepository {
  Future<Perfil?> getPerfilByUserId(String userId);
  Future<bool> updatePerfil(String userId, Perfil perfil);
}
