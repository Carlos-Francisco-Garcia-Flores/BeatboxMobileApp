// lib/domain/repositories/progreso_repository.dart
import '../../data/models/progreso_model.dart';

abstract class ProgresoRepository {
  Future<ProgresoModel> obtenerProgreso(String usuarioId);
}
