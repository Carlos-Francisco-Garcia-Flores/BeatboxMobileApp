import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/usecases/registrar_peso.dart';
import 'package:flutter_application_1/data/models/peso_model.dart';
import 'package:flutter_application_1/domain/entities/peso.dart';

/// ViewModel para gestionar el registro de pesos del usuario.
class PesoViewModel extends ChangeNotifier {
  final RegistrarPeso registrarPesoUseCase;

  PesoModel? ultimoRegistro;
  String? error;
  bool isLoading = false;

  PesoViewModel(this.registrarPesoUseCase);

  /// Registra un nuevo peso y actualiza el estado del usuario.
  Future<void> registrarPeso(
    double peso,
    String perfilId, {
    double? pesoInicial,
    double? pesoObjetivo,
    double? altura,
  }) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      // Llamada al caso de uso
      final nuevoPeso = await registrarPesoUseCase(
        peso,
        perfilId,
        pesoInicial: pesoInicial,
        pesoObjetivo: pesoObjetivo,
        altura: altura,
      );

      // Convertir la entidad de dominio a modelo
      ultimoRegistro = PesoModel(
        id: nuevoPeso.id,
        peso: nuevoPeso.peso,
        fecha: nuevoPeso.fecha,
        imc: nuevoPeso.imc,
        pesoPerdido: nuevoPeso.pesoPerdido,
        proyeccion: nuevoPeso.proyeccion,
        perfilId: nuevoPeso.perfilId,
      );

      debugPrint(
        "✅ Peso guardado: ${ultimoRegistro?.peso} kg, "
        "IMC: ${ultimoRegistro?.imc}, "
        "Proyección: ${ultimoRegistro?.proyeccion}",
      );
    } catch (e) {
      error = e.toString();
      debugPrint("❌ Error al registrar peso: $error");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
