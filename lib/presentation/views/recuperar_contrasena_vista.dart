import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/boton_primario.dart';
import '../widgets/campo_texto_personalizado.dart';
import '../../core/constants/routes.dart';
import '../widgets/logo_app.dart';

class RecuperarContrasenaVista extends StatefulWidget {
  const RecuperarContrasenaVista({Key? key}) : super(key: key);

  @override
  State<RecuperarContrasenaVista> createState() =>
      _RecuperarContrasenaVistaState();
}

class _RecuperarContrasenaVistaState extends State<RecuperarContrasenaVista> {
  final _formKey = GlobalKey<FormState>();
  final _correoController = TextEditingController();
  bool _cargando = false;
  String? _mensajeError;

  @override
  void dispose() {
    _correoController.dispose();
    super.dispose();
  }

  // ✅ Nuevo método para enviar correo real
  Future<void> _enviarInstrucciones() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _cargando = true;
      _mensajeError = null;
    });

    final correo = _correoController.text.trim();
    final url = Uri.parse('http://10.0.2.2:3000/auth/forgot/password'); // 🔹 tu endpoint

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'correo_electronico': correo}),
      );

      debugPrint('📡 Status: ${response.statusCode}');
      debugPrint('📦 Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Si el servidor responde correctamente, navegar a "Correo Enviado"
        if (mounted) {
          Navigator.pushNamed(
            context,
            Rutas.correoEnviado,
            arguments: correo,
          );
        }
      } else {
        final data = response.body.isNotEmpty ? jsonDecode(response.body) : {};
        setState(() {
          _mensajeError = data['message'] ??
              'Error ${response.statusCode}: ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      debugPrint('❌ Error al conectar con el servidor: $e');
      setState(() {
        _mensajeError =
            'No se pudo conectar con el servidor. Verifica tu conexión.';
      });
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                  const SizedBox(height: 40),
                  const Center(child: LogoApp(width: 200, height: 80)),
                  const SizedBox(height: 40),

                  Text(
                    'Recuperar Contraseña',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    'Ingresa tu correo para recibir instrucciones',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 40),

                  CampoTextoPersonalizado(
                    etiqueta: 'Correo Electrónico',
                    placeholder: 'Ingresa tu correo registrado',
                    icono: Icons.email_outlined,
                    controlador: _correoController,
                    tipoTeclado: TextInputType.emailAddress,
                    validador: (valor) {
                      if (valor == null || valor.isEmpty) {
                        return 'Por favor ingresa tu correo';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(valor)) {
                        return 'Ingresa un correo válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Recibirás un correo con instrucciones para restablecer tu contraseña. Revisa también tu carpeta de spam.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1976D2),
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 🔹 Botón principal
                  BotonPrimario(
                    texto: 'Enviar Instrucciones',
                    alPresionar: _enviarInstrucciones,
                    cargando: _cargando,
                    icono: Icons.send,
                  ),

                  const SizedBox(height: 16),

                  // 🔹 Mensaje de error
                  if (_mensajeError != null)
                    Text(
                      _mensajeError!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 14,
                      ),
                    ),

                  const SizedBox(height: 16),

                  // 🔹 Botón de regresar
                  OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back,
                      size: 20,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                    label: Text(
                      'Volver al Inicio de Sesión',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(
                        color: theme.dividerColor,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
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
