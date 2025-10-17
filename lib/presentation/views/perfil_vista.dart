import 'package:flutter/material.dart';
import '../../core/theme/colors_app.dart';
import '../../core/constants/routes.dart';
import '../../core/proveedores/theme_provider.dart';
import '../widgets/header_app.dart';
import '../widgets/barra_navegacion_inferior.dart';
import '../widgets/opcion_configuracion.dart';

/// Vista de perfil de usuario
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
  bool _recordatoriosSemanales = true;
  bool _mensajesMotivacionales = false;

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
              child: SingleChildScrollView(
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
                                child: const Center(
                                  child: Text(
                                    'JE',
                                    style: TextStyle(
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
                                      'jesuseduardoh41',
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
                                        Text(
                                          'jesuseduardoh41@gmail.com',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: colorTextoSecundario,
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
                                child: _buildInfoItem('Peso Inicial', '78.0 kg', colorTextoSecundario, colorTexto),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildInfoItem('Altura', '175 cm', colorTextoSecundario, colorTexto),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoItem('Peso Objetivo', '70 kg', colorTextoSecundario, colorTexto),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildInfoItem('Edad', '28 años', colorTextoSecundario, colorTexto),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
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
                                    const Text(
                                      '25.5',
                                      style: TextStyle(
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
                                    color: ColoresApp.advertencia,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'Sobrepeso',
                                    style: TextStyle(
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
                                          const Text(
                                            '5',
                                            style: TextStyle(
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
                                          const Text(
                                            '8.0',
                                            style: TextStyle(
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
