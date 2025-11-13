import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/colors_app.dart';
import '../../core/constants/routes.dart';
import '../widgets/header_app.dart';
import '../widgets/barra_navegacion_inferior.dart';
import '../widgets/boton_primario.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/perfil_viewmodel.dart';
import '../viewmodels/peso_viewmodel.dart';

/// Vista para registrar el peso actual del usuario
/// Combina la lógica de guardado con el diseño mejorado
class RegistroPesoVista extends StatefulWidget {
  const RegistroPesoVista({super.key});

  @override
  State<RegistroPesoVista> createState() => _RegistroPesoVistaState();
}

class _RegistroPesoVistaState extends State<RegistroPesoVista> {
  final _pesoController = TextEditingController();
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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authVM = context.read<AuthViewModel>();
      final perfilVM = context.read<PerfilViewModel>();

      if (authVM.user != null && perfilVM.perfil == null) {
        await perfilVM.cargarPerfil(authVM.user!.id);
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
          if (perfilVM.perfil != null) {
            final perfil = perfilVM.perfil!;
            
            genero = perfil.genero;
            altura = perfil.altura?.toDouble() ?? 0.0;
            pesoInicial = perfil.pesoInicial?.toDouble() ?? 0.0;
            pesoObjetivo = perfil.pesoObjetivo?.toDouble() ?? 0.0;
            imc = perfil.imc?.toDouble() ?? 0.0;
            
            // Calcular edad desde fecha de nacimiento
            if (perfil.fechaNacimiento != null) {
              final hoy = DateTime.now();
              edad = hoy.year - perfil.fechaNacimiento!.year;

              if (hoy.month < perfil.fechaNacimiento!.month ||
                  (hoy.month == perfil.fechaNacimiento!.month &&
                      hoy.day < perfil.fechaNacimiento!.day)) {
                edad--;
              }
            }
          }
        });
      }
    });
  }
  
bool _cargado = false;

@override
void didChangeDependencies() {
  super.didChangeDependencies();

  // Evitar llamadas repetidas
  if (_cargado) return;
  _cargado = true;

  WidgetsBinding.instance.addPostFrameCallback((_) async {
    final authVM = context.read<AuthViewModel>();
    final perfilVM = context.read<PerfilViewModel>();
    final pesoVM = context.read<PesoViewModel>();

    // 1️⃣ Esperar a que el perfil esté disponible
    if (authVM.user != null && perfilVM.perfil == null) {
      await perfilVM.cargarPerfil(authVM.user!.id);
    }

    // 2️⃣ Cuando ya exista el perfil, cargar el último peso
    if (perfilVM.perfil != null) {
      await pesoVM.cargarUltimoPeso(perfilVM.perfil!.id);
      debugPrint("✅ Último peso cargado correctamente (${pesoVM.ultimoRegistro?.peso})");

      // 3️⃣ Refrescar la interfaz solo si está montada
      if (mounted) setState(() {});
    }
  });
}

  Future<void> _guardarPeso() async {
    final pesoVM = context.read<PesoViewModel>();
    final authVM = context.read<AuthViewModel>();
    final perfilVM = context.read<PerfilViewModel>();

    final peso = double.tryParse(_pesoController.text);

    if (peso == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Ingrese un peso válido'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (authVM.user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Debes iniciar sesión primero'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (perfilVM.perfil == null) {
      await perfilVM.cargarPerfil(authVM.user!.id);
      if (perfilVM.perfil == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              '⚠️ No se ha cargado tu perfil aún. Intenta nuevamente.',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    // Obtener los datos del perfil
    final perfil = perfilVM.perfil!;
    final perfilId = perfil.id;
    final pesoInicialPerfil = perfil.pesoInicial ?? 0.0;
    final pesoObjetivoPerfil = perfil.pesoObjetivo ?? 0.0;
    final alturaPerfil = perfil.altura?.toDouble() ?? 0.0;

    debugPrint("📊 Guardando peso con datos:");
    debugPrint(
        "peso=$peso, pesoInicial=$pesoInicialPerfil, pesoObjetivo=$pesoObjetivoPerfil, altura=$alturaPerfil");

    // Llamar al ViewModel para guardar en el backend
    await pesoVM.registrarPeso(
      peso,
      perfilId,
      pesoInicial: pesoInicialPerfil,
      pesoObjetivo: pesoObjetivoPerfil,
      altura: alturaPerfil,
    );

    if (pesoVM.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Peso registrado correctamente'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      _pesoController.clear();
      
      // Actualizar la UI para mostrar el nuevo registro
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ ${pesoVM.error!}'),
          backgroundColor: Colors.red,
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
    final pesoVM = context.watch<PesoViewModel>();
    
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
                          _buildPesoActualSection(theme, pesoVM),
                          const SizedBox(height: 16),
                          BotonPrimario(
                            texto: 'Guardar Peso Actual',
                            icono: Icons.save_outlined,
                            alPresionar: _guardarPeso,
                            cargando: pesoVM.isLoading,
                          ),
                          const SizedBox(height: 24),
                          
                          if (pesoVM.ultimoRegistro != null) ...[
                            _buildUltimaActualizacionSection(theme, pesoVM),
                            const SizedBox(height: 24),
                          ],
                          
                          if (pesoVM.ultimoRegistro != null) ...[
                            _buildUltimoPesoSection(theme, pesoVM),
                            const SizedBox(height: 24),
                          ],
                          
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

  Widget _buildPesoActualSection(ThemeData theme, PesoViewModel pesoVM) {
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
              hintText: 'Ej: 75.5',
              hintStyle: TextStyle(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUltimaActualizacionSection(ThemeData theme, PesoViewModel pesoVM) {
    final ultimoRegistro = pesoVM.ultimoRegistro!;
    final fecha = ultimoRegistro.fecha;
    final fechaFormateada = '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}, ${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}';
    
    // Calcular tiempo transcurrido
    final ahora = DateTime.now();
    final diferencia = ahora.difference(fecha);
    String tiempoTranscurrido;
    
    if (diferencia.inMinutes < 1) {
      tiempoTranscurrido = 'Hace menos de 1 minuto';
    } else if (diferencia.inMinutes < 60) {
      tiempoTranscurrido = 'Hace ${diferencia.inMinutes} minuto${diferencia.inMinutes > 1 ? 's' : ''}';
    } else if (diferencia.inHours < 24) {
      tiempoTranscurrido = 'Hace ${diferencia.inHours} hora${diferencia.inHours > 1 ? 's' : ''}';
    } else {
      tiempoTranscurrido = 'Hace ${diferencia.inDays} día${diferencia.inDays > 1 ? 's' : ''}';
    }
    
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
                    Text(
                      '${ultimoRegistro.peso} kg',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1976D2),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      fechaFormateada,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF666666),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      tiempoTranscurrido,
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

  Widget _buildUltimoPesoSection(ThemeData theme, PesoViewModel pesoVM) {
    final ultimoRegistro = pesoVM.ultimoRegistro!;
    final fecha = ultimoRegistro.fecha;
    final fechaFormateada = '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';
    
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
                Text(
                  '${ultimoRegistro.peso} kg',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: ColoresApp.naranja,
                  ),
                ),
                Text(
                  fechaFormateada,
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'IMC: ${ultimoRegistro.imc.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
                Text(
                  'Peso perdido: ${ultimoRegistro.pesoPerdido.toStringAsFixed(1)} kg',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
                Text(
                  'Proyección: ${ultimoRegistro.proyeccion} meses',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.textTheme.bodyMedium?.color,
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
