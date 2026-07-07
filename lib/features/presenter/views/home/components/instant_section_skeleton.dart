import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

import 'home_panel_shared.dart';

class InstantSectionSkeleton extends StatelessWidget {
  const InstantSectionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _FocusBannerSkeleton(),
        SizedBox(height: 10),
        _ActivityFeedSkeleton(),
        SizedBox(height: 10),
        _InstantRecommendedActionsPanelSkeleton(),
      ],
    );
  }
}

class _FocusBannerSkeleton extends StatelessWidget {
  const _FocusBannerSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Constants.kPrimaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: Constants.kGreyLight.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(11),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ShimmerLine(width: double.infinity, height: 14),
                const SizedBox(height: 6),
                _ShimmerLine(width: 160, height: 14),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 56,
            height: 24,
            decoration: BoxDecoration(
              color: Constants.kGreyLight.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityFeedSkeleton extends StatelessWidget {
  const _ActivityFeedSkeleton();

  @override
  Widget build(BuildContext context) {
    return HomePanelCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ShimmerLine(width: 140, height: 14),
          const SizedBox(height: 12),
          ...List.generate(2, (_) => const _ActivityFeedItemSkeleton()),
        ],
      ),
    );
  }
}

class _ActivityFeedItemSkeleton extends StatelessWidget {
  const _ActivityFeedItemSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Constants.kGreyLight.withValues(alpha: 0.55),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ShimmerLine(width: double.infinity, height: 13),
                const SizedBox(height: 4),
                _ShimmerLine(width: 120, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InstantRecommendedActionsPanelSkeleton extends StatelessWidget {
  const _InstantRecommendedActionsPanelSkeleton();

  @override
  Widget build(BuildContext context) {
    return HomePanelCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _ShimmerLine(width: 170, height: 16),
              const Spacer(),
              _ShimmerLine(width: 82, height: 22),
            ],
          ),
          const SizedBox(height: 8),
          _ShimmerLine(width: double.infinity, height: 13),
          const SizedBox(height: 12),
          ...List.generate(
            2,
            (_) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Constants.kGreyLight.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ShimmerLine(width: 140, height: 14),
                        const SizedBox(height: 5),
                        _ShimmerLine(width: 200, height: 12),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 2),
          _ShimmerLine(width: 180, height: 12),
        ],
      ),
    );
  }
}

class _ShimmerLine extends StatelessWidget {
  final double width;
  final double height;

  const _ShimmerLine({
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Constants.kGreyLight.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}
