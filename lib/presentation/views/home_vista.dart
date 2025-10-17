import 'package:flutter/material.dart';
import '../../core/theme/colors_app.dart';
import '../../core/constants/routes.dart';
import '../widgets/header_app.dart';
import '../widgets/barra_navegacion_inferior.dart';
import '../widgets/tarjeta_nuevo_registro.dart';
import '../widgets/tarjeta_peso_actual.dart';
import '../widgets/tarjeta_imc_actual.dart';
import '../widgets/tarjeta_progreso_total.dart';
import '../widgets/tarjeta_metrica.dart';

/// Vista principal del dashboard con métricas de peso y progreso
class HomeVista extends StatelessWidget {
  const HomeVista({super.key});

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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const TarjetaNuevoRegistro(),
                    const SizedBox(height: 16),
                    _buildIndicadorTiempo(theme),
                    const SizedBox(height: 16),
                    
                    // Tarjeta de peso actual
                    const TarjetaPesoActual(
                      pesoActual: 70.32,
                      pesoMeta: 70,
                      pesoInicial: 78.62,
                    ),
                    const SizedBox(height: 16),
                    
                    // Tarjeta de IMC actual
                    const TarjetaIMCActual(
                      imc: 23.0,
                      categoria: 'Normal',
                    ),
                    const SizedBox(height: 16),
                    
                    // Tarjeta de progreso total
                    const TarjetaProgresoTotal(
                      pesoPerdido: 7.7,
                      porcentaje: 95.0,
                    ),
                    const SizedBox(height: 16),
                    
                    // Grid de métricas adicionales
                    _buildGridMetricas(),
                    const SizedBox(height: 80), // Espacio para la barra de navegación
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BarraNavegacionInferior(
        rutaActual: Rutas.home,
      ),
    );
  }

  Widget _buildIndicadorTiempo(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.access_time,
              color: theme.colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tiempo de Actualización',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Quedan 30 días',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGridMetricas() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.3,
      children: const [
        TarjetaMetrica(
          valor: '7',
          etiqueta: 'Registros Totales',
          icono: Icons.scale,
          colorIcono: ColoresApp.naranja,
        ),
        TarjetaMetrica(
          valor: '2 sem',
          etiqueta: 'Tiempo Estimado',
          icono: Icons.access_time,
          colorIcono: ColoresApp.naranja,
        ),
        TarjetaMetrica(
          valor: 'Hoy',
          etiqueta: 'Última Vez',
          icono: Icons.calendar_today,
          colorIcono: ColoresApp.naranja,
        ),
        TarjetaMetrica(
          valor: '53.8',
          etiqueta: 'kg/semana',
          icono: Icons.trending_down,
          colorIcono: ColoresApp.exito,
        ),
      ],
    );
  }
}
