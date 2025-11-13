import '../repositories/peso_repository.dart';
import '../entities/peso.dart';

class ObtenerUltimoPeso {
  final PesoRepository repository;

  ObtenerUltimoPeso(this.repository);

  Future<Peso?> call(String perfilId) async {
    final lista = await repository.obtenerPesosPorPerfil(perfilId);
    if (lista.isEmpty) return null;
    lista.sort((a, b) => b.fecha.compareTo(a.fecha)); // orden descendente
    return lista.first; // el más reciente
  }
}
