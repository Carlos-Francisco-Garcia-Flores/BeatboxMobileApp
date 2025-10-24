import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.username,
    required super.correo,
    required super.role,
    super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final usuarioJson = json['usuario'] ?? {};
    return UserModel(
      id: usuarioJson['id'] ?? '',
      username: usuarioJson['username'] ?? '',
      correo: usuarioJson['correo'] ?? '',
      role: usuarioJson['role'] ?? '',
      token: json['token'], // 👈 Se guarda el token del login
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'correo': correo,
        'role': role,
        'token': token,
      };
}
