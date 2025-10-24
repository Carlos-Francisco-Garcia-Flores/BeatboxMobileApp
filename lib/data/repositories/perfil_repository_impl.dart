
import 'package:flutter_application_1/data/datasources/remote/perfil_api_service.dart';
import 'package:flutter_application_1/data/models/perfil_model.dart';
import 'package:flutter_application_1/domain/entities/perfil.dart';
import 'package:flutter_application_1/domain/repositories/perfil_repository.dart';

class PerfilRepositoryImpl implements PerfilRepository {
  final PerfilApiService apiService;

  PerfilRepositoryImpl(this.apiService);

  @override
  Future<Perfil?> getPerfilByUserId(String userId) async {
    return await apiService.getPerfilByUserId(userId);
  }

  @override
  Future<bool> updatePerfil(String userId, Perfil perfil) async {
    final perfilModel = PerfilModel(
      id: perfil.id,
      nombre: perfil.nombre,
      apellidos: perfil.apellidos,
      telefono: perfil.telefono,
      genero: perfil.genero,
      fechaNacimiento: perfil.fechaNacimiento,
      pesoInicial: perfil.pesoInicial,
      altura: perfil.altura,
      imc: perfil.imc,
      pesoObjetivo: perfil.pesoObjetivo,
    );

    return await apiService.updatePerfil(userId, perfilModel);
  }
}
