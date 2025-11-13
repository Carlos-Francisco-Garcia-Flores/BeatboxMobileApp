import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import '../../core/theme/colors_app.dart';

/// Tipos de visualización del gráfico
enum TipoGrafico { linea, barras, area }

/// Widget de gráfico de evolución del peso
class GraficoEvolucion extends StatefulWidget {
  final List<Map<String, dynamic>> datos;

  const GraficoEvolucion({super.key, required this.datos});

  @override
  State<GraficoEvolucion> createState() => _GraficoEvolucionState();
}

class _GraficoEvolucionState extends State<GraficoEvolucion> {
  TipoGrafico _tipoSeleccionado = TipoGrafico.linea;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final datos = widget.datos;

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
              const Icon(Icons.show_chart, color: ColoresApp.naranja, size: 20),
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

          if (datos.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  'Aún no hay registros suficientes para mostrar el gráfico',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            SizedBox(
              height: 240,
              child: CustomPaint(
                painter: _GraficoPainter(
                  datos: datos,
                  tipo: _tipoSeleccionado,
                  isDark: theme.brightness == Brightness.dark,
                ),
                size: Size.infinite,
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

    const leftPadding = 45.0;
    const rightPadding = 10.0;
    const topPadding = 10.0;
    const bottomPadding = 30.0;

    final chartWidth = size.width - leftPadding - rightPadding;
    final chartHeight = size.height - topPadding - bottomPadding;

    final paint = Paint()
      ..color = ColoresApp.naranja
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = ColoresApp.naranja.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    // Encontrar valores mínimo y máximo
    double minPeso = datos
        .map((d) => d['peso'] as double)
        .reduce((a, b) => a < b ? a : b);
    double maxPeso = datos
        .map((d) => d['peso'] as double)
        .reduce((a, b) => a > b ? a : b);

    // Agregar margen visual
    final rango = maxPeso - minPeso == 0 ? 1 : (maxPeso - minPeso);
    minPeso -= rango * 0.1;
    maxPeso += rango * 0.1;

    _dibujarEjes(
      canvas,
      size,
      minPeso,
      maxPeso,
      leftPadding,
      topPadding,
      chartWidth,
      chartHeight,
    );

    // Calcular puntos con padding
    final puntos = <Offset>[];
    for (int i = 0; i < datos.length; i++) {
      final x = leftPadding + (chartWidth / (datos.length - 1)) * i;
      final peso = datos[i]['peso'] as double;
      final y =
          topPadding +
          chartHeight -
          ((peso - minPeso) / (maxPeso - minPeso)) * chartHeight;
      puntos.add(Offset(x, y));
    }

    // Dibujar según el tipo
    switch (tipo) {
      case TipoGrafico.linea:
        _dibujarLinea(canvas, puntos, paint);
        break;
      case TipoGrafico.barras:
        _dibujarBarras(
          canvas,
          size,
          puntos,
          paint,
          leftPadding,
          topPadding,
          chartHeight,
        );
        break;
      case TipoGrafico.area:
        _dibujarArea(
          canvas,
          size,
          puntos,
          fillPaint,
          paint,
          topPadding,
          chartHeight,
        );
        break;
    }

    // Dibujar puntos
    final pointPaint = Paint()
      ..color = ColoresApp.naranja
      ..style = PaintingStyle.fill;
    final pointBorderColor = isDark ? Colors.grey[800]! : Colors.white;

    for (final punto in puntos) {
      canvas.drawCircle(punto, 4, pointPaint);
      canvas.drawCircle(
        punto,
        6,
        Paint()
          ..color = pointBorderColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }

    _dibujarEtiquetasFecha(
      canvas,
      size,
      leftPadding,
      topPadding,
      chartWidth,
      chartHeight,
    );
  }

  void _dibujarEjes(
    Canvas canvas,
    Size size,
    double minPeso,
    double maxPeso,
    double leftPadding,
    double topPadding,
    double chartWidth,
    double chartHeight,
  ) {
    final textPainter = TextPainter(textDirection: ui.TextDirection.ltr);
    final linePaint = Paint()
      ..color = isDark ? Colors.grey[800]! : Colors.grey[300]!
      ..strokeWidth = 1;

    for (int i = 0; i <= 4; i++) {
      final y = topPadding + (chartHeight / 4) * i;
      canvas.drawLine(
        Offset(leftPadding, y),
        Offset(leftPadding + chartWidth, y),
        linePaint,
      );

      // Etiquetas del eje Y
      final peso = maxPeso - ((maxPeso - minPeso) / 4) * i;
      textPainter.text = TextSpan(
        text: '${peso.toStringAsFixed(1)}',
        style: TextStyle(
          color: isDark ? Colors.grey[400] : Colors.grey[600],
          fontSize: 11,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(5, y - 6));
    }
  }

  void _dibujarEtiquetasFecha(
    Canvas canvas,
    Size size,
    double leftPadding,
    double topPadding,
    double chartWidth,
    double chartHeight,
  ) {
    final textPainter = TextPainter(textDirection: ui.TextDirection.ltr);
    final dateFormat = DateFormat('dd/MM');

    final numEtiquetas = datos.length > 5 ? 5 : datos.length;
    final step = datos.length > 1 ? (datos.length - 1) / (numEtiquetas - 1) : 0;

    for (int i = 0; i < numEtiquetas; i++) {
      final index = (i * step).round().clamp(0, datos.length - 1);
      final dato = datos[index];

      // Parsear la fecha
      DateTime fecha;
      if (dato['fecha'] is DateTime) {
        fecha = dato['fecha'];
      } else if (dato['fecha'] is String) {
        fecha = DateTime.parse(dato['fecha']);
      } else {
        continue;
      }

      final x = leftPadding + (chartWidth / (datos.length - 1)) * index;
      final y = topPadding + chartHeight + 5;

      textPainter.text = TextSpan(
        text: dateFormat.format(fecha),
        style: TextStyle(
          color: isDark ? Colors.grey[400] : Colors.grey[600],
          fontSize: 10,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, y));
    }
  }

  void _dibujarLinea(Canvas canvas, List<Offset> puntos, Paint paint) {
    final path = Path()..moveTo(puntos[0].dx, puntos[0].dy);
    for (int i = 1; i < puntos.length; i++) {
      path.lineTo(puntos[i].dx, puntos[i].dy);
    }
    canvas.drawPath(path, paint);
  }

  void _dibujarBarras(
    Canvas canvas,
    Size size,
    List<Offset> puntos,
    Paint paint,
    double leftPadding,
    double topPadding,
    double chartHeight,
  ) {
    final barWidth = ((size.width - leftPadding - 10) / puntos.length) * 0.6;
    paint.style = PaintingStyle.fill;

    for (final punto in puntos) {
      final baseY = topPadding + chartHeight;
      final rect = Rect.fromLTWH(
        punto.dx - barWidth / 2,
        punto.dy,
        barWidth,
        baseY - punto.dy,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(4)),
        paint,
      );
    }
  }

  void _dibujarArea(
    Canvas canvas,
    Size size,
    List<Offset> puntos,
    Paint fillPaint,
    Paint linePaint,
    double topPadding,
    double chartHeight,
  ) {
    final baseY = topPadding + chartHeight;

    final path = Path()
      ..moveTo(puntos[0].dx, baseY)
      ..lineTo(puntos[0].dx, puntos[0].dy);

    for (int i = 1; i < puntos.length; i++) {
      path.lineTo(puntos[i].dx, puntos[i].dy);
    }

    path.lineTo(puntos.last.dx, baseY);
    path.close();

    canvas.drawPath(path, fillPaint);

    // Línea superior
    final linePath = Path()..moveTo(puntos[0].dx, puntos[0].dy);
    for (int i = 1; i < puntos.length; i++) {
      linePath.lineTo(puntos[i].dx, puntos[i].dy);
    }
    canvas.drawPath(linePath, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
