import 'package:flutter/material.dart';
import '../../core/theme/colors_app.dart';

/// Tarjeta que muestra el peso actual, meta y progreso
class TarjetaPesoActual extends StatelessWidget {
  final double pesoActual;
  final double pesoMeta;
  final double pesoInicial;

  const TarjetaPesoActual({
    super.key,
    required this.pesoActual,
    required this.pesoMeta,
    required this.pesoInicial,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final diferencia = pesoActual - pesoMeta;
    final progreso = ((pesoInicial - pesoActual) / (pesoInicial - pesoMeta)).clamp(0.0, 1.0);

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.monitor_weight_outlined,
                    color: ColoresApp.naranja,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Peso Actual',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: ColoresApp.naranja,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '0.2 kg',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                pesoActual.toStringAsFixed(2),
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: ColoresApp.naranja,
                  height: 1,
                ),
              ),
              const SizedBox(width: 4),
              const Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Text(
                  'kg',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: ColoresApp.naranja,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'Meta: $pesoMeta kg',
                style: TextStyle(
                  fontSize: 14,
                  color: theme.textTheme.bodyMedium?.color,
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
                  color: const Color(0xFFFFE5CC),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progreso,
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: ColoresApp.naranja,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          Text(
            '${diferencia.toStringAsFixed(1)} kg para tu objetivo',
            style: TextStyle(
              fontSize: 12,
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }
}
