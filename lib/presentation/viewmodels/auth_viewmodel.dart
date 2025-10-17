import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/logout_user.dart';
import '../../domain/usecases/validate_session.dart';

class AuthViewModel extends ChangeNotifier {
  final LoginUser loginUser;
  final ValidateSession validateSession;
  final LogoutUser logoutUser;

  AuthViewModel({
    required this.loginUser,
    required this.validateSession,
    required this.logoutUser,
  });

  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;

  Future<void> login(String usuario, String password) async {
  _isLoading = true;
  notifyListeners();
  try {
    _user = await loginUser(usuario, password);
    _error = null;
  } catch (e, stack) {
    debugPrint('❌ Error en login: $e');
    debugPrint(stack.toString());
    _error = e.toString();
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  Future<void> validarSesion() async {
    try {
      _user = await validateSession();
    } catch (_) {
      _user = null;
    }
    notifyListeners();
  }

  Future<void> cerrarSesion() async {
    await logoutUser();
    _user = null;
    notifyListeners();
  }
}
