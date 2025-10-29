import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// --- 🧩 Importaciones de capas ---
import 'data/datasources/remote/auth_api_service.dart';
import 'data/datasources/remote/perfil_api_service.dart';
import 'data/datasources/remote/peso_api_service.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/perfil_repository_impl.dart';
import 'data/repositories/peso_repository_impl.dart';
import 'domain/usecases/login_user.dart';
import 'domain/usecases/logout_user.dart';
import 'domain/usecases/validate_session.dart';
import 'domain/usecases/registrar_peso.dart';
import 'presentation/viewmodels/auth_viewmodel.dart';
import 'presentation/viewmodels/perfil_viewmodel.dart';
import 'presentation/viewmodels/peso_viewmodel.dart';
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

  // Servicios base
  final authApiService = AuthApiService();
  final authRepository = AuthRepositoryImpl(authApiService);

  runApp(
    MultiProvider(
      providers: [
        // --- 🔐 Auth Provider ---
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(
            loginUser: LoginUser(authRepository),
            validateSession: ValidateSession(authRepository),
            logoutUser: LogoutUser(authRepository),
          ),
        ),

        // --- 👤 Perfil Provider (ligado al usuario autenticado) ---
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

        // --- ⚖️ Peso Provider (también depende del token del usuario) ---
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
      ],
      child: const MyApp(), // ✅ Esto ya incluye MaterialApp y rutas
    ),
  );
}
