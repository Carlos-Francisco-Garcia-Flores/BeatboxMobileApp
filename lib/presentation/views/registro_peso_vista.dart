import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/colors_app.dart';
import '../../core/constants/routes.dart';
import '../widgets/header_app.dart';
import '../widgets/barra_navegacion_inferior.dart';
import '../widgets/boton_primario.dart';
import '../../presentation/viewmodels/auth_viewmodel.dart';
import '../../data/datasources/remote/perfil_api_service.dart';
import '../../data/repositories/perfil_repository_impl.dart';
import '../../presentation/viewmodels/perfil_viewmodel.dart';

/// Vista para registrar el peso actual del usuario
class RegistroPesoVista extends StatefulWidget {
  const RegistroPesoVista({super.key});

  @override
  State<RegistroPesoVista> createState() => _RegistroPesoVistaState();
}

class _RegistroPesoVistaState extends State<RegistroPesoVista> {
  final _pesoController = TextEditingController(text: '75.5');
  bool _cargando = false;

  late PerfilViewModel _perfilViewModel;
  bool _isLoading = true;
  
  String genero = '';
  double altura = 0.0;
  double pesoInicial = 0.0;
  double pesoObjetivo = 0.0;
  int edad = 0;
  double imc = 0.0;

  @override
  void initState() {
    super.initState();
    _cargarPerfilUsuario();
  }

  Future<void> _cargarPerfilUsuario() async {
    final auth = context.read<AuthViewModel>();
    if (auth.user == null) {
      debugPrint('⚠️ Usuario no logueado');
      if (mounted) {
        setState(() => _isLoading = false);
      }
      return;
    }

    const baseUrl = 'http://10.0.2.2:3000';
    final api = PerfilApiService(baseUrl: baseUrl, token: auth.user!.token!);
    final repo = PerfilRepositoryImpl(api);
    _perfilViewModel = PerfilViewModel(repo);

    await _perfilViewModel.cargarPerfil(auth.user!.id);

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (_perfilViewModel.perfil != null) {
          final perfil = _perfilViewModel.perfil!;
          
          genero = perfil.genero;
          altura = perfil.altura?.toDouble() ?? 0.0;
          pesoInicial = perfil.pesoInicial?.toDouble() ?? 0.0;
          pesoObjetivo = perfil.pesoObjetivo?.toDouble() ?? 0.0;
          imc = perfil.imc?.toDouble() ?? 0.0;
          
          if (perfil.fechaNacimiento != null) {
            final hoy = DateTime.now();
            edad = hoy.year - perfil.fechaNacimiento!.year;

            if (hoy.month < perfil.fechaNacimiento!.month ||
                (hoy.month == perfil.fechaNacimiento!.month &&
                    hoy.day < perfil.fechaNacimiento!.day)) {
              edad--;
            }
          } else {
            edad = 0;
          }
        }
      });
    }
  }

  Future<void> _guardarPeso() async {
    setState(() {
      _cargando = true;
    });

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
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: ColoresApp.naranja,
                      ),
                    )
                  : SingleChildScrollView(
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
                    child: _buildDatoItem(
                      pesoInicial > 0 ? '${pesoInicial.toStringAsFixed(1)} kg' : '-',
                      'Peso Inicial',
                      false,
                      theme,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDatoItem(
                      altura > 0 ? '${altura.toStringAsFixed(0)} cm' : '-',
                      'Altura',
                      false,
                      theme,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildDatoItem(
                      pesoObjetivo > 0 ? '${pesoObjetivo.toStringAsFixed(0)} kg' : '-',
                      'Peso Objetivo',
                      true,
                      theme,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDatoItem(
                      edad > 0 ? '$edad años' : '-',
                      'Edad',
                      false,
                      theme,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark
                      ? Colors.white.withOpacity(0.05)
                      : const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      genero.isNotEmpty 
                          ? genero.substring(0, 1).toUpperCase() + genero.substring(1).toLowerCase()
                          : '-',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (imc > 0) ...[
                      const SizedBox(height: 4),
                      Text(
                        'IMC ${imc.toStringAsFixed(1)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
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