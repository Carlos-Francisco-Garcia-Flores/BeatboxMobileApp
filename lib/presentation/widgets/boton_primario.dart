import 'package:flutter/material.dart';
import '../../core/theme/colors_app.dart';

/// Widget de botón primario personalizado
class BotonPrimario extends StatelessWidget {
  final String texto;
  final Future<void> Function()? alPresionar; // ✅ acepta funciones async
  final bool cargando;
  final double? ancho;
  final IconData? icono;

  const BotonPrimario({
    super.key,
    required this.texto,
    required this.alPresionar,
    this.cargando = false,
    this.ancho,
    this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ancho ?? double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: cargando
            ? null
            : () async {
                if (alPresionar != null) await alPresionar!(); // ✅ async seguro
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: ColoresApp.naranja,
          foregroundColor: Colors.white,
          disabledBackgroundColor: ColoresApp.naranja.withOpacity(0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: cargando
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : icono != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(icono, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        texto.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  )
                : Text(
                    texto.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
      ),
    );
  }
}
