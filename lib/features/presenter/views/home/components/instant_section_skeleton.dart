import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

import 'home_panel_shared.dart';

/// Placeholder skeleton para as seções INSTANT enquanto carregam.
///
/// Exibe cards no formato visual de NextStep, FocusBanner, ActivityFeed
/// e RecommendedActions, permitindo que o usuário veja que conteúdo
/// está sendo carregado sem esconder o que já está disponível.
class InstantSectionSkeleton extends StatelessWidget {
  const InstantSectionSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _NextStepSkeleton(),
        SizedBox(height: 10),
        _FocusBannerSkeleton(),
        SizedBox(height: 10),
        _ActivityFeedSkeleton(),
        SizedBox(height: 10),
        _RecommendedActionsSkeleton(),
      ],
    );
  }
}

class _NextStepSkeleton extends StatelessWidget {
  const _NextStepSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(
            color: Constants.kPrimaryColor.withValues(alpha: 0.3),
            width: 4,
          ),
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 3),
            blurRadius: 16,
            color: Colors.black.withValues(alpha: 0.06),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ShimmerLine(width: 180, height: 16),
          const SizedBox(height: 8),
          _ShimmerLine(width: double.infinity, height: 14),
          const SizedBox(height: 6),
          _ShimmerLine(width: 140, height: 14),
          const SizedBox(height: 14),
          _ShimmerLine(width: 130, height: 36, borderRadius: 18),
        ],
      ),
    );
  }
}

class _FocusBannerSkeleton extends StatelessWidget {
  const _FocusBannerSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 3),
            blurRadius: 16,
            color: Colors.black.withValues(alpha: 0.06),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ShimmerLine(width: 120, height: 14),
                const SizedBox(height: 8),
                _ShimmerLine(width: double.infinity, height: 14),
                const SizedBox(height: 6),
                _ShimmerLine(width: 100, height: 14),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 80,
            height: 64,
            decoration: BoxDecoration(
              color: Constants.kGreyLight.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(12),
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
          const SizedBox(height: 14),
          ...List.generate(3, (_) => const _ActivityFeedItemSkeleton()),
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
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Constants.kGreyLight.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(10),
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

class _RecommendedActionsSkeleton extends StatelessWidget {
  const _RecommendedActionsSkeleton();

  @override
  Widget build(BuildContext context) {
    return HomePanelCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ShimmerLine(width: 160, height: 14),
          const SizedBox(height: 14),
          ...List.generate(
            2,
            (_) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
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
                        const SizedBox(height: 4),
                        _ShimmerLine(width: 200, height: 12),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerLine extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const _ShimmerLine({
    required this.width,
    required this.height,
    this.borderRadius = 999,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Constants.kGreyLight.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
