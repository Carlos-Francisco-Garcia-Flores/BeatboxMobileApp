import '../../domain/entities/peso.dart';
import '../../domain/repositories/peso_repository.dart';
import '../datasources/remote/peso_api_service.dart';
import '../models/peso_model.dart';

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
}
