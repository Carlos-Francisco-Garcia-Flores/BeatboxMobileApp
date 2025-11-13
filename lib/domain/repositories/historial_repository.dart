import 'package:flutter_application_1/domain/entities/historial.dart';

abstract class HistorialRepository {
  Future<List<Historial>> obtenerHistorial(String perfilId);
}
