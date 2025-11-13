// lib/data/models/progreso_model.dart
class ProgresoModel {
  final double pesoActual;
  final double pesoInicial;
  final double? pesoObjetivo;
  final double? imcActual;
  final double? progresoPorcentaje;
  final List<Map<String, dynamic>> historial;

  ProgresoModel({
    required this.pesoActual,
    required this.pesoInicial,
    this.pesoObjetivo,
    this.imcActual,
    this.progresoPorcentaje,
    required this.historial,
  });

  factory ProgresoModel.fromJson(Map<String, dynamic> json) {
    return ProgresoModel(
      pesoActual: (json['peso_actual'] ?? 0).toDouble(),
      pesoInicial: (json['peso_inicial'] ?? 0).toDouble(),
      pesoObjetivo: json['peso_objetivo'] != null
          ? (json['peso_objetivo']).toDouble()
          : null,
      imcActual:
          json['imc_actual'] != null ? (json['imc_actual']).toDouble() : null,
      progresoPorcentaje: json['progreso_porcentaje'] != null
          ? (json['progreso_porcentaje']).toDouble()
          : null,
      historial: List<Map<String, dynamic>>.from(json['historial'] ?? []),
    );
  }
}
