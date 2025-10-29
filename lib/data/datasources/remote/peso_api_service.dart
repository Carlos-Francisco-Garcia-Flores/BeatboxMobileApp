import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/data/models/peso_model.dart';
import 'dart:math';


class PesoApiService {
  final String baseUrl;
  final String token;

  PesoApiService({required this.baseUrl, required this.token});

  Future<PesoModel?> registrarPeso(
    double peso,
    String perfilId, {
    double? pesoInicial,
    double? pesoObjetivo,
    double? altura,
  }) async {
    final url = Uri.parse('$baseUrl/pesos');

    // === Cálculos similares al frontend de React ===
    double alturaM = (altura ?? 0) / 100;
    double imc = alturaM > 0 ? peso / (alturaM * alturaM) : 0;
    double pesoPerdido =
        (pesoInicial != null) ? ((pesoInicial - peso).abs()) : 0;
    double proyeccion = 0;

    if (pesoInicial != null &&
        pesoObjetivo != null &&
        pesoInicial > 0 &&
        pesoObjetivo > 0) {
      // Modelo de decrecimiento exponencial simple (como en React)
      double constanteK = (peso / pesoInicial > 0)
          ? log(peso / pesoInicial)

          : 0;
      proyeccion = constanteK != 0
          ? log(pesoObjetivo / pesoInicial) / constanteK
          : 0;
      if (proyeccion.isNaN || proyeccion.isInfinite) proyeccion = 0;
    }

    final body = jsonEncode({
      "peso": peso,
      "imc": imc,
      "peso_perdido": pesoPerdido,
      "proyeccion": proyeccion.round(),
      "fecha": DateTime.now().toIso8601String(),
      "perfilUsuario": {"id": perfilId},
    });

    print("📡 POST /pesos");
    print("📦 Body enviado: $body");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: body,
    );

    print("🔎 Response (${response.statusCode}): ${response.body}");

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return PesoModel.fromJson(data);
    } else {
      throw Exception(
          "Error ${response.statusCode}: ${response.body}");
    }
  }
}
