import 'package:flutter/material.dart';
import '../../core/theme/colors_app.dart';
import '../../core/constants/routes.dart';
import '../widgets/header_app.dart';
import '../widgets/barra_navegacion_inferior.dart';
import '../widgets/tarjeta_indicador.dart';
import '../widgets/grafico_evolucion.dart';

/// Vista de progreso y estadísticas
class ProgresoVista extends StatefulWidget {
  const ProgresoVista({super.key});

  @override
  State<ProgresoVista> createState() => _ProgresoVistaState();
}

class _ProgresoVistaState extends State<ProgresoVista> {
  int _tabSeleccionada = 0; // 0: Peso, 1: IMC, 2: Estadísticas

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
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
                        const Icon(
                          Icons.bar_chart,
                          color: ColoresApp.naranja,
                          size: 24,
                        ),
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
                    ),
                    const SizedBox(height: 20),

                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.3,
                      children: const [
                        TarjetaIndicador(
                          valor: '7.8 kg',
                          etiqueta: 'Perdido Total',
                          icono: Icons.trending_down,
                          esDestacada: true,
                        ),
                        TarjetaIndicador(
                          valor: '0.0 kg',
                          etiqueta: 'Por Mes',
                          icono: Icons.calendar_today,
                        ),
                        TarjetaIndicador(
                          valor: '97%',
                          etiqueta: 'Completado',
                          icono: Icons.emoji_events,
                        ),
                        TarjetaIndicador(
                          valor: '0',
                          etiqueta: 'Meses Activo',
                          icono: Icons.access_time,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4F4DD),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.bar_chart,
                            color: ColoresApp.exito,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Resumen de Progreso',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF166534),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '¡Excelente! Has perdido 3 kg en 1 mes',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF166534),
                                  ),
                                ),
                                Text(
                                  'vs primer registro',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF16803D),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            '-3 kg',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF166534),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    const GraficoEvolucion(),
                    const SizedBox(height: 16),

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

                    if (_tabSeleccionada == 0) _buildTabPeso(theme),
                    if (_tabSeleccionada == 1) _buildTabIMC(theme),
                    if (_tabSeleccionada == 2) _buildTabEstadisticas(theme),
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

  Widget _buildTabPeso(ThemeData theme) {
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
              _buildFilaMeta('Peso Inicial', '78 kg', theme.textTheme.bodyLarge?.color ?? Colors.black, theme),
              const SizedBox(height: 8),
              _buildFilaMeta('Peso Actual', '70.2 kg', ColoresApp.naranja, theme),
              const SizedBox(height: 8),
              _buildFilaMeta('Peso Meta', '70 kg', theme.textTheme.bodyLarge?.color ?? Colors.black, theme),
              const SizedBox(height: 16),
              Container(
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
              const SizedBox(height: 8),
              Text(
                '0.2 kg restantes para tu objetivo',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.textTheme.bodyMedium?.color,
                ),
                textAlign: TextAlign.center,
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
              _buildFilaRitmo('Por Mes', '0.0 kg/mes', ColoresApp.naranja, theme),
              const SizedBox(height: 8),
              _buildFilaRitmo('Promedio Diario', '0.00 kg/día', Colors.blue, theme),
              const SizedBox(height: 8),
              _buildFilaRitmo('Tiempo Activo', '0 meses', null, theme),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabIMC(ThemeData theme) {
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
            'Gráfico de evolución del IMC\n(Próximamente)',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabEstadisticas(ThemeData theme) {
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
              _buildFilaEstadistica('Total de Registros', '5', theme.textTheme.bodyLarge?.color ?? Colors.black, theme),
              const Divider(height: 24),
              _buildFilaEstadistica('Peso Mínimo', '70.2 kg', ColoresApp.exito, theme),
              const Divider(height: 24),
              _buildFilaEstadistica('Peso Máximo', '73.2 kg', ColoresApp.error, theme),
              const Divider(height: 24),
              _buildFilaEstadistica('Diferencia Total', '3.0 kg', ColoresApp.naranja, theme),
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
