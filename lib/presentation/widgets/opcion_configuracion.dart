import 'package:flutter/material.dart';
import '../../core/theme/colors_app.dart';

/// Widget para opciones de configuración con toggle switch
class OpcionConfiguracion extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String? subtitulo;
  final bool valor;
  final ValueChanged<bool>? onCambiado;
  final Widget? accionPersonalizada;

  const OpcionConfiguracion({
    super.key,
    required this.icono,
    required this.titulo,
    this.subtitulo,
    required this.valor,
    this.onCambiado,
    this.accionPersonalizada,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorTexto = theme.textTheme.bodyLarge?.color ?? ColoresApp.textoPrincipal;
    final colorTextoSecundario = theme.textTheme.bodyMedium?.color ?? ColoresApp.textoSecundario;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(
            icono,
            color: ColoresApp.naranja,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: colorTexto,
                  ),
                ),
                if (subtitulo != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitulo!,
                    style: TextStyle(
                      fontSize: 13,
                      color: colorTextoSecundario,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          if (accionPersonalizada != null)
            accionPersonalizada!
          else
            Switch(
              value: valor,
              onChanged: onCambiado,
              activeColor: ColoresApp.naranja,
              activeTrackColor: ColoresApp.naranja.withOpacity(0.5),
            ),
        ],
      ),
    );
  }
}
