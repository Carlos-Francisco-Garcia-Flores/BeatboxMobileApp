import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/usecases/registrar_peso.dart';
import 'package:flutter_application_1/data/models/peso_model.dart';

/// ViewModel para gestionar los registros de peso del usuario.
class PesoViewModel extends ChangeNotifier {
  final RegistrarPeso registrarPesoUseCase;

  PesoModel? ultimoRegistro;
  List<PesoModel> _pesos = [];
  String? error;
  bool isLoading = false;

  List<PesoModel> get pesos => _pesos;

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

      // Guardar el último registro
      ultimoRegistro = PesoModel(
        id: nuevoPeso.id,
        peso: nuevoPeso.peso,
        fecha: nuevoPeso.fecha,
        imc: nuevoPeso.imc,
        pesoPerdido: nuevoPeso.pesoPerdido,
        proyeccion: nuevoPeso.proyeccion,
        perfilId: nuevoPeso.perfilId,
      );

      // Insertar en la lista local
      _pesos.add(ultimoRegistro!);

      debugPrint(
        "✅ Peso guardado: ${ultimoRegistro?.peso} kg, IMC: ${ultimoRegistro?.imc}, Proyección: ${ultimoRegistro?.proyeccion}",
      );
    } catch (e) {
      error = e.toString();
      debugPrint("❌ Error al registrar peso: $error");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Carga todos los registros de peso del perfil
  Future<void> cargarPesosPorPerfil(String perfilId) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final pesos = await registrarPesoUseCase.repository.obtenerPesosPorPerfil(perfilId);

      _pesos = pesos.map((p) {
        return PesoModel(
          id: p.id,
          peso: p.peso,
          fecha: p.fecha,
          imc: p.imc,
          pesoPerdido: p.pesoPerdido,
          proyeccion: p.proyeccion,
          perfilId: p.perfilId,
        );
      }).toList();

      if (_pesos.isNotEmpty) {
        // ordenamos por fecha descendente
        _pesos.sort((a, b) => a.fecha.compareTo(b.fecha));
        ultimoRegistro = _pesos.last;
      }

      debugPrint("📊 Cargados ${_pesos.length} registros de peso.");
    } catch (e) {
      error = e.toString();
      debugPrint("❌ Error al cargar pesos: $error");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Carga solo el último registro del perfil
  Future<void> cargarUltimoPeso(String perfilId) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final pesos = await registrarPesoUseCase.repository.obtenerPesosPorPerfil(perfilId);

      if (pesos.isNotEmpty) {
        final ultimo = pesos.last;
        ultimoRegistro = PesoModel(
          id: ultimo.id,
          peso: ultimo.peso,
          fecha: ultimo.fecha,
          imc: ultimo.imc,
          pesoPerdido: ultimo.pesoPerdido,
          proyeccion: ultimo.proyeccion,
          perfilId: ultimo.perfilId,
        );
      } else {
        ultimoRegistro = null;
      }
    } catch (e) {
      error = e.toString();
      debugPrint("❌ Error al cargar último peso: $error");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Devuelve cuántos registros totales hay
  int get totalRegistros => _pesos.length;

  /// Devuelve la fecha del último registro formateada
  String get fechaUltimo {
    if (ultimoRegistro?.fecha == null) return '—';
    final fecha = ultimoRegistro!.fecha;
    return '${fecha.day}/${fecha.month}/${fecha.year}';
  }

  /// Devuelve el promedio de pérdida de peso por semana (si aplica)
  String get promedioSemanal {
    if (ultimoRegistro == null || ultimoRegistro!.proyeccion == 0) return '—';
    final kgSemana = ultimoRegistro!.pesoPerdido / ultimoRegistro!.proyeccion;
    return kgSemana.toStringAsFixed(1);
  }
}
