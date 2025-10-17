import 'package:flutter/material.dart';
import '../../core/theme/colors_app.dart';

/// Widget de calendario que muestra los días con registros
class CalendarioRegistros extends StatefulWidget {
  final DateTime mesActual;
  final List<DateTime> diasConRegistros;
  final Function(DateTime)? onDiaSeleccionado;

  const CalendarioRegistros({
    super.key,
    required this.mesActual,
    required this.diasConRegistros,
    this.onDiaSeleccionado,
  });

  @override
  State<CalendarioRegistros> createState() => _CalendarioRegistrosState();
}

class _CalendarioRegistrosState extends State<CalendarioRegistros> {
  late DateTime _mesActual;

  @override
  void initState() {
    super.initState();
    _mesActual = widget.mesActual;
  }

  String _obtenerNombreMes(int month) {
    const meses = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return meses[month - 1];
  }

  bool _tieneRegistro(DateTime dia) {
    return widget.diasConRegistros.any((fecha) =>
        fecha.year == dia.year &&
        fecha.month == dia.month &&
        fecha.day == dia.day);
  }

  void _cambiarMes(int cambio) {
    setState(() {
      _mesActual = DateTime(_mesActual.year, _mesActual.month + cambio, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primerDiaMes = DateTime(_mesActual.year, _mesActual.month, 1);
    final ultimoDiaMes = DateTime(_mesActual.year, _mesActual.month + 1, 0);
    final diasEnMes = ultimoDiaMes.day;
    final primerDiaSemana = primerDiaMes.weekday % 7; // 0 = Domingo

    return Container(
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
      child: Column(
        children: [
          // Header con navegación de mes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () => _cambiarMes(-1),
                color: theme.textTheme.bodyMedium?.color,
              ),
              Text(
                '${_obtenerNombreMes(_mesActual.month)} ${_mesActual.year}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () => _cambiarMes(1),
                color: theme.textTheme.bodyMedium?.color,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Días de la semana
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']
                .map((dia) => SizedBox(
                      width: 32,
                      child: Center(
                        child: Text(
                          dia,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
          // Grid de días
          ...List.generate(6, (semana) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(7, (diaSemana) {
                  final numeroDia = semana * 7 + diaSemana - primerDiaSemana + 1;
                  
                  if (numeroDia < 1 || numeroDia > diasEnMes) {
                    // Días fuera del mes actual
                    final mesAnterior = semana == 0 && numeroDia < 1;
                    final mesSiguiente = numeroDia > diasEnMes;
                    
                    int diaAMostrar;
                    if (mesAnterior) {
                      final ultimoDiaMesAnterior = DateTime(_mesActual.year, _mesActual.month, 0).day;
                      diaAMostrar = ultimoDiaMesAnterior + numeroDia;
                    } else {
                      diaAMostrar = numeroDia - diasEnMes;
                    }
                    
                    return SizedBox(
                      width: 32,
                      height: 32,
                      child: Center(
                        child: Text(
                          '$diaAMostrar',
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.3),
                          ),
                        ),
                      ),
                    );
                  }

                  final diaActual = DateTime(_mesActual.year, _mesActual.month, numeroDia);
                  final tieneRegistro = _tieneRegistro(diaActual);

                  return GestureDetector(
                    onTap: tieneRegistro
                        ? () => widget.onDiaSeleccionado?.call(diaActual)
                        : null,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: tieneRegistro ? ColoresApp.naranja : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '$numeroDia',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: tieneRegistro ? FontWeight.w600 : FontWeight.normal,
                            color: tieneRegistro ? Colors.white : theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          }),
        ],
      ),
    );
  }
}
