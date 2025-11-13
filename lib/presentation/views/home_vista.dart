import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/viewmodels/auth_viewmodel.dart';
import 'package:flutter_application_1/presentation/viewmodels/perfil_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../core/theme/colors_app.dart';
import '../../core/constants/routes.dart';
import '../widgets/header_app.dart';
import '../widgets/barra_navegacion_inferior.dart';
import '../widgets/tarjeta_nuevo_registro.dart';
import '../widgets/tarjeta_peso_actual.dart';
import '../widgets/tarjeta_imc_actual.dart';
import '../widgets/tarjeta_progreso_total.dart';
import '../widgets/tarjeta_metrica.dart';
import '../viewmodels/peso_viewmodel.dart';

/// Vista principal del dashboard con métricas de peso y progreso
class HomeVista extends StatefulWidget {
  const HomeVista({super.key});

  @override
  State<HomeVista> createState() => _HomeVistaState();
}

class _HomeVistaState extends State<HomeVista> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authVM = Provider.of<AuthViewModel>(context, listen: false);
      final perfilVM = Provider.of<PerfilViewModel>(context, listen: false);
      final pesoVM = Provider.of<PesoViewModel>(context, listen: false);

      final userId = authVM.user?.id;

      if (userId != null) {
        await perfilVM.cargarPerfil(userId);
        final perfilId = perfilVM.perfil?.id;

        if (perfilId != null) {
          debugPrint('📡 Solicitando pesos del perfil $perfilId');
          await pesoVM.cargarUltimoPeso(perfilId);
          await pesoVM.cargarPesosPorPerfil(
            perfilId,
          ); // ✅ importante para las métricas
        } else {
          debugPrint('⚠️ No se encontró perfil para el usuario $userId');
        }
      } else {
        debugPrint('⚠️ No hay usuario logueado, no se puede cargar el perfil.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pesoVM = Provider.of<PesoViewModel>(context);
    final peso = pesoVM.ultimoRegistro;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: pesoVM.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
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

                          // 🔹 Peso actual (desde ultimoRegistro)
                          if (peso != null) ...[
                            TarjetaPesoActual(
                              pesoActual: peso.peso,
                              pesoMeta: peso
                                  .proyeccion, // o meta si la tienes en peso
                              pesoInicial:
                                  peso.pesoPerdido +
                                  peso.peso, // calculo inverso aprox
                            ),
                            const SizedBox(height: 16),

                            // 🔹 IMC actual (desde ultimoRegistro)
                            TarjetaIMCActual(
                              imc: peso.imc,
                              categoria: _categoriaIMC(peso.imc),
                            ),
                            const SizedBox(height: 16),

                            // 🔹 Progreso total (desde ultimoRegistro)
                            TarjetaProgresoTotal(
                              pesoPerdido: peso.pesoPerdido,
                              porcentaje: peso.proyeccion,
                            ),
                          ] else
                            const Center(
                              child: Text(
                                'Aún no tienes registros de peso',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),

                          const SizedBox(height: 16),
                          _buildGridMetricas(pesoVM),
                          const SizedBox(height: 80),
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

  /// Determina la categoría según el valor del IMC
  String _categoriaIMC(double imc) {
    if (imc < 18.5) return 'Bajo peso';
    if (imc < 25) return 'Normal';
    if (imc < 30) return 'Sobrepeso';
    return 'Obesidad';
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
              Text('Quedan 30 días', style: theme.textTheme.bodySmall),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGridMetricas(PesoViewModel pesoVM) {
    final totalRegistros = pesoVM.totalRegistros;
    final ultimo = pesoVM.ultimoRegistro;
    final fechaUltimo = pesoVM.fechaUltimo;
    final proyeccion = ultimo?.proyeccion ?? 0;
    final promedioSemanal = pesoVM.promedioSemanal;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.3,
      children: [
        TarjetaMetrica(
          valor: '$totalRegistros',
          etiqueta: 'Registros Totales',
          icono: Icons.scale,
          colorIcono: ColoresApp.naranja,
        ),
        TarjetaMetrica(
          valor: proyeccion > 0 ? '$proyeccion sem' : '—',
          etiqueta: 'Tiempo Estimado',
          icono: Icons.access_time,
          colorIcono: ColoresApp.naranja,
        ),
        TarjetaMetrica(
          valor: fechaUltimo,
          etiqueta: 'Última Vez',
          icono: Icons.calendar_today,
          colorIcono: ColoresApp.naranja,
        ),
        TarjetaMetrica(
          valor: promedioSemanal,
          etiqueta: 'kg/semana',
          icono: Icons.trending_down,
          colorIcono: ColoresApp.exito,
        ),
      ],
    );
  }
}
