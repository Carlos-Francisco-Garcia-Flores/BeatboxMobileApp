import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme/colors_app.dart';
import '../../core/constants/routes.dart';
import '../widgets/boton_primario.dart';
import '../widgets/logo_app.dart';

class CorreoEnviadoVista extends StatefulWidget {
  final String correo;
  
  const CorreoEnviadoVista({
    Key? key,
    required this.correo,
  }) : super(key: key);

  @override
  State<CorreoEnviadoVista> createState() => _CorreoEnviadoVistaState();
}

class _CorreoEnviadoVistaState extends State<CorreoEnviadoVista> {
  int _segundosRestantes = 58;
  Timer? _timer;
  bool _puedeReenviar = false;

  @override
  void initState() {
    super.initState();
    _iniciarTemporizador();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _iniciarTemporizador() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_segundosRestantes > 0) {
        setState(() {
          _segundosRestantes--;
        });
      } else {
        setState(() {
          _puedeReenviar = true;
        });
        timer.cancel();
      }
    });
  }

  Future<void> _reenviarCorreo() async {
    setState(() {
      _puedeReenviar = false;
      _segundosRestantes = 58;
    });
    
    // Simular reenvío
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Correo reenviado exitosamente'),
          backgroundColor: ColoresApp.exito,
        ),
      );
      _iniciarTemporizador();
    }
  }

  String _enmascararCorreo(String correo) {
    final partes = correo.split('@');
    if (partes.length != 2) return correo;
    
    final nombre = partes[0];
    final dominio = partes[1];
    
    if (nombre.length <= 2) {
      return '${nombre[0]}***@$dominio';
    }
    
    return '${nombre.substring(0, 2)}***@$dominio';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.fondoPrincipal,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                
                // Logo
               Center(
                    child: const LogoApp(width: 280, height: 120),
                  ),

                  const SizedBox(height: 40),
                
                // Título
                const Text(
                  'Correo Enviado',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: ColoresApp.grisOscuro,
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Icono de éxito
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: ColoresApp.exito.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      size: 50,
                      color: ColoresApp.exito,
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Mensaje principal
                const Text(
                  '¡Revisa tu correo!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: ColoresApp.grisOscuro,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Descripción
                Text(
                  'Hemos enviado las instrucciones para restablecer tu contraseña a:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: ColoresApp.grisOscuro.withOpacity(0.7),
                    height: 1.5,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Correo enmascarado
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: ColoresApp.naranja.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.email,
                          size: 18,
                          color: ColoresApp.naranja,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _enmascararCorreo(widget.correo),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: ColoresApp.naranja,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Mensaje de spam
                Text(
                  'Si no encuentras el correo, revisa tu carpeta de spam.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: ColoresApp.grisOscuro.withOpacity(0.6),
                    height: 1.5,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Temporizador de reenvío
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _puedeReenviar
                      ? InkWell(
                          onTap: _reenviarCorreo,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.refresh,
                                size: 20,
                                color: Color(0xFF1976D2),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Reenviar Correo',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1976D2),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 20,
                              color: Color(0xFF1976D2),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Reenviar en ${_segundosRestantes}s',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1976D2),
                              ),
                            ),
                          ],
                        ),
                ),
                
                const SizedBox(height: 32),
                
                // Botón volver al inicio de sesión
                BotonPrimario(
                  texto: 'Volver al Inicio de Sesión',
                  alPresionar: () async{
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      Rutas.inicioSesion,
                      (route) => false,
                    );
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Botón intentar con otro correo
                OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 20,
                    color: ColoresApp.grisOscuro,
                  ),
                  label: const Text(
                    'Intentar con Otro Correo',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: ColoresApp.grisOscuro,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(
                      color: ColoresApp.textoSecundario,
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
    );
  }
}
