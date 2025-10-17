import 'package:flutter/material.dart';
import '../../core/theme/colors_app.dart';

class CampoTextoPersonalizado extends StatefulWidget {
  final String etiqueta;
  final String placeholder;
  final IconData icono;
  final bool esContrasena;
  final TextEditingController? controlador;
  final TextInputType? tipoTeclado;
  final String? Function(String?)? validador;

  const CampoTextoPersonalizado({
    Key? key,
    required this.etiqueta,
    required this.placeholder,
    required this.icono,
    this.esContrasena = false,
    this.controlador,
    this.tipoTeclado,
    this.validador,
  }) : super(key: key);

  @override
  State<CampoTextoPersonalizado> createState() =>
      _CampoTextoPersonalizadoState();
}

class _CampoTextoPersonalizadoState extends State<CampoTextoPersonalizado> {
  bool _ocultarTexto = true;

  @override
  void initState() {
    super.initState();
    _ocultarTexto = widget.esContrasena;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.etiqueta,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controlador,
          obscureText: _ocultarTexto,
          keyboardType: widget.tipoTeclado,
          validator: widget.validador,
          style: theme.textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: widget.placeholder,
            hintStyle: theme.textTheme.bodyLarge?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
            ),
            prefixIcon: Icon(
              widget.icono,
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
              size: 20,
            ),
            suffixIcon: widget.esContrasena
                ? IconButton(
                    icon: Icon(
                      _ocultarTexto
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _ocultarTexto = !_ocultarTexto;
                      });
                    },
                  )
                : null,
            filled: true,
            fillColor: theme.cardColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.dividerColor,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.dividerColor,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.error,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.error,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
