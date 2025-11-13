import '../entities/peso.dart';

/// Contrato que define las operaciones disponibles
/// para registrar y consultar pesos de usuario.
abstract class PesoRepository {
  /// Registra un nuevo peso en el backend.
  Future<Peso> registrarPeso(
    double peso,
    String perfilId, {
    double? pesoInicial,
    double? pesoObjetivo,
    double? altura,
  });

  /// Obtiene todos los registros de peso asociados a un perfil.
  /// Devuelve una lista ordenada cronológicamente (más antiguos primero).
  Future<List<Peso>> obtenerPesosPorPerfil(String perfilId);
}
