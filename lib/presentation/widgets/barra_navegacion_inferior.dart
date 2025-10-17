import 'package:flutter/material.dart';
import '../../core/constants/routes.dart';

/// Widget reutilizable para la barra de navegación inferior
class BarraNavegacionInferior extends StatelessWidget {
  final String rutaActual;

  const BarraNavegacionInferior({
    super.key,
    required this.rutaActual,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = theme.brightness == Brightness.dark 
        ? const Color(0xFF1E1E1E) 
        : Colors.white;
    
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildItemNavegacion(
                context,
                Icons.home,
                'Inicio',
                Rutas.home,
              ),
              _buildItemNavegacion(
                context,
                Icons.add_circle_outline,
                'Registro',
                Rutas.registroPeso,
              ),
              _buildItemNavegacion(
                context,
                Icons.history,
                'Historial',
                Rutas.historial,
              ),
              _buildItemNavegacion(
                context,
                Icons.show_chart,
                'Progreso',
                Rutas.progreso,
              ),
              _buildItemNavegacion(
                context,
                Icons.person_outline,
                'Perfil',
                Rutas.perfil,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemNavegacion(
    BuildContext context,
    IconData icono,
    String etiqueta,
    String ruta,
  ) {
    final bool activo = rutaActual == ruta;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        if (!activo) {
          Navigator.pushReplacementNamed(context, ruta);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icono,
            color: activo ? theme.colorScheme.primary : theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            etiqueta,
            style: TextStyle(
              fontSize: 10,
              color: activo ? theme.colorScheme.primary : theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
              fontWeight: activo ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
