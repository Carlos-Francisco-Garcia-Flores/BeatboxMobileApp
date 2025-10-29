import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/perfil_model.dart';

class PerfilApiService {
  final String baseUrl;
  final String token;

  PerfilApiService({required this.baseUrl, required this.token});

  Future<PerfilModel?> getPerfilByUserId(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/perfil-usuarios/usuario/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return PerfilModel.fromJson(json.decode(response.body));
    } else {
      print('Error ${response.statusCode}: ${response.body}');
      return null;
    }
  }

  Future<bool> updatePerfil(String userId, PerfilModel perfil) async {
    final response = await http.put(
      Uri.parse('$baseUrl/perfil-usuarios/usuario/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(perfil.toJson()),
    );

    return response.statusCode == 200;
  }
}
