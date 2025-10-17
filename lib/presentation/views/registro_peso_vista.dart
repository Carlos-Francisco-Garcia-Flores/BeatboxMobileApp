import 'package:flutter/material.dart';
import '../../core/theme/colors_app.dart';
import '../../core/constants/routes.dart';
import '../widgets/header_app.dart';
import '../widgets/barra_navegacion_inferior.dart';
import '../widgets/boton_primario.dart';

/// Vista para registrar el peso actual del usuario
class RegistroPesoVista extends StatefulWidget {
  const RegistroPesoVista({super.key});

  @override
  State<RegistroPesoVista> createState() => _RegistroPesoVistaState();
}

class _RegistroPesoVistaState extends State<RegistroPesoVista> {
  final _pesoController = TextEditingController(text: '75.5');
  bool _cargando = false;

  Future<void> _guardarPeso() async {
    setState(() {
      _cargando = true;
    });

    // Simular guardado
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _cargando = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Peso registrado exitosamente!'),
          backgroundColor: Colors.black87,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    _pesoController.dispose();
    super.dispose();
  }

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
                    _buildNuevoRegistroCard(),
                    const SizedBox(height: 16),
                    _buildPesoActualSection(theme),
                    const SizedBox(height: 16),
                    BotonPrimario(
                      texto: 'Guardar Peso Actual',
                      icono: Icons.save_outlined,
                      alPresionar: _guardarPeso,
                      cargando: _cargando,
                    ),
                    const SizedBox(height: 24),
                    _buildUltimaActualizacionSection(theme),
                    const SizedBox(height: 24),
                    _buildUltimoPesoSection(theme),
                    const SizedBox(height: 24),
                    _buildDatosActualesSection(theme),
                    const SizedBox(height: 16),
                    _buildTipInformativo(theme),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BarraNavegacionInferior(
        rutaActual: Rutas.registroPeso,
      ),
    );
  }

  Widget _buildNuevoRegistroCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColoresApp.naranja,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.card_giftcard,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nuevo Registro',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Registra tu peso actual',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPesoActualSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.monitor_weight_outlined, color: ColoresApp.naranja, size: 20),
              const SizedBox(width: 8),
              Text(
                'Peso Actual',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Ingresa tu peso actual (kg) *',
            style: TextStyle(
              fontSize: 14,
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _pesoController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: theme.textTheme.bodyLarge?.color,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: theme.brightness == Brightness.dark 
                  ? Colors.white.withOpacity(0.05)
                  : const Color(0xFFF5F5F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUltimaActualizacionSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.access_time, color: ColoresApp.naranja, size: 20),
            const SizedBox(width: 8),
            Text(
              'Última Actualización',
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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '70.32 kg',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1976D2),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '23/09/2025, 01:38',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF666666),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Hace 0 minutos',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.scale_outlined, color: Color(0xFF1976D2), size: 24),
              const SizedBox(width: 8),
              const Icon(Icons.calendar_today_outlined, color: Color(0xFF1976D2), size: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUltimoPesoSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.access_time, color: ColoresApp.naranja, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Último Peso Registrado',
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '70.32 kg',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: ColoresApp.naranja,
                  ),
                ),
                Text(
                  '23/09/2025',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.scale_outlined,
              color: ColoresApp.naranja,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatosActualesSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.person_outline, color: ColoresApp.naranja, size: 20),
            const SizedBox(width: 8),
            Text(
              'Datos Actuales',
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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildDatoItem('78.0 kg', 'Peso Inicial', false, theme),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDatoItem('175 cm', 'Altura', false, theme),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildDatoItem('70 kg', 'Peso Objetivo', true, theme),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDatoItem('28 años', 'Edad', false, theme),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildDatoItem('Masculino', 'Género • IMC 25.5', false, theme),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDatoItem(String valor, String etiqueta, bool esDestacado, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          valor,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: esDestacado ? ColoresApp.naranja : theme.textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          etiqueta,
          style: TextStyle(
            fontSize: 12,
            color: theme.textTheme.bodySmall?.color,
          ),
        ),
      ],
    );
  }

  Widget _buildTipInformativo(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ColoresApp.naranja.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline,
            color: ColoresApp.naranja,
            size: 20,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Tip: Para mejores resultados, pésate siempre a la misma hora del día y en las mismas condiciones.',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF666666),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
