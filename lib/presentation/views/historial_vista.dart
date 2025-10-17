import 'package:flutter/material.dart';
import '../../core/theme/colors_app.dart';
import '../../core/constants/routes.dart';
import '../widgets/header_app.dart';
import '../widgets/barra_navegacion_inferior.dart';
import '../widgets/tarjeta_registro_historico.dart';
import '../widgets/calendario_registros.dart';

/// Vista de historial de registros de peso
class HistorialVista extends StatefulWidget {
  const HistorialVista({super.key});

  @override
  State<HistorialVista> createState() => _HistorialVistaState();
}

class _HistorialVistaState extends State<HistorialVista> {
  bool _mostrarConRegistros = true;
  final TextEditingController _busquedaController = TextEditingController();

  // Datos de ejemplo - en producción vendrían de una base de datos
  final List<Map<String, dynamic>> _registros = [
    {
      'peso': 70.2,
      'fecha': DateTime(2025, 9, 23),
      'variacion': 0.0,
      'diasDesdeUltimo': 1,
    },
    {
      'peso': 72.12,
      'fecha': DateTime(2025, 9, 23),
      'variacion': 1.92,
      'diasDesdeUltimo': 0,
    },
    {
      'peso': 71.3,
      'fecha': DateTime(2025, 9, 23),
      'variacion': -0.82,
      'diasDesdeUltimo': 1,
    },
    {
      'peso': 72.32,
      'fecha': DateTime(2025, 9, 23),
      'variacion': 1.02,
      'diasDesdeUltimo': 0,
    },
  ];

  @override
  void dispose() {
    _busquedaController.dispose();
    super.dispose();
  }

  void _limpiarFiltros() {
    setState(() {
      _busquedaController.clear();
      _mostrarConRegistros = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final diasConRegistros = _registros
        .map((r) => r['fecha'] as DateTime)
        .toSet()
        .toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const HeaderApp(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: ColoresApp.naranja.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.history,
                            color: ColoresApp.naranja,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Historial de Peso',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: theme.textTheme.bodyLarge?.color,
                              ),
                            ),
                            Text(
                              'Tienes ${_registros.length} registros de peso guardados',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.textTheme.bodyMedium?.color,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: ColoresApp.naranja.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.filter_alt_outlined,
                            color: ColoresApp.naranja,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Filtros de Búsqueda',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    Container(
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
                      child: TextField(
                        controller: _busquedaController,
                        style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                        decoration: InputDecoration(
                          hintText: 'Buscar peso, fecha o notas...',
                          hintStyle: TextStyle(
                            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    GestureDetector(
                      onTap: _limpiarFiltros,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.filter_alt_off_outlined,
                            size: 16,
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Limpiar Todos los Filtros',
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.textTheme.bodyMedium?.color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: ColoresApp.naranja.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.calendar_month,
                            color: ColoresApp.naranja,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Calendario de Registros',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    CalendarioRegistros(
                      mesActual: DateTime(2025, 9, 1),
                      diasConRegistros: diasConRegistros,
                      onDiaSeleccionado: (dia) {
                        print('Día seleccionado: $dia');
                      },
                    ),
                    const SizedBox(height: 24),
                    
                    Container(
                      padding: const EdgeInsets.all(4),
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
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _mostrarConRegistros = true;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: _mostrarConRegistros
                                      ? ColoresApp.naranja.withOpacity(0.1)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: _mostrarConRegistros
                                            ? ColoresApp.naranja
                                            : theme.textTheme.bodyMedium?.color?.withOpacity(0.3),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Con registros',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: _mostrarConRegistros
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                        color: _mostrarConRegistros
                                            ? ColoresApp.naranja
                                            : theme.textTheme.bodyMedium?.color,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _mostrarConRegistros = false;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: !_mostrarConRegistros
                                      ? theme.textTheme.bodyMedium?.color?.withOpacity(0.1)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: !_mostrarConRegistros
                                            ? theme.textTheme.bodyMedium?.color
                                            : theme.textTheme.bodyMedium?.color?.withOpacity(0.3),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Sin registros',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: !_mostrarConRegistros
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                        color: !_mostrarConRegistros
                                            ? theme.textTheme.bodyMedium?.color
                                            : theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    if (_mostrarConRegistros)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'Haz clic en una fecha para filtrar los registros',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
                    
                    if (_mostrarConRegistros)
                      ..._registros.map((registro) {
                        return TarjetaRegistroHistorico(
                          peso: registro['peso'],
                          fecha: registro['fecha'],
                          variacion: registro['variacion'],
                          diasDesdeUltimo: registro['diasDesdeUltimo'],
                          onVerDetalles: () {
                            print('Ver detalles de registro: ${registro['peso']}kg');
                          },
                        );
                      }).toList()
                    else
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            children: [
                              Icon(
                                Icons.event_busy,
                                size: 48,
                                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.3),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No hay días sin registros',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: theme.textTheme.bodyMedium?.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BarraNavegacionInferior(
        rutaActual: Rutas.historial,
      ),
    );
  }
}
