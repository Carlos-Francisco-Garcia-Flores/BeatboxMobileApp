import 'package:flutter_application_1/domain/entities/historial.dart';
import 'package:flutter_application_1/domain/repositories/historial_repository.dart';

class ObtenerHistorial {
  final HistorialRepository repository;

  ObtenerHistorial(this.repository);

  Future<List<Historial>> call(String perfilId) async {
    return await repository.obtenerHistorial(perfilId);
  }
}
