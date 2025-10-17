import 'package:flutter/material.dart';
import '../../core/theme/colors_app.dart';

/// Tarjeta de indicador para mostrar métricas principales
class TarjetaIndicador extends StatelessWidget {
  final String valor;
  final String etiqueta;
  final IconData icono;
  final bool esDestacada;

  const TarjetaIndicador({
    super.key,
    required this.valor,
    required this.etiqueta,
    required this.icono,
    this.esDestacada = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: esDestacada ? ColoresApp.naranja : theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icono,
            color: esDestacada ? Colors.white : ColoresApp.naranja,
            size: 24,
          ),
          const SizedBox(height: 12),
          Text(
            valor,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: esDestacada ? Colors.white : theme.textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            etiqueta,
            style: TextStyle(
              fontSize: 12,
              color: esDestacada
                  ? Colors.white.withOpacity(0.9)
                  : theme.textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }
}
