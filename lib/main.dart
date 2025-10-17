import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// 🧩 Importaciones de capas
import 'data/datasources/remote/auth_api_service.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/usecases/login_user.dart';
import 'domain/usecases/validate_session.dart';
import 'domain/usecases/logout_user.dart';
import 'presentation/viewmodels/auth_viewmodel.dart';
import 'app.dart'; // Tu widget principal

void main() async {
  // Asegurar inicialización de Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // Configurar orientación solo vertical
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Configurar estilo de barra de estado
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // 🧠 Inicialización del servicio de autenticación
  final authApiService = AuthApiService();
  final authRepository = AuthRepositoryImpl(authApiService);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(
            loginUser: LoginUser(authRepository),
            validateSession: ValidateSession(authRepository),
            logoutUser: LogoutUser(authRepository),
          ),
        ),
      ],
      child: const MyApp(), // ✅ desde app.dart
    ),
  );
}
