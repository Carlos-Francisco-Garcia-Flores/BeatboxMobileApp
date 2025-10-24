import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/domain/entities/perfil.dart';
import 'package:flutter_application_1/domain/repositories/perfil_repository.dart';


class PerfilViewModel extends ChangeNotifier {
  final PerfilRepository repository;

  PerfilViewModel(this.repository);

  Perfil? _perfil;
  bool _isLoading = false;

  Perfil? get perfil => _perfil;
  bool get isLoading => _isLoading;

  Future<void> cargarPerfil(String userId) async {
    _isLoading = true;
    notifyListeners();

    _perfil = await repository.getPerfilByUserId(userId);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> actualizarPerfil(String userId, Perfil perfil) async {
    _isLoading = true;
    notifyListeners();

    await repository.updatePerfil(userId, perfil);

    _isLoading = false;
    notifyListeners();
  }
}
