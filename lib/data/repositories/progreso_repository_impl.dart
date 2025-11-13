// lib/data/repositories/progreso_repository_impl.dart

import 'package:flutter_application_1/data/datasources/remote/progreso_api_service.dart';
import 'package:flutter_application_1/data/models/progreso_model.dart';

import '../../../domain/repositories/progreso_repository.dart';

class ProgresoRepositoryImpl implements ProgresoRepository {
  final ProgresoApiService apiService;

  ProgresoRepositoryImpl(this.apiService);

  @override
  Future<ProgresoModel> obtenerProgreso(String usuarioId) {
    return apiService.obtenerProgreso(usuarioId);
  }
}
