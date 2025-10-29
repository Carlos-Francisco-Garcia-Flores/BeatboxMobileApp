import '../../domain/entities/peso.dart';

class PesoModel extends Peso {
  PesoModel({
    required super.id,
    required super.peso,
    required super.fecha,
    required super.imc,
    required super.pesoPerdido,
    required super.proyeccion,
    required super.perfilId,
  });

  factory PesoModel.fromJson(Map<String, dynamic> json) {
    return PesoModel(
      id: json['id'] ?? '',
      peso: (json['peso'] as num?)?.toDouble() ?? 0.0,
      fecha: DateTime.tryParse(json['fecha'] ?? '') ?? DateTime.now(),
      imc: (json['imc'] as num?)?.toDouble() ?? 0.0,
      pesoPerdido: (json['peso_perdido'] as num?)?.toDouble() ?? 0.0,
      proyeccion: (json['proyeccion'] as num?)?.toDouble() ?? 0.0,
      perfilId: json['perfilUsuario']?['id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "peso": peso,
      "fecha": fecha.toIso8601String(),
      "imc": imc,
      "peso_perdido": pesoPerdido,
      "proyeccion": proyeccion,
      "perfilUsuario": {"id": perfilId},
    };
  }
}
