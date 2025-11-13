import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/colors_app.dart';

class TarjetaRegistroHistorico extends StatelessWidget {
  final double peso;
  final double imc;
  final double pesoPerdido;
  final double proyeccion;
  final DateTime fecha;

  const TarjetaRegistroHistorico({
    super.key,
    required this.peso,
    required this.imc,
    required this.pesoPerdido,
    required this.proyeccion,
    required this.fecha,
  });

  String _formatearFecha(DateTime fecha) {
    final ahora = DateTime.now();
    final diferencia = ahora.difference(fecha);

    if (diferencia.inDays == 0) {
      return 'Hoy';
    } else if (diferencia.inDays == 1) {
      return 'Ayer';
    } else if (diferencia.inDays < 7) {
      return 'Hace ${diferencia.inDays} días';
    } else {
      final dia = fecha.day.toString().padLeft(2, '0');
      final mes = fecha.month.toString().padLeft(2, '0');
      final anio = fecha.year;
      return '$dia/$mes/$anio';
    }
  }

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

  String _getCategoriaIMC(double imc) {
    if (imc < 18.5) return 'Bajo peso';
    if (imc < 25) return 'Normal';
    if (imc < 30) return 'Sobrepeso';
    return 'Obesidad';
  }

  Color _getColorIMC(double imc) {
    if (imc < 18.5) return Colors.blue;
    if (imc < 25) return Colors.green;
    if (imc < 30) return Colors.orange;
    return Colors.red;
  }

  int _calcularDiasDesdeUltimo() {
    final ahora = DateTime.now();
    return ahora.difference(fecha).inDays;
  }

  Color _obtenerColorVariacion(int dias) {
    if (dias == 0) return ColoresApp.naranja;
    if (dias == 1) return ColoresApp.exito;
    return ColoresApp.error;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nombreDia = _obtenerNombreDia(fecha.weekday);
    final nombreMes = _obtenerNombreMes(fecha.month);
    final diasDesdeUltimo = _calcularDiasDesdeUltimo();
    final colorVariacion = _obtenerColorVariacion(diasDesdeUltimo);

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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${peso.toStringAsFixed(1)}',
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
                    const Icon(
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
                onTap: () {
                  print('Ver detalles de registro: ${peso}kg');
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.visibility_outlined,
                      size: 16,
                      color: ColoresApp.naranja,
                    ),
                    SizedBox(width: 4),
                    Text(
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
