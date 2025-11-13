import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/entities/historial.dart';
import 'package:flutter_application_1/domain/usecases/obtener_historial.dart';

class HistorialViewModel extends ChangeNotifier {
  final ObtenerHistorial obtenerHistorialUseCase;

  List<Historial> registros = [];
  bool isLoading = false;
  String? error;

  HistorialViewModel(this.obtenerHistorialUseCase);

  Future<void> cargarHistorial(String perfilId) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      registros = await obtenerHistorialUseCase(perfilId);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
