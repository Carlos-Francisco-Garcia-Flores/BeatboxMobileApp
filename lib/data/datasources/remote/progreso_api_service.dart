import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../data/models/progreso_model.dart';

class ProgresoApiService {
  final String baseUrl;
  final String token;

  ProgresoApiService({required this.baseUrl, required this.token});

  Future<ProgresoModel> obtenerProgreso(String perfilId) async {
    try {
      final url = Uri.parse('$baseUrl/pesos/perfil/$perfilId');
      print('📡 GET $url');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('🔎 Response (${response.statusCode}): ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Error al obtener pesos del perfil');
      }

      final decoded = json.decode(response.body);

      if (decoded == null || decoded is! List) {
        throw Exception('Respuesta inválida del servidor');
      }

      if (decoded.isEmpty) {
        print('⚠️ No hay registros de peso');
        // Retorna un modelo vacío para evitar crash visual
        return ProgresoModel(
          pesoInicial: 0,
          pesoActual: 0,
          pesoObjetivo: 0,
          imcActual: 0,
          progresoPorcentaje: 0,
          historial: const [],
        );
      }

      final List<dynamic> data = decoded;
      print('📊 Cargados ${data.length} registros de peso.');

      // === ORDENAR POR FECHA ===
      data.sort((a, b) {
        final fechaA = DateTime.tryParse(a['fecha'] ?? '') ?? DateTime.now();
        final fechaB = DateTime.tryParse(b['fecha'] ?? '') ?? DateTime.now();
        return fechaA.compareTo(fechaB);
      });

      // === VARIABLES SEGURAS ===
      final double pesoInicial =
          (data.first['peso'] != null) ? (data.first['peso'] as num).toDouble() : 0.0;

      final double pesoActual =
          (data.last['peso'] != null) ? (data.last['peso'] as num).toDouble() : pesoInicial;

      final double pesoObjetivo =
          (data.last['pesoObjetivo'] != null)
              ? (data.last['pesoObjetivo'] as num).toDouble()
              : pesoInicial;

      // ✅ IMC seguro: usa el que viene del backend o calcula si hay altura
      final double imcActual =
          (data.last['imc'] != null) ? (data.last['imc'] as num).toDouble() : 0.0;

      final double totalPerdido = pesoInicial - pesoActual;
      final double totalMeta = pesoInicial - pesoObjetivo;

      final double progresoPorcentaje = (totalMeta != 0)
          ? ((totalPerdido / totalMeta) * 100).clamp(0, 100)
          : 0;

      print('📈 Progreso: Inicial=$pesoInicial | Actual=$pesoActual | '
          'Objetivo=$pesoObjetivo | Porcentaje=$progresoPorcentaje | IMC=$imcActual');

      // ✅ Retornar modelo listo para usar
      return ProgresoModel(
        pesoInicial: pesoInicial,
        pesoActual: pesoActual,
        pesoObjetivo: pesoObjetivo,
        imcActual: imcActual,
        progresoPorcentaje: progresoPorcentaje,
        historial: data
            .map((e) => {
                  'fecha': e['fecha'] ?? '',
                  'peso': (e['peso'] as num?)?.toDouble() ?? 0.0,
                })
            .toList(),
      );
    } catch (e, stack) {
      print('❌ Error real en obtenerProgreso: $e');
      print(stack);
      throw Exception('Error al obtener progreso físico');
    }
  }
}
