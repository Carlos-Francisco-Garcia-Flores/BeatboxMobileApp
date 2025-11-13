import 'dart:convert';
import 'package:http/http.dart' as http;

class HistorialApiService {
  final String baseUrl;
  final String token;

  HistorialApiService({required this.baseUrl, required this.token});

  Future<List<Map<String, dynamic>>> obtenerHistorial(String perfilId) async {
    final url = Uri.parse('$baseUrl/pesos/perfil/$perfilId');
    print("📡 GET $url");

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Error ${response.statusCode}: ${response.body}");
    }
  }
}
