// lib/domain/usecases/get_progreso_usuario.dart
import '../../data/models/progreso_model.dart';
import '../repositories/progreso_repository.dart';

class GetProgresoUsuario {
  final ProgresoRepository repository;

  GetProgresoUsuario(this.repository);

  Future<ProgresoModel> call(String usuarioId) {
    return repository.obtenerProgreso(usuarioId);
  }
}
