import 'package:flutter_application_1/data/models/historial_model.dart';
import 'package:flutter_application_1/data/datasources/remote/historial_api_service.dart';
import 'package:flutter_application_1/domain/entities/historial.dart';
import 'package:flutter_application_1/domain/repositories/historial_repository.dart';

class HistorialRepositoryImpl implements HistorialRepository {
  final HistorialApiService apiService;

  HistorialRepositoryImpl(this.apiService);

  @override
  Future<List<Historial>> obtenerHistorial(String perfilId) async {
    final data = await apiService.obtenerHistorial(perfilId);
    return data.map((json) => HistorialModel.fromJson(json)).toList();
  }
}
