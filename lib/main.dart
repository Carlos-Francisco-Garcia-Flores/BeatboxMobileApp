import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// --- 🧩 Importaciones de capas ---
import 'data/datasources/remote/auth_api_service.dart';
import 'data/datasources/remote/perfil_api_service.dart';
import 'data/datasources/remote/peso_api_service.dart';
import 'data/datasources/remote/historial_api_service.dart'; // ✅ Nuevo

import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/perfil_repository_impl.dart';
import 'data/repositories/peso_repository_impl.dart';
import 'data/repositories/historial_repository_impl.dart'; // ✅ Nuevo

import 'domain/usecases/login_user.dart';
import 'domain/usecases/logout_user.dart';
import 'domain/usecases/validate_session.dart';
import 'domain/usecases/registrar_peso.dart';
import 'domain/usecases/obtener_historial.dart'; // ✅ Nuevo

import 'presentation/viewmodels/auth_viewmodel.dart';
import 'presentation/viewmodels/perfil_viewmodel.dart';
import 'presentation/viewmodels/peso_viewmodel.dart';
import 'presentation/viewmodels/historial_viewmodel.dart'; // ✅ Nuevo

import 'app.dart'; // Tu widget principal

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

  // 🧠 Servicio base de autenticación
  final authApiService = AuthApiService();
  final authRepository = AuthRepositoryImpl(authApiService);

  runApp(
    MultiProvider(
      providers: [
        // --- 🔐 AUTH ---
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(
            loginUser: LoginUser(authRepository),
            validateSession: ValidateSession(authRepository),
            logoutUser: LogoutUser(authRepository),
          ),
        ),

        // --- 👤 PERFIL (depende del token del usuario autenticado) ---
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

        // --- ⚖️ PESO (para registrar nuevos pesos) ---
        ChangeNotifierProxyProvider<AuthViewModel, PesoViewModel>(
          create: (_) {
            final pesoApi = PesoApiService(baseUrl: baseUrl, token: '');
            final pesoRepo = PesoRepositoryImpl(pesoApi);
            final usecase = RegistrarPeso(pesoRepo);
            return PesoViewModel(usecase);
          },
          update: (_, auth, __) {
            final token = auth.user?.token ?? '';
            final pesoApi = PesoApiService(baseUrl: baseUrl, token: token);
            final pesoRepo = PesoRepositoryImpl(pesoApi);
            final usecase = RegistrarPeso(pesoRepo);
            return PesoViewModel(usecase);
          },
        ),

        // --- 📊 HISTORIAL (para mostrar todos los registros del usuario) ---
        ChangeNotifierProxyProvider<AuthViewModel, HistorialViewModel>(
          create: (_) {
            final historialApi = HistorialApiService(baseUrl: baseUrl, token: '');
            final historialRepo = HistorialRepositoryImpl(historialApi);
            final usecase = ObtenerHistorial(historialRepo);
            return HistorialViewModel(usecase);
          },
          update: (_, auth, __) {
            final token = auth.user?.token ?? '';
            final historialApi = HistorialApiService(baseUrl: baseUrl, token: token);
            final historialRepo = HistorialRepositoryImpl(historialApi);
            final usecase = ObtenerHistorial(historialRepo);
            return HistorialViewModel(usecase);
          },
        ),
      ],
      child: const MyApp(), // ✅ Tu MaterialApp principal con rutas
    ),
  );
}
