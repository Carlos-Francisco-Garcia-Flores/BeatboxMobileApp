import 'package:flutter/material.dart';
import '../../core/theme/colors_app.dart';

/// Tipos de visualización del gráfico
enum TipoGrafico { linea, barras, area }

/// Widget de gráfico de evolución del peso
class GraficoEvolucion extends StatefulWidget {
  const GraficoEvolucion({super.key});

  @override
  State<GraficoEvolucion> createState() => _GraficoEvolucionState();
}

class _GraficoEvolucionState extends State<GraficoEvolucion> {
  TipoGrafico _tipoSeleccionado = TipoGrafico.linea;

  // Datos de ejemplo para el gráfico
  final List<Map<String, dynamic>> _datos = [
    {'fecha': '23/09', 'peso': 73.2},
    {'fecha': '23/09', 'peso': 72.5},
    {'fecha': '23/09', 'peso': 71.8},
    {'fecha': '23/09', 'peso': 72.3},
    {'fecha': '23/09', 'peso': 70.2},
  ];

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
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.show_chart,
                color: ColoresApp.naranja,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Evolución del Peso',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
              const Spacer(),
              _buildBotonTipo(TipoGrafico.linea, Icons.show_chart),
              const SizedBox(width: 4),
              _buildBotonTipo(TipoGrafico.barras, Icons.bar_chart),
              const SizedBox(width: 4),
              _buildBotonTipo(TipoGrafico.area, Icons.area_chart),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: CustomPaint(
              painter: _GraficoPainter(
                datos: _datos,
                tipo: _tipoSeleccionado,
                isDark: theme.brightness == Brightness.dark,
              ),
              child: Container(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotonTipo(TipoGrafico tipo, IconData icono) {
    final theme = Theme.of(context);
    final esSeleccionado = _tipoSeleccionado == tipo;
    
    return GestureDetector(
      onTap: () => setState(() => _tipoSeleccionado = tipo),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: esSeleccionado 
              ? ColoresApp.naranja 
              : theme.brightness == Brightness.dark
                  ? Colors.grey[800]
                  : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icono,
          size: 16,
          color: esSeleccionado ? Colors.white : Colors.grey[600],
        ),
      ),
    );
  }
}

/// Painter personalizado para dibujar el gráfico
class _GraficoPainter extends CustomPainter {
  final List<Map<String, dynamic>> datos;
  final TipoGrafico tipo;
  final bool isDark;

  _GraficoPainter({
    required this.datos,
    required this.tipo,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (datos.isEmpty) return;

    final paint = Paint()
      ..color = ColoresApp.naranja
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = ColoresApp.naranja.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    // Encontrar valores mínimo y máximo
    double minPeso = datos.map((d) => d['peso'] as double).reduce((a, b) => a < b ? a : b);
    double maxPeso = datos.map((d) => d['peso'] as double).reduce((a, b) => a > b ? a : b);
    
    // Agregar margen
    final rango = maxPeso - minPeso;
    minPeso -= rango * 0.1;
    maxPeso += rango * 0.1;

    // Dibujar ejes y etiquetas
    _dibujarEjes(canvas, size, minPeso, maxPeso);

    // Calcular puntos
    final puntos = <Offset>[];
    for (int i = 0; i < datos.length; i++) {
      final x = (size.width / (datos.length - 1)) * i;
      final peso = datos[i]['peso'] as double;
      final y = size.height - ((peso - minPeso) / (maxPeso - minPeso)) * size.height;
      puntos.add(Offset(x, y));
    }

    // Dibujar según el tipo
    switch (tipo) {
      case TipoGrafico.linea:
        _dibujarLinea(canvas, puntos, paint);
        break;
      case TipoGrafico.barras:
        _dibujarBarras(canvas, size, puntos, paint);
        break;
      case TipoGrafico.area:
        _dibujarArea(canvas, size, puntos, fillPaint, paint);
        break;
    }

    // Dibujar puntos
    final pointPaint = Paint()
      ..color = ColoresApp.naranja
      ..style = PaintingStyle.fill;

    final pointBorderColor = isDark ? Colors.grey[800]! : Colors.white;

    for (final punto in puntos) {
      canvas.drawCircle(punto, 4, pointPaint);
      canvas.drawCircle(punto, 6, Paint()
        ..color = pointBorderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2);
    }
  }

  void _dibujarEjes(Canvas canvas, Size size, double minPeso, double maxPeso) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final linePaint = Paint()
      ..color = isDark ? Colors.grey[800]! : Colors.grey[300]!
      ..strokeWidth = 1;

    for (int i = 0; i <= 4; i++) {
      final y = (size.height / 4) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);

      // Etiquetas del eje Y
      final peso = maxPeso - ((maxPeso - minPeso) / 4) * i;
      textPainter.text = TextSpan(
        text: '${peso.toStringAsFixed(1)}',
        style: TextStyle(
          color: isDark ? Colors.grey[400] : Colors.grey[600],
          fontSize: 10,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(-35, y - 6));
    }
  }

  void _dibujarLinea(Canvas canvas, List<Offset> puntos, Paint paint) {
    final path = Path();
    path.moveTo(puntos[0].dx, puntos[0].dy);
    for (int i = 1; i < puntos.length; i++) {
      path.lineTo(puntos[i].dx, puntos[i].dy);
    }
    canvas.drawPath(path, paint);
  }

  void _dibujarBarras(Canvas canvas, Size size, List<Offset> puntos, Paint paint) {
    final barWidth = (size.width / puntos.length) * 0.6;
    paint.style = PaintingStyle.fill;

    for (final punto in puntos) {
      final rect = Rect.fromLTWH(
        punto.dx - barWidth / 2,
        punto.dy,
        barWidth,
        size.height - punto.dy,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(4)),
        paint,
      );
    }
  }

  void _dibujarArea(Canvas canvas, Size size, List<Offset> puntos, Paint fillPaint, Paint linePaint) {
    final path = Path();
    path.moveTo(puntos[0].dx, size.height);
    path.lineTo(puntos[0].dx, puntos[0].dy);
    
    for (int i = 1; i < puntos.length; i++) {
      path.lineTo(puntos[i].dx, puntos[i].dy);
    }
    
    path.lineTo(puntos.last.dx, size.height);
    path.close();
    
    canvas.drawPath(path, fillPaint);
    
    // Dibujar línea superior
    final linePath = Path();
    linePath.moveTo(puntos[0].dx, puntos[0].dy);
    for (int i = 1; i < puntos.length; i++) {
      linePath.lineTo(puntos[i].dx, puntos[i].dy);
    }
    canvas.drawPath(linePath, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
