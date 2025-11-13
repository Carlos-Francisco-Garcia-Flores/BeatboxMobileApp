import 'package:flutter_application_1/domain/entities/historial.dart';

class HistorialModel extends Historial {
  HistorialModel({
    required super.id,
    required super.peso,
    required super.imc,
    required super.pesoPerdido,
    required super.proyeccion,
    required super.fecha,
  });

  factory HistorialModel.fromJson(Map<String, dynamic> json) {
    return HistorialModel(
      id: json['id'] ?? '',
      peso: (json['peso'] ?? 0).toDouble(),
      imc: (json['imc'] ?? 0).toDouble(),
      pesoPerdido: (json['peso_perdido'] ?? 0).toDouble(),
      proyeccion: (json['proyeccion'] ?? 0).toDouble(),
      fecha: DateTime.tryParse(json['fecha'] ?? '') ?? DateTime.now(),
    );
  }
}
