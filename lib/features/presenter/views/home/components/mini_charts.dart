import 'package:flutter/material.dart';

/// Mini gráfico de tendência (sparkline) para mostrar evolução de produção
class MiniTrendChart extends StatelessWidget {
  final List<double> values;
  final List<String>? labels;
  final Color lineColor;
  final Color fillColor;
  final double height;

  const MiniTrendChart({
    super.key,
    required this.values,
    this.labels,
    this.lineColor = const Color(0xFF059669),
    this.fillColor = const Color(0x20059669),
    this.height = 60,
  });

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) return const SizedBox.shrink();

    final maxValue = values.reduce((a, b) => a > b ? a : b);
    if (maxValue == 0) return const SizedBox.shrink();

    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: _SparklinePainter(
          values: values,
          labels: labels,
          lineColor: lineColor,
          fillColor: fillColor,
        ),
        size: Size(double.infinity, height),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> values;
  final List<String>? labels;
  final Color lineColor;
  final Color fillColor;

  _SparklinePainter({
    required this.values,
    this.labels,
    required this.lineColor,
    required this.fillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    final maxVal = values.reduce((a, b) => a > b ? a : b);
    final padding = 20.0;
    final chartWidth = size.width;
    final chartHeight = size.height - padding;

    // Criar pontos
    final points = <Offset>[];
    for (int i = 0; i < values.length; i++) {
      final x = (i / (values.length - 1)) * chartWidth;
      final y = chartHeight - (values[i] / maxVal) * chartHeight;
      points.add(Offset(x, y));
    }

    // Desenhar área preenchida
    final fillPath = Path()..moveTo(points[0].dx, chartHeight);
    for (final point in points) {
      fillPath.lineTo(point.dx, point.dy);
    }
    fillPath.lineTo(points.last.dx, chartHeight);
    fillPath.close();
    canvas.drawPath(fillPath, fillPaint);

    // Desenhar linha
    final linePath = Path()..moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      linePath.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(linePath, paint);

    // Desenhar labels (se houver)
    if (labels != null && labels!.length == values.length) {
      for (int i = 0; i < labels!.length; i++) {
        final x = (i / (labels!.length - 1)) * chartWidth;
        textPainter.text = TextSpan(
          text: labels![i],
          style: const TextStyle(fontSize: 9, color: Colors.black54),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x - textPainter.width / 2, chartHeight + 2),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.labels != labels ||
        oldDelegate.lineColor != lineColor;
  }
}

/// Widget de gauge circular para taxas de conversão
class RateGauge extends StatelessWidget {
  final double value; // 0-100
  final String label;
  final Color color;
  final double size;

  const RateGauge({
    super.key,
    required this.value,
    required this.label,
    this.color = const Color(0xFF059669),
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CustomPaint(
              painter: _GaugePainter(
                value: value,
                color: color,
                strokeWidth: 6,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${value.toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: size * 0.18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double value;
  final Color color;
  final double strokeWidth;

  _GaugePainter({
    required this.value,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Fundo
    final bgPaint = Paint()
      ..color = Colors.grey[200]!
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, bgPaint);

    // Progresso
    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sweepAngle = (value / 100) * 2 * 3.14159;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2, // Começa do topo
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.color != color;
  }
}
