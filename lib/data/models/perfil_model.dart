import '../../domain/entities/perfil.dart';

class PerfilModel extends Perfil {
  const PerfilModel({
    required super.id,
    required super.nombre,
    required super.apellidos,
    required super.telefono,
    required super.genero,
    super.email,
    super.fechaNacimiento,
    super.pesoInicial,
    super.altura,
    super.imc,
    super.pesoObjetivo,
  });

  factory PerfilModel.fromJson(Map<String, dynamic> json) {
    final usuarioJson = json['usuario'] ?? {};

    // 🔧 Conversión segura a double
    double? _toDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      if (value is String && value.isNotEmpty) {
        return double.tryParse(value);
      }
      return null;
    }

    // 🔧 Conversión segura a DateTime
    DateTime? _parseDate(dynamic value) {
      if (value == null) return null;
      if (value is DateTime) return value;
      if (value is String && value.isNotEmpty) {
        try {
          return DateTime.parse(value);
        } catch (_) {
          return null;
        }
      }
      return null;
    }

    return PerfilModel(
      id: json['id'] ?? '',
      nombre: json['nombre'] ?? '',
      apellidos: json['apellidos'] ?? '',
      telefono: json['telefono'] ?? '',
      genero: json['genero'] ?? '',
      email: usuarioJson['correo_electronico'] ?? '',
      fechaNacimiento: _parseDate(json['fecha_nacimiento']),
      pesoInicial: _toDouble(json['peso_inicial']),
      altura: _toDouble(json['altura']),
      // ✅ Ahora tomamos el IMC directamente del backend
      imc: _toDouble(json['imc']),
      pesoObjetivo: _toDouble(json['peso_objetivo']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'apellidos': apellidos,
      'telefono': telefono,
      'genero': genero,
      'fecha_nacimiento': fechaNacimiento?.toIso8601String(),
      'peso_inicial': pesoInicial,
      'altura': altura,
      // ✅ El IMC también lo enviamos si el backend lo acepta
      'imc': imc,
      'peso_objetivo': pesoObjetivo,
      'usuario': {
        'correo_electronico': email,
      },
    };
  }
}
