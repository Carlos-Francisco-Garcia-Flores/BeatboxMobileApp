import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthApiService {
  final String baseUrl = 'http://10.0.2.2:3000/auth';

  Future<Map<String, dynamic>> login(String usuario, String password) async {
    final url = Uri.parse('$baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'usuarioOEmail': usuario,
          'password': password,
        }),
      );

      print('📡 Status: ${response.statusCode}');
      print('📦 Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body.isNotEmpty) {
          // ✅ Devuelve directamente la respuesta decodificada del backend
          return jsonDecode(response.body);
        } else {
          return {
            'success': false,
            'message': 'El servidor no devolvió información.',
          };
        }
      } else {
        return {
          'success': false,
          'message': 'Error ${response.statusCode}: ${response.reasonPhrase}',
        };
      }
    } catch (e) {
      print('❌ Error en la conexión: $e');
      return {
        'success': false,
        'message': 'Error al conectar con el servidor: $e',
      };
    }
  }
}
