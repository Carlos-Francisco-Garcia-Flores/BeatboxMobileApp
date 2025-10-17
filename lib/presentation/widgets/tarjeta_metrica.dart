import 'package:flutter/material.dart';
import '../../core/theme/colors_app.dart';

/// Tarjeta pequeña para mostrar una métrica individual
class TarjetaMetrica extends StatelessWidget {
  final String valor;
  final String etiqueta;
  final IconData icono;
  final Color colorIcono;

  const TarjetaMetrica({
    super.key,
    required this.valor,
    required this.etiqueta,
    required this.icono,
    required this.colorIcono,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            valor,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: ColoresApp.naranja,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            etiqueta,
            style: TextStyle(
              fontSize: 12,
              color: theme.textTheme.bodyMedium?.color,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Icon(
              icono,
              color: colorIcono.withOpacity(0.3),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}
