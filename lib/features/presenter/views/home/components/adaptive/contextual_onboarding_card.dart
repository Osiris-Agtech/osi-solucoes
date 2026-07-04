import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/views/home/adaptive/instant_adaptive_home_view_data.dart';
import 'package:osi_solucoes/features/presenter/views/home/components/home_panel_shared.dart';

class ContextualOnboardingCard extends StatelessWidget {
  final ContextualOnboardingViewData data;
  final VoidCallback onCtaTap;

  const ContextualOnboardingCard({
    super.key,
    required this.data,
    required this.onCtaTap,
  });

  @override
  Widget build(BuildContext context) {
    return HomePanelCard(
      child: Column(
        children: [
          // Dashed border is rendered as an overlay using a decorated container
          // wrapping the content inside HomePanelCard's white rounded area.
          // We use a Stack to layer the dashed border on top.
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(2),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Icon(
                      Icons.explore_outlined,
                      size: 48,
                      color: Constants.kPrimaryColor,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      data.title,
                      style: homeTitleStyle(15),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      data.message,
                      style: homeBodyStyle(Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: onCtaTap,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Constants.kPrimaryColor,
                        side: const BorderSide(color: Constants.kPrimaryColor),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        data.ctaLabel,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Dashed border overlay
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _DashedBorderPainter(
                      color: Constants.kPrimaryColor.withValues(alpha: 0.4),
                      strokeWidth: 1.5,
                      dashWidth: 6,
                      gapWidth: 4,
                      borderRadius: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double gapWidth;
  final double borderRadius;

  const _DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.gapWidth,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );

    // Draw dashed path manually by extracting contours
    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = 0;
      while (distance < metric.length) {
                final end = (distance + dashWidth).clamp(0.0, metric.length);
        final segment = metric.extractPath(distance, end);
        canvas.drawPath(segment, paint);
        distance += dashWidth + gapWidth;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.dashWidth != dashWidth ||
      oldDelegate.gapWidth != gapWidth ||
      oldDelegate.borderRadius != borderRadius;
}
