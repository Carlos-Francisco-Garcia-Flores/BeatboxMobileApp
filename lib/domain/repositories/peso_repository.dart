import '../entities/peso.dart';

abstract class PesoRepository {
  Future<Peso> registrarPeso(
    double peso,
    String perfilId, {
    double? pesoInicial,
    double? pesoObjetivo,
    double? altura,
  });
}
