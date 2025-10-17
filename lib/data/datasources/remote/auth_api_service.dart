import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthApiService {
  // ✅ Solo hasta /auth (sin /login al final)
  final String baseUrl = 'http://10.0.2.2:3000/auth';

  Future<Map<String, dynamic>> login(String usuario, String password) async {
    // ✅ Aquí concatenamos solo una vez
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

      // ✅ Aceptar tanto 200 como 201
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body.isNotEmpty) {
          final body = jsonDecode(response.body);

          return {
            'success': true,
            'message': body['message'] ?? 'Inicio de sesión exitoso',
            'usuario': body['usuario'] ??
                {
                  'username': usuario,
                  'correo': usuario,
                  'role': 'cliente',
                },
            'token': body['token'] ?? 'no-token',
          };
        } else {
          return {
            'success': false,
            'message':
                'El servidor no devolvió información. Verifica el backend.',
          };
        }
      } else {
        return {
          'success': false,
          'message':
              'Error ${response.statusCode}: ${response.reasonPhrase ?? 'Error desconocido'}',
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
