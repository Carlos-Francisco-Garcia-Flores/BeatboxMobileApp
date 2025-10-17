import 'package:flutter/material.dart';
import '../../core/theme/colors_app.dart';

/// Tarjeta que muestra un registro histórico de peso
class TarjetaRegistroHistorico extends StatelessWidget {
  final double peso;
  final DateTime fecha;
  final double variacion;
  final int diasDesdeUltimo;
  final VoidCallback? onVerDetalles;

  const TarjetaRegistroHistorico({
    super.key,
    required this.peso,
    required this.fecha,
    required this.variacion,
    required this.diasDesdeUltimo,
    this.onVerDetalles,
  });

  String _obtenerNombreDia(int weekday) {
    const dias = [
      'lunes',
      'martes',
      'miércoles',
      'jueves',
      'viernes',
      'sábado',
      'domingo'
    ];
    return dias[weekday - 1];
  }

  String _obtenerNombreMes(int month) {
    const meses = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre'
    ];
    return meses[month - 1];
  }

  Color _obtenerColorVariacion() {
    if (variacion > 0) {
      return ColoresApp.error; // Rojo para aumento
    } else if (variacion < 0) {
      return ColoresApp.exito; // Verde para disminución
    }
    return ColoresApp.naranja; // Naranja para sin cambio
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nombreDia = _obtenerNombreDia(fecha.weekday);
    final nombreMes = _obtenerNombreMes(fecha.month);
    final colorVariacion = _obtenerColorVariacion();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icono de balanza
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: ColoresApp.naranja.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.monitor_weight_outlined,
              color: ColoresApp.naranja,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          // Información del peso
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '$peso',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: ColoresApp.naranja,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'kg',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: ColoresApp.naranja,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '$nombreDia, ${fecha.day} de $nombreMes ${fecha.year}',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
          ),
          // Badge de variación y botón
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: colorVariacion,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 12,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$diasDesdeUltimo day${diasDesdeUltimo != 1 ? 's' : ''}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: onVerDetalles,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.visibility_outlined,
                      size: 16,
                      color: ColoresApp.naranja,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Ver detalles',
                      style: TextStyle(
                        fontSize: 12,
                        color: ColoresApp.naranja,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
