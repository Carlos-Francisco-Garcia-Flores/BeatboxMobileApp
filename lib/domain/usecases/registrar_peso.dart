import 'package:flutter_application_1/domain/entities/peso.dart';
import 'package:flutter_application_1/domain/repositories/peso_repository.dart';

class RegistrarPeso {
  final PesoRepository repository;
  RegistrarPeso(this.repository);

  Future<Peso> call(
    double peso,
    String perfilId, {
    double? pesoInicial,
    double? pesoObjetivo,
    double? altura,
  }) {
    return repository.registrarPeso(
      peso,
      perfilId,
      pesoInicial: pesoInicial,
      pesoObjetivo: pesoObjetivo,
      altura: altura,
    );
  }
}
