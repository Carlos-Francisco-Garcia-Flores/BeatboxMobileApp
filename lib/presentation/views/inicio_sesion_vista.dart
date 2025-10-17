import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/routes.dart';
import '../widgets/boton_primario.dart';
import '../widgets/campo_texto_personalizado.dart';
import '../widgets/logo_app.dart';
import '../viewmodels/auth_viewmodel.dart'; // ✅ Importa el ViewModel
import 'package:url_launcher/url_launcher.dart';

class InicioSesionVista extends StatefulWidget {
  const InicioSesionVista({Key? key}) : super(key: key);

  @override
  State<InicioSesionVista> createState() => _InicioSesionVistaState();
}

class _InicioSesionVistaState extends State<InicioSesionVista> {
  final _formKey = GlobalKey<FormState>();
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();

  @override
  void dispose() {
    _correoController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  Future<void> _iniciarSesion() async {
    if (!_formKey.currentState!.validate()) return;

    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    await authVM.login(_correoController.text.trim(), _contrasenaController.text.trim());

    if (authVM.isLoggedIn) {
      // ✅ Si el login fue exitoso, redirige al Home
      if (mounted) Navigator.pushReplacementNamed(context, Rutas.home);
    } else {
      // ⚠️ Muestra el mensaje de error desde el ViewModel
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authVM.error ?? 'Error al iniciar sesión')),
      );
    }
  }

Future<void> _abrirRegistroWeb() async {
  const url = 'https://khaki-termite-457506.hostingersite.com/registro';
  
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication, // Abre en navegador externo
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No se pudo abrir el enlace de registro')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authVM = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),
                  const Center(child: LogoApp(width: 200, height: 80)),
                  const SizedBox(height: 40),

                  Text(
                    '¡Bienvenido!',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Campo de correo electrónico
                  CampoTextoPersonalizado(
                    etiqueta: 'Correo Electrónico',
                    placeholder: 'Ingresa tu correo',
                    icono: Icons.email_outlined,
                    controlador: _correoController,
                    tipoTeclado: TextInputType.emailAddress,
                    validador: (valor) {
                      if (valor == null || valor.isEmpty) {
                        return 'Por favor ingresa tu correo';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(valor)) {
                        return 'Ingresa un correo válido';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // Campo de contraseña
                  CampoTextoPersonalizado(
                    etiqueta: 'Contraseña',
                    placeholder: '••••••••',
                    icono: Icons.lock_outline,
                    esContrasena: true,
                    controlador: _contrasenaController,
                    validador: (valor) {
                      if (valor == null || valor.isEmpty) {
                        return 'Por favor ingresa tu contraseña';
                      }
                      if (valor.length < 6) {
                        return 'La contraseña debe tener al menos 6 caracteres';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pushNamed(context, Rutas.recuperarContrasena),
                      child: Text(
                        '¿Olvidaste tu contraseña?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Botón de iniciar sesión
                  BotonPrimario(
                    texto: 'Iniciar Sesión',
                    alPresionar: authVM.isLoading ? null : _iniciarSesion,
                    cargando: authVM.isLoading,
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('¿No tienes cuenta? ', style: theme.textTheme.bodyMedium),
                      TextButton(
                        onPressed: _abrirRegistroWeb,
                        child: Text(
                          'Regístrate',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
