import 'package:flutter/material.dart';
import '../../core/theme/colors_app.dart';

/// Tarjeta que muestra el progreso total de pérdida de peso
class TarjetaProgresoTotal extends StatelessWidget {
  final double pesoPerdido;
  final double porcentaje;

  const TarjetaProgresoTotal({
    super.key,
    required this.pesoPerdido,
    required this.porcentaje,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.emoji_events_outlined,
                color: ColoresApp.naranja,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Progreso Total',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Perdido',
                style: TextStyle(
                  fontSize: 14,
                  color: theme.textTheme.bodyMedium?.color,
                ),
              ),
              Text(
                '${pesoPerdido.toStringAsFixed(1)} kg',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColoresApp.exito,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          Stack(
            children: [
              Container(
                height: 12,
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.1)
                      : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              FractionallySizedBox(
                widthFactor: porcentaje / 100,
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        ColoresApp.exito,
                        Color(0xFF8BC34A),
                        ColoresApp.naranja,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${porcentaje.toStringAsFixed(1)}% completado',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.textTheme.bodyMedium?.color,
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.celebration,
                    color: ColoresApp.naranja,
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '¡Sigue así!',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: ColoresApp.naranja,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
