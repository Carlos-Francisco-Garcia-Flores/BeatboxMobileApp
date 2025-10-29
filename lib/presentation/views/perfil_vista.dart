import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/colors_app.dart';
import '../../core/constants/routes.dart';
import '../../core/proveedores/theme_provider.dart';
import '../widgets/header_app.dart';
import '../widgets/barra_navegacion_inferior.dart';
import '../widgets/opcion_configuracion.dart';
import '../../presentation/viewmodels/auth_viewmodel.dart';
import '../../data/datasources/remote/perfil_api_service.dart';
import '../../data/repositories/perfil_repository_impl.dart';
import '../../presentation/viewmodels/perfil_viewmodel.dart';

/// Vista de perfil de usuario con datos del backend
class PerfilVista extends StatefulWidget {
  final ProveedorTema proveedorTema;
  
  const PerfilVista({
    super.key,
    required this.proveedorTema,
  });

  @override
  State<PerfilVista> createState() => _PerfilVistaState();
}

class _PerfilVistaState extends State<PerfilVista> {
  // Estado de notificaciones
  bool _recordatoriosSemanales = true;
  bool _mensajesMotivacionales = false;
  
  // Estado de carga y datos del backend
  late PerfilViewModel _perfilViewModel;
  bool _isLoading = true;
  
  // Datos del perfil
  String nombre = '';
  String email = '';
  String telefono = '';
  String genero = '';
  double altura = 0.0;
  double pesoInicial = 0.0;
  double pesoObjetivo = 0.0;
  int edad = 0;
  // <CHANGE> Usar IMC del backend en lugar de calcularlo
  double imc = 0.0;
  String categoriaIMC = '';
  int registrosTotales = 0;
  double metaKg = 0.0;

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

    const baseUrl = 'http://10.0.2.2:3000'; // 🔧 Ajusta la URL de tu backend
    final api = PerfilApiService(baseUrl: baseUrl, token: auth.user!.token!);
    final repo = PerfilRepositoryImpl(api);
    _perfilViewModel = PerfilViewModel(repo);

    await _perfilViewModel.cargarPerfil(auth.user!.id);

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (_perfilViewModel.perfil != null) {
          final perfil = _perfilViewModel.perfil!;
          
          // Asignar datos del perfil
          nombre = perfil.nombre;
          email = perfil.email ?? '';
          telefono = perfil.telefono;
          genero = perfil.genero;
          altura = perfil.altura?.toDouble() ?? 0.0;
          pesoInicial = perfil.pesoInicial?.toDouble() ?? 0.0;
          pesoObjetivo = perfil.pesoObjetivo?.toDouble() ?? 0.0;
          // 🧮 Calcular edad según la fecha de nacimiento
          if (perfil.fechaNacimiento != null) {
            final hoy = DateTime.now();
            edad = hoy.year - perfil.fechaNacimiento!.year;

            // Ajuste si aún no ha cumplido años este año
            if (hoy.month < perfil.fechaNacimiento!.month ||
                (hoy.month == perfil.fechaNacimiento!.month &&
                    hoy.day < perfil.fechaNacimiento!.day)) {
              edad--;
            }
          } else {
            edad = 0;
          }

          
          // <CHANGE> Obtener IMC directamente del backend
          imc = perfil.imc?.toDouble() ?? 0.0;
          
          // Determinar categoría de IMC basado en el valor del backend
          if (imc > 0) {
            if (imc < 18.5) {
              categoriaIMC = 'Bajo peso';
            } else if (imc < 25) {
              categoriaIMC = 'Normal';
            } else if (imc < 30) {
              categoriaIMC = 'Sobrepeso';
            } else {
              categoriaIMC = 'Obesidad';
            }
          }
          
          // Calcular meta en kg (diferencia entre peso inicial y objetivo)
          metaKg = (pesoInicial - pesoObjetivo).abs();
          
          // Aquí podrías obtener registrosTotales de otra API si está disponible
          registrosTotales = 5; // Valor por defecto
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final modoOscuro = widget.proveedorTema.modoOscuro;
    final colorFondo = modoOscuro ? ColoresApp.fondoPrincipalOscuro : const Color(0xFFF5F5F5);
    final colorTarjeta = modoOscuro ? ColoresApp.fondoTarjetaOscuro : Colors.white;
    final colorTexto = modoOscuro ? ColoresApp.textoPrincipalOscuro : ColoresApp.textoPrincipal;
    final colorTextoSecundario = modoOscuro ? ColoresApp.textoSecundarioOscuro : ColoresApp.textoSecundario;
    
    return Scaffold(
      backgroundColor: colorFondo,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.person_outline,
                                color: ColoresApp.naranja,
                                size: 28,
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Mi Perfil',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color: colorTexto,
                                    ),
                                  ),
                                  Text(
                                    'Gestiona tu información personal y configuraciones',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: colorTextoSecundario,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          _buildSeccionTitulo('Información Personal', colorTexto),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: colorTarjeta,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 56,
                                      height: 56,
                                      decoration: BoxDecoration(
                                        color: ColoresApp.naranja,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          nombre.isNotEmpty 
                                              ? nombre.substring(0, nombre.length >= 2 ? 2 : 1).toUpperCase()
                                              : 'U',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            nombre.isNotEmpty ? nombre : 'Usuario',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: colorTexto,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.email_outlined,
                                                size: 14,
                                                color: colorTextoSecundario,
                                              ),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  email.isNotEmpty ? email : 'Sin email',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: colorTextoSecundario,
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildInfoItem(
                                        'Peso Inicial', 
                                        pesoInicial > 0 ? '${pesoInicial.toStringAsFixed(1)} kg' : '-',
                                        colorTextoSecundario, 
                                        colorTexto
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildInfoItem(
                                        'Altura', 
                                        altura > 0 ? '${altura.toStringAsFixed(0)} cm' : '-',
                                        colorTextoSecundario, 
                                        colorTexto
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildInfoItem(
                                        'Peso Objetivo', 
                                        pesoObjetivo > 0 ? '${pesoObjetivo.toStringAsFixed(0)} kg' : '-',
                                        colorTextoSecundario, 
                                        colorTexto
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildInfoItem(
                                        'Edad', 
                                        edad > 0 ? '$edad años' : '-',
                                        colorTextoSecundario, 
                                        colorTexto
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                
                                if (imc > 0)
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF8F0),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'IMC Actual',
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: ColoresApp.textoSecundario,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              imc.toStringAsFixed(1),
                                              style: const TextStyle(
                                                fontSize: 28,
                                                fontWeight: FontWeight.w700,
                                                color: ColoresApp.naranja,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _getColorCategoria(categoriaIMC),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            categoriaIMC,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          _buildSeccionTitulo('Notificaciones', colorTexto),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: colorTarjeta,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                OpcionConfiguracion(
                                  icono: Icons.notifications_outlined,
                                  titulo: 'Recordatorios Semanales',
                                  subtitulo: 'Recibe recordatorios para registrar tu peso',
                                  valor: _recordatoriosSemanales,
                                  onCambiado: (valor) {
                                    setState(() {
                                      _recordatoriosSemanales = valor;
                                    });
                                  },
                                ),
                                Divider(color: modoOscuro ? ColoresApp.fondoDivisorOscuro : ColoresApp.fondoDivisor),
                                OpcionConfiguracion(
                                  icono: Icons.message_outlined,
                                  titulo: 'Mensajes Motivacionales',
                                  subtitulo: 'Recibe frases inspiradoras diariamente',
                                  valor: _mensajesMotivacionales,
                                  onCambiado: (valor) {
                                    setState(() {
                                      _mensajesMotivacionales = valor;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          _buildSeccionTitulo('Configuraciones', colorTexto),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: colorTarjeta,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                OpcionConfiguracion(
                                  icono: Icons.wb_sunny_outlined,
                                  titulo: 'Modo Oscuro',
                                  subtitulo: 'Cambia entre tema claro y oscuro',
                                  valor: modoOscuro,
                                  onCambiado: (valor) {
                                    widget.proveedorTema.cambiarTema(valor);
                                  },
                                ),
                                Divider(color: modoOscuro ? ColoresApp.fondoDivisorOscuro : ColoresApp.fondoDivisor),
                                OpcionConfiguracion(
                                  icono: Icons.lock_outline,
                                  titulo: 'Privacidad',
                                  subtitulo: 'Tus datos se almacenan localmente',
                                  valor: true,
                                  accionPersonalizada: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: ColoresApp.exito.withOpacity(0.1),
                                      border: Border.all(
                                        color: ColoresApp.exito,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      'Seguro',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: ColoresApp.exito,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: ColoresApp.naranja,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.show_chart,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Estadísticas Rápidas',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '$registrosTotales',
                                                  style: const TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  'Registros Totales',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white.withOpacity(0.9),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  metaKg.toStringAsFixed(1),
                                                  style: const TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  'Meta (kg)',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white.withOpacity(0.9),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                _mostrarDialogoCerrarSesion(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColoresApp.error,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.logout, size: 20),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Cerrar Sesión',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BarraNavegacionInferior(
        rutaActual: Rutas.perfil,
      ),
    );
  }

  Widget _buildSeccionTitulo(String titulo, Color colorTexto) {
    return Row(
      children: [
        Icon(
          Icons.person_outline,
          color: ColoresApp.naranja,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          titulo,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: colorTexto,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(String label, String valor, Color colorSecundario, Color colorPrincipal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: colorSecundario,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          valor,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: colorPrincipal,
          ),
        ),
      ],
    );
  }

  Color _getColorCategoria(String categoria) {
    switch (categoria) {
      case 'Bajo peso':
        return Colors.blue;
      case 'Normal':
        return ColoresApp.exito;
      case 'Sobrepeso':
        return ColoresApp.advertencia;
      case 'Obesidad':
        return ColoresApp.error;
      default:
        return ColoresApp.naranja;
    }
  }

  void _mostrarDialogoCerrarSesion(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                Rutas.inicioSesion,
                (route) => false,
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: ColoresApp.error,
            ),
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }
}