import 'dart:convert';
import 'package:http/http.dart' as http;

class RecoveryApiService {
  final String baseUrl = 'http://10.0.2.2:3000/auth'; // Usa tu ruta local o del servidor

  Future<Map<String, dynamic>> enviarCorreoRecuperacion(String correo) async {
    final url = Uri.parse('$baseUrl/forgot/password');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'correo_electronico': correo}),
      );

      print('📡 Status: ${response.statusCode}');
      print('📦 Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'] ?? 'Correo de recuperación enviado exitosamente.',
        };
      } else {
        return {
          'success': false,
          'message': 'Error ${response.statusCode}: ${response.reasonPhrase ?? 'Error desconocido'}',
        };
      }
    } catch (e) {
      print('❌ Error en conexión: $e');
      return {
        'success': false,
        'message': 'Error al conectar con el servidor: $e',
      };
    }
  }
}
