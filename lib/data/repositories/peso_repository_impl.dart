import '../../domain/entities/peso.dart';
import '../../domain/repositories/peso_repository.dart';
import '../datasources/remote/peso_api_service.dart';
import '../models/peso_model.dart';

/// Implementación concreta del repositorio de pesos
class PesoRepositoryImpl implements PesoRepository {
  final PesoApiService apiService;
  PesoRepositoryImpl(this.apiService);

  @override
  Future<Peso> registrarPeso(
    double peso,
    String perfilId, {
    double? pesoInicial,
    double? pesoObjetivo,
    double? altura,
  }) async {
    final data = await apiService.registrarPeso(
      peso,
      perfilId,
      pesoInicial: pesoInicial,
      pesoObjetivo: pesoObjetivo,
      altura: altura,
    );
    return data!;
  }

  /// 🔹 Nuevo método obligatorio: obtener todos los pesos de un perfil
  @override
  Future<List<Peso>> obtenerPesosPorPerfil(String perfilId) async {
    try {
      // Llama al servicio API remoto que hace el GET /pesos/perfil/:id
      final response = await apiService.obtenerPesosPorPerfil(perfilId);

      // Convierte la lista de modelos a entidades de dominio
      if (response != null && response.isNotEmpty) {
        return response.cast<Peso>().toList();
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
  }
}
