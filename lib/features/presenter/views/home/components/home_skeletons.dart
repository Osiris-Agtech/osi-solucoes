import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

import 'home_panel_shared.dart';

class HomeDailyPanelSkeleton extends StatelessWidget {
  const HomeDailyPanelSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _SkeletonCard(height: 120),
        SizedBox(height: 14),
        _SkeletonCard(height: 220),
        SizedBox(height: 14),
        _SkeletonCard(height: 190),
        SizedBox(height: 14),
        _SkeletonCard(height: 140),
        SizedBox(height: 14),
        _SkeletonCard(height: 230),
      ],
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  final double height;

  const _SkeletonCard({required this.height});

  @override
  Widget build(BuildContext context) => HomePanelCard(
        child: SizedBox(
          height: height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _SkeletonLine(width: 160),
              SizedBox(height: 14),
              _SkeletonLine(width: double.infinity),
              SizedBox(height: 8),
              _SkeletonLine(width: 220),
              Spacer(),
              _SkeletonLine(width: 120),
            ],
          ),
        ),
      );
}

class _SkeletonLine extends StatelessWidget {
  final double width;

  const _SkeletonLine({required this.width});

  @override
  Widget build(BuildContext context) => Container(
        height: 14,
        width: width,
        decoration: BoxDecoration(
          color: Constants.kGreyLight.withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(999),
        ),
      );
}
