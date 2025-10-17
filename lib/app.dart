import 'package:flutter/material.dart';
import 'core/theme/theme_app.dart';
import 'core/constants/routes.dart';
import 'core/proveedores/theme_provider.dart';
import 'presentation/views/bienvenida_vista.dart';
import 'presentation/views/inicio_sesion_vista.dart';
import 'presentation/views/recuperar_contrasena_vista.dart';
import 'presentation/views/correo_enviado_vista.dart';
import 'presentation/views/home_vista.dart';
import 'presentation/views/registro_peso_vista.dart';
import 'presentation/views/historial_vista.dart';
import 'presentation/views/progreso_vista.dart';
import 'presentation/views/perfil_vista.dart';

/// Widget principal de la aplicación
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _DogotboxAppState();
}

class _DogotboxAppState extends State<MyApp> {
  final ProveedorTema _proveedorTema = ProveedorTema();

  @override
  void initState() {
    super.initState();
    _proveedorTema.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _proveedorTema.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dogotbox',
      debugShowCheckedModeBanner: false,
      theme: TemaApp.temaClaro,
      darkTheme: TemaApp.temaOscuro,
      themeMode: _proveedorTema.modoTema,
      
      // Ruta inicial
      initialRoute: Rutas.bienvenida,
      
      // Definición de rutas
      routes: {
        Rutas.bienvenida: (context) => const BienvenidaVista(),
        Rutas.inicioSesion: (context) => const InicioSesionVista(),
        Rutas.recuperarContrasena: (context) => const RecuperarContrasenaVista(),
        Rutas.home: (context) => const HomeVista(),
        Rutas.registroPeso: (context) => const RegistroPesoVista(),
        Rutas.historial: (context) => const HistorialVista(),
        Rutas.progreso: (context) => const ProgresoVista(),
        Rutas.perfil: (context) => PerfilVista(proveedorTema: _proveedorTema),
      },
      
      onGenerateRoute: (settings) {
        if (settings.name == Rutas.correoEnviado) {
          final correo = settings.arguments as String? ?? 'usuario@ejemplo.com';
          return MaterialPageRoute(
            builder: (context) => CorreoEnviadoVista(correo: correo),
          );
        }
        return null;
      },
      
      // Manejo de rutas no encontradas
      onUnknownRoute: (settings) {
        debugPrint('[v0] Ruta no encontrada: ${settings.name}');
        return MaterialPageRoute(
          builder: (context) => const BienvenidaVista(),
        );
      },
    );
  }
}
