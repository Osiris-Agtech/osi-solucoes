import 'package:flutter/material.dart';

/// Widget de barra de progresso segmentada por status
/// Ex: [======== verde ====] [== amarela ==] [== vermelha ==]
class SegmentedProgressBar extends StatelessWidget {
  final List<SegmentProgress> segments;
  final double height;
  final double borderRadius;

  const SegmentedProgressBar({
    super.key,
    required this.segments,
    this.height = 12,
    this.borderRadius = 6,
  });

  @override
  Widget build(BuildContext context) {
    final total = segments.fold<int>(0, (sum, s) => sum + s.value);
    if (total == 0) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Barra segmentada
        ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: SizedBox(
            height: height,
            width: double.infinity,
            child: Row(
              children: segments.map((segment) {
                final flex = segment.value;
                return Flexible(
                  flex: flex,
                  child: Container(
                    color: _parseColor(segment.color) ?? Colors.grey,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 6),
        // Legenda
        Wrap(
          spacing: 12,
          runSpacing: 4,
          children: segments.map((segment) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _parseColor(segment.color) ?? Colors.grey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${segment.label}: ${segment.value}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}

class SegmentProgress {
  final String label;
  final int value;
  final String color;

  const SegmentProgress({
    required this.label,
    required this.value,
    required this.color,
  });
}

/// Parse de cor hex string com fallback
Color? _parseColor(String hex) {
  try {
    if (hex.isEmpty) return null;
    String clean = hex.replaceAll('#', '');
    if (clean.length == 6) clean = 'FF$clean';
    return Color(int.parse(clean, radix: 16));
  } catch (e) {
    return null;
  }
}
