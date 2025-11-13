import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/colors_app.dart';
import '../../core/constants/routes.dart';
import '../widgets/header_app.dart';
import '../widgets/barra_navegacion_inferior.dart';
import '../widgets/tarjeta_indicador.dart';
import '../widgets/grafico_evolucion.dart';
import '../viewmodels/progreso_viewmodel.dart';
import '../viewmodels/perfil_viewmodel.dart';

class ProgresoVista extends StatefulWidget {
  const ProgresoVista({super.key});

  @override
  State<ProgresoVista> createState() => _ProgresoVistaState();
}

class _ProgresoVistaState extends State<ProgresoVista> {
  int _tabSeleccionada = 0;

  DateTime? _parseFecha(dynamic fecha) {
    if (fecha == null) return null;
    if (fecha is DateTime) return fecha;
    if (fecha is String) {
      try {
        return DateTime.parse(fecha);
      } catch (e) {
        debugPrint('Error parsing fecha: $e');
        return null;
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _cargarProgreso());
  }

  Future<void> _cargarProgreso() async {
    try {
      final progresoVM = context.read<ProgresoViewModel>();
      final perfilVM = context.read<PerfilViewModel>();
      final idPerfil = perfilVM.perfil?.id ?? '';

      if (idPerfil.isNotEmpty) {
        await progresoVM.cargarProgreso(idPerfil);
      } else {
        debugPrint('⚠️ No se encontró idPerfil');
      }
    } catch (e) {
      debugPrint('❌ Error al cargar progreso: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vm = context.watch<ProgresoViewModel>();
    final perfilVM = context.watch<PerfilViewModel>();

    // === 🔹 Datos combinados ===
    final double pesoInicial = (perfilVM.perfil?.pesoInicial ?? vm.progreso?.pesoInicial ?? 0).toDouble();
    final double pesoObjetivo = (perfilVM.perfil?.pesoObjetivo ?? vm.progreso?.pesoObjetivo ?? pesoInicial).toDouble();
    final double pesoActual = (vm.progreso?.pesoActual ?? 0).toDouble();

    // Cálculos adicionales
    final double perdidoTotal = (pesoInicial - pesoActual);
    final double restante = (pesoActual - pesoObjetivo).abs();

    // Porcentaje de avance
    double _avance() {
      if (pesoInicial == pesoObjetivo) return 1.0;
      double pct;
      if (pesoInicial > pesoObjetivo) {
        pct = (pesoInicial - pesoActual) / (pesoInicial - pesoObjetivo);
      } else {
        pct = (pesoActual - pesoInicial) / (pesoObjetivo - pesoInicial);
      }
      return pct.clamp(0, 1);
    }

    final double avance = _avance();

    final historial = vm.progreso?.historial ?? [];
    final int totalRegistros = historial.length;
    
    // Calcular meses activos y promedios
    int mesesActivos = 0;
    double perdidaPorMes = 0.0;
    double promedioDiario = 0.0;
    
    if (totalRegistros >= 2) {
      final primerRegistro = historial.first;
      final ultimoRegistro = historial.last;
      
      final fechaPrimera = _parseFecha(primerRegistro['fecha']);
      final fechaUltima = _parseFecha(ultimoRegistro['fecha']);
      
      if (fechaPrimera != null && fechaUltima != null) {
        final diferenciaDias = fechaUltima.difference(fechaPrimera).inDays;
        mesesActivos = (diferenciaDias / 30).round();
        
        if (mesesActivos > 0) {
          perdidaPorMes = perdidoTotal / mesesActivos;
        }
        
        if (diferenciaDias > 0) {
          promedioDiario = perdidoTotal / diferenciaDias;
        }
      }
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: vm.cargando
            ? const Center(child: CircularProgressIndicator())
            : (vm.progreso == null || vm.progreso!.historial.isEmpty)
                ? const Center(child: Text('No hay registros de peso'))
                : Column(
                    children: [
                      const HeaderApp(),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildEncabezado(theme),
                              const SizedBox(height: 20),

                              // === Tarjetas dinámicas ===
                              GridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: 2,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 1.3,
                                children: [
                                  TarjetaIndicador(
                                    valor: '${perdidoTotal.toStringAsFixed(1)} kg',
                                    etiqueta: 'Perdido Total',
                                    icono: Icons.trending_down,
                                    esDestacada: true,
                                  ),
                                  TarjetaIndicador(
                                    valor: '${perdidaPorMes.toStringAsFixed(1)} kg',
                                    etiqueta: 'Por Mes',
                                    icono: Icons.calendar_today,
                                  ),
                                  TarjetaIndicador(
                                    valor: '${(avance * 100).toStringAsFixed(0)}%',
                                    etiqueta: 'Completado',
                                    icono: Icons.emoji_events,
                                  ),
                                  TarjetaIndicador(
                                    valor: '$mesesActivos',
                                    etiqueta: 'Meses Activo',
                                    icono: Icons.access_time,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // === Resumen mejorado ===
                              _buildResumen(perdidoTotal, mesesActivos, theme),
                              const SizedBox(height: 20),

                              // === Gráfico de evolución ===
                              GraficoEvolucion(datos: vm.progreso!.historial),
                              const SizedBox(height: 16),

                              // === Tabs ===
                              Row(
                                children: [
                                  _buildTab('Peso', 0, theme),
                                  const SizedBox(width: 8),
                                  _buildTab('IMC', 1, theme),
                                  const SizedBox(width: 8),
                                  _buildTab('Estadísticas', 2, theme),
                                ],
                              ),
                              const SizedBox(height: 16),

                              if (_tabSeleccionada == 0)
                                _buildTabPeso(
                                  theme,
                                  pesoInicial: pesoInicial,
                                  pesoActual: pesoActual,
                                  pesoObjetivo: pesoObjetivo,
                                  restante: restante,
                                  avance: avance,
                                  perdidaPorMes: perdidaPorMes,
                                  promedioDiario: promedioDiario,
                                  mesesActivos: mesesActivos,
                                ),

                              if (_tabSeleccionada == 1)
                                _buildTabIMC(theme, vm),
                              if (_tabSeleccionada == 2)
                                _buildTabEstadisticas(theme, vm),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
      bottomNavigationBar: const BarraNavegacionInferior(
        rutaActual: Rutas.progreso,
      ),
    );
  }

  // Encabezado
  Widget _buildEncabezado(ThemeData theme) {
    return Row(
      children: [
        const Icon(Icons.bar_chart, color: ColoresApp.naranja, size: 24),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Progreso y Análisis',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
              Text(
                'Visualiza tu evolución y estadísticas detalladas',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.textTheme.bodyMedium?.color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResumen(double perdidoTotal, int mesesActivos, ThemeData theme) {
    String textoResumen;
    String textoSecundario;
    
    if (perdidoTotal > 0) {
      if (mesesActivos > 0) {
        textoResumen = '¡Excelente! Has perdido ${perdidoTotal.toStringAsFixed(1)} kg en $mesesActivos ${mesesActivos == 1 ? "mes" : "meses"}';
      } else {
        textoResumen = '¡Excelente! Has perdido ${perdidoTotal.toStringAsFixed(1)} kg';
      }
      textoSecundario = 'vs primer registro';
    } else if (perdidoTotal < 0) {
      textoResumen = 'Has ganado ${perdidoTotal.abs().toStringAsFixed(1)} kg';
      textoSecundario = 'vs primer registro';
    } else {
      textoResumen = 'Sin cambios en tu peso';
      textoSecundario = 'Mantén tu rutina';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFD4F4DD),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            perdidoTotal > 0 ? Icons.trending_down : Icons.bar_chart,
            color: ColoresApp.exito,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Resumen de Progreso',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF166534),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  textoResumen,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF166534),
                  ),
                ),
                Text(
                  textoSecundario,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF16803D),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${perdidoTotal > 0 ? "-" : perdidoTotal < 0 ? "+" : ""}${perdidoTotal.abs().toStringAsFixed(1)} kg',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF166534),
            ),
          ),
        ],
      ),
    );
  }

  // Tabs
  Widget _buildTab(String titulo, int indice, ThemeData theme) {
    final esSeleccionada = _tabSeleccionada == indice;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tabSeleccionada = indice),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: esSeleccionada ? ColoresApp.naranja : theme.cardColor,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            titulo,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: esSeleccionada ? Colors.white : theme.textTheme.bodyLarge?.color,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabPeso(
    ThemeData theme, {
    required double pesoInicial,
    required double pesoActual,
    required double pesoObjetivo,
    required double restante,
    required double avance,
    required double perdidaPorMes,
    required double promedioDiario,
    required int mesesActivos,
  }) {
    String kg(num v) => '${v.toStringAsFixed(1)} kg';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Progreso hacia la Meta',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.bodyMedium?.color,
                ),
              ),
              const SizedBox(height: 16),
              _buildFilaMeta('Peso Inicial', kg(pesoInicial), theme.textTheme.bodyLarge?.color ?? Colors.black, theme),
              const SizedBox(height: 8),
              _buildFilaMeta('Peso Actual', kg(pesoActual), ColoresApp.naranja, theme),
              const SizedBox(height: 8),
              _buildFilaMeta('Peso Meta', kg(pesoObjetivo), theme.textTheme.bodyLarge?.color ?? Colors.black, theme),
              const SizedBox(height: 16),
              Stack(
                children: [
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.grey.shade200,
                    ),
                  ),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: avance,
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF22C55E),
                            Color(0xFFFACC15),
                            Color(0xFFFF8800),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${kg(restante)} restantes para tu objetivo',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.textTheme.bodyMedium?.color,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ritmo de Progreso',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.bodyMedium?.color,
                ),
              ),
              const SizedBox(height: 16),
              _buildFilaRitmo('Por Mes', '${perdidaPorMes.toStringAsFixed(1)} kg/mes', ColoresApp.naranja, theme),
              const SizedBox(height: 8),
              _buildFilaRitmo('Promedio Diario', '${promedioDiario.toStringAsFixed(2)} kg/día', Colors.blue, theme),
              const SizedBox(height: 8),
              _buildFilaRitmo('Tiempo Activo', '$mesesActivos ${mesesActivos == 1 ? "mes" : "meses"}', null, theme),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabIMC(ThemeData theme, ProgresoViewModel vm) {
    final imc = vm.progreso!.imcActual?.toStringAsFixed(1) ?? '0.0';
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
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            'Tu IMC actual es $imc\nGráfico de evolución del IMC\n(Próximamente)',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabEstadisticas(ThemeData theme, ProgresoViewModel vm) {
    final historial = vm.progreso!.historial;
    final pesos = historial.map((e) => e['peso'] as double).toList();
    final pesoMin = pesos.isNotEmpty ? pesos.reduce((a, b) => a < b ? a : b) : 0;
    final pesoMax = pesos.isNotEmpty ? pesos.reduce((a, b) => a > b ? a : b) : 0;
    final diferencia = (pesoMax - pesoMin).abs();

    return Column(
      children: [
        Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Estadísticas Generales',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.bodyMedium?.color,
                ),
              ),
              const SizedBox(height: 16),
              _buildFilaEstadistica('Total de Registros', '${historial.length}', theme.textTheme.bodyLarge?.color ?? Colors.black, theme),
              const Divider(height: 24),
              _buildFilaEstadistica('Peso Mínimo', '${pesoMin.toStringAsFixed(1)} kg', ColoresApp.exito, theme),
              const Divider(height: 24),
              _buildFilaEstadistica('Peso Máximo', '${pesoMax.toStringAsFixed(1)} kg', ColoresApp.error, theme),
              const Divider(height: 24),
              _buildFilaEstadistica('Diferencia Total', '${diferencia.toStringAsFixed(1)} kg', ColoresApp.naranja, theme),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Proyección',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.bodyMedium?.color,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Proyección de peso futuro\n(Próximamente)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilaMeta(String etiqueta, String valor, Color colorValor, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          etiqueta,
          style: TextStyle(
            fontSize: 14,
            color: theme.textTheme.bodyMedium?.color,
          ),
        ),
        Text(
          valor,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colorValor,
          ),
        ),
      ],
    );
  }

  Widget _buildFilaRitmo(String etiqueta, String valor, Color? colorBadge, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          etiqueta,
          style: TextStyle(
            fontSize: 14,
            color: theme.textTheme.bodyMedium?.color,
          ),
        ),
        if (colorBadge != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: colorBadge.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              valor,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: colorBadge,
              ),
            ),
          )
        else
          Text(
            valor,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
      ],
    );
  }

  Widget _buildFilaEstadistica(String etiqueta, String valor, Color colorValor, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          etiqueta,
          style: TextStyle(
            fontSize: 14,
            color: theme.textTheme.bodyMedium?.color,
          ),
        ),
        Text(
          valor,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: colorValor,
          ),
        ),
      ],
    );
  }
}
