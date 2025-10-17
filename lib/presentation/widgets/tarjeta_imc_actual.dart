import 'package:flutter/material.dart';
import '../../core/theme/colors_app.dart';

/// Tarjeta que muestra el IMC actual con escala de colores
class TarjetaIMCActual extends StatelessWidget {
  final double imc;
  final String categoria;

  const TarjetaIMCActual({
    super.key,
    required this.imc,
    required this.categoria,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final posicion = ((imc - 18.5) / (30 - 18.5)).clamp(0.0, 1.0);

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
                Icons.show_chart,
                color: ColoresApp.naranja,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'IMC Actual',
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
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                imc.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: ColoresApp.naranja,
                  height: 1,
                ),
              ),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    categoria,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: ColoresApp.exito,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          Column(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF4CAF50),
                      Color(0xFFFDD835),
                      Color(0xFFFF9800),
                      Color(0xFFF44336),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '18.5',
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                  Text(
                    '25',
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                  Text(
                    '30',
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.textTheme.bodyMedium?.color,
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
