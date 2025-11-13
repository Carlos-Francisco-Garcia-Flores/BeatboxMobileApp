import 'package:flutter/material.dart';
import '../../../data/models/progreso_model.dart';
import '../../../domain/usecases/get_progreso_usuario.dart';

class ProgresoViewModel extends ChangeNotifier {
  final GetProgresoUsuario getProgresoUsuario;
  bool cargando = false;
  ProgresoModel? progreso;

  ProgresoViewModel({required this.getProgresoUsuario});

  Future<void> cargarProgreso(String idPerfil) async {
    cargando = true;
    notifyListeners();

    try {
      progreso = await getProgresoUsuario(idPerfil);
      print('✅ Progreso cargado correctamente');
    } catch (e) {
      print('❌ Error al cargar progreso: $e');
    } finally {
      cargando = false;
      notifyListeners();
    }
  }
}
