import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// --- 🧩 Importaciones de capas ---
import 'data/datasources/remote/auth_api_service.dart';
import 'data/datasources/remote/perfil_api_service.dart';
import 'data/datasources/remote/peso_api_service.dart';
import 'data/datasources/remote/historial_api_service.dart';
import 'data/datasources/remote/progreso_api_service.dart'; // ✅ Nuevo

import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/perfil_repository_impl.dart';
import 'data/repositories/peso_repository_impl.dart';
import 'data/repositories/historial_repository_impl.dart';
import 'data/repositories/progreso_repository_impl.dart'; // ✅ Nuevo

import 'domain/usecases/login_user.dart';
import 'domain/usecases/logout_user.dart';
import 'domain/usecases/validate_session.dart';
import 'domain/usecases/registrar_peso.dart';
import 'domain/usecases/obtener_historial.dart';
import 'domain/usecases/get_progreso_usuario.dart'; // ✅ Nuevo

import 'presentation/viewmodels/auth_viewmodel.dart';
import 'presentation/viewmodels/perfil_viewmodel.dart';
import 'presentation/viewmodels/peso_viewmodel.dart';
import 'presentation/viewmodels/historial_viewmodel.dart';
import 'presentation/viewmodels/progreso_viewmodel.dart'; // ✅ Nuevo

import 'app.dart'; // Widget principal (MaterialApp y rutas)

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  const baseUrl = 'http://10.0.2.2:3000';

  // --- Servicios base (solo auth necesita instancia directa) ---
  final authApiService = AuthApiService();
  final authRepository = AuthRepositoryImpl(authApiService);

  runApp(
    // ✅ MultiProvider rodea completamente el MaterialApp (MyApp)
    MultiProvider(
      providers: [
        // 🔐 AUTH
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(
            loginUser: LoginUser(authRepository),
            validateSession: ValidateSession(authRepository),
            logoutUser: LogoutUser(authRepository),
          ),
        ),

        // 👤 PERFIL
        ChangeNotifierProxyProvider<AuthViewModel, PerfilViewModel>(
          create: (_) {
            final perfilApi = PerfilApiService(baseUrl: baseUrl, token: '');
            final perfilRepo = PerfilRepositoryImpl(perfilApi);
            return PerfilViewModel(perfilRepo);
          },
          update: (_, auth, __) {
            final token = auth.user?.token ?? '';
            final perfilApi = PerfilApiService(baseUrl: baseUrl, token: token);
            final perfilRepo = PerfilRepositoryImpl(perfilApi);
            return PerfilViewModel(perfilRepo);
          },
        ),

        // ⚖️ PESO
        ChangeNotifierProxyProvider<AuthViewModel, PesoViewModel>(
          create: (_) {
            final pesoApi = PesoApiService(baseUrl: baseUrl, token: '');
            final pesoRepo = PesoRepositoryImpl(pesoApi);
            return PesoViewModel(RegistrarPeso(pesoRepo));
          },
          update: (_, auth, __) {
            final token = auth.user?.token ?? '';
            final pesoApi = PesoApiService(baseUrl: baseUrl, token: token);
            final pesoRepo = PesoRepositoryImpl(pesoApi);
            return PesoViewModel(RegistrarPeso(pesoRepo));
          },
        ),

        // 📜 HISTORIAL
        ChangeNotifierProxyProvider<AuthViewModel, HistorialViewModel>(
          create: (_) {
            final historialApi =
                HistorialApiService(baseUrl: baseUrl, token: '');
            final historialRepo = HistorialRepositoryImpl(historialApi);
            return HistorialViewModel(ObtenerHistorial(historialRepo));
          },
          update: (_, auth, __) {
            final token = auth.user?.token ?? '';
            final historialApi =
                HistorialApiService(baseUrl: baseUrl, token: token);
            final historialRepo = HistorialRepositoryImpl(historialApi);
            return HistorialViewModel(ObtenerHistorial(historialRepo));
          },
        ),

        // 📈 PROGRESO
        ChangeNotifierProxyProvider<AuthViewModel, ProgresoViewModel>(
          create: (_) {
            final progresoApi =
                ProgresoApiService(baseUrl: baseUrl, token: '');
            final progresoRepo = ProgresoRepositoryImpl(progresoApi);
            return ProgresoViewModel(
              getProgresoUsuario: GetProgresoUsuario(progresoRepo),
            );
          },
          update: (_, auth, __) {
            final token = auth.user?.token ?? '';
            final progresoApi =
                ProgresoApiService(baseUrl: baseUrl, token: token);
            final progresoRepo = ProgresoRepositoryImpl(progresoApi);
            return ProgresoViewModel(
              getProgresoUsuario: GetProgresoUsuario(progresoRepo),
            );
          },
        ),
      ],
      child: const MyApp(), // ✅ Todo el árbol de rutas está bajo los providers
    ),
  );
}
