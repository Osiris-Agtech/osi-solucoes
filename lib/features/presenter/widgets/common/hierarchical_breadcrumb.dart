import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

class BreadcrumbSegment {
  final String label;
  /// Builder called with the segment's text color so the caller can tint
  /// icons (SVG colorFilter, Icon color, etc.) to match the text hierarchy.
  final Widget Function(Color color)? iconBuilder;
  final VoidCallback? onTap;

  const BreadcrumbSegment({
    required this.label,
    this.iconBuilder,
    this.onTap,
  });
}

class HierarchicalBreadcrumb extends StatelessWidget {
  final List<BreadcrumbSegment> segments;

  const HierarchicalBreadcrumb({super.key, required this.segments});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _buildSegments(),
      ),
    );
  }

  List<Widget> _buildSegments() {
    final List<Widget> widgets = [];
    for (int i = 0; i < segments.length; i++) {
      final segment = segments[i];
      final isLast = i == segments.length - 1;

      if (i > 0) {
        widgets.add(
          Text(
            ' / ',
            style: const TextStyle(
              color: Constants.kGreyMedium,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }

      final textColor = isLast ? Colors.black : Constants.kGreyMedium;
      final iconColor = isLast ? Constants.kPrimaryColor : Constants.kGreyMedium;

      Widget label = Text(
        segment.label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: isLast ? FontWeight.w600 : FontWeight.w500,
          color: textColor,
        ),
      );

      final iconBuilder = segment.iconBuilder;
      if (iconBuilder != null) {
        label = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 16, height: 16, child: iconBuilder(iconColor)),
            const SizedBox(width: 4),
            label,
          ],
        );
      }

      if (!isLast && segment.onTap != null) {
        widgets.add(InkWell(
          onTap: segment.onTap,
          borderRadius: BorderRadius.circular(4),
          child: label,
        ));
      } else {
        widgets.add(label);
      }
    }
    return widgets;
  }
}
