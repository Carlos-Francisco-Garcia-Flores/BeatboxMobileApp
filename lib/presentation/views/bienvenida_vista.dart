import 'package:flutter/material.dart';
import '../widgets/boton_primario.dart';
import '../widgets/logo_app.dart';
import '../../core/constants/routes.dart';

/// Vista de bienvenida - Primera pantalla de la aplicación
class BienvenidaVista extends StatelessWidget {
  const BienvenidaVista({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              
              const LogoApp(width: 280, height: 120),
              
              const SizedBox(height: 60),
              
              // Título de bienvenida
              Text(
                '¡Bienvenido!',
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontSize: 36,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 40),
              
              // Botón Comenzar
              BotonPrimario(
                texto: 'Comenzar',
                alPresionar: ()async {
                  Navigator.pushNamed(context, Rutas.inicioSesion);
                },
              ),
              
              const SizedBox(height: 24),
              
              // Texto descriptivo
              Text(
                'Transforma tu rutina de fitness con nosotros',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
