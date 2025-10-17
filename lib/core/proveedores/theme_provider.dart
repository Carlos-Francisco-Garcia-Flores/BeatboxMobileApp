import 'package:flutter/material.dart';

/// Proveedor de tema para gestionar el modo claro/oscuro
class ProveedorTema extends ChangeNotifier {
  bool _modoOscuro = false;

  bool get modoOscuro => _modoOscuro;

  ThemeMode get modoTema => _modoOscuro ? ThemeMode.dark : ThemeMode.light;

  void cambiarTema(bool esOscuro) {
    _modoOscuro = esOscuro;
    notifyListeners();
  }

  void alternarTema() {
    _modoOscuro = !_modoOscuro;
    notifyListeners();
  }
}
