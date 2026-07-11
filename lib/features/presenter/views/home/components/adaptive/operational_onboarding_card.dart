import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/views/home/components/home_panel_shared.dart';

class OperationalOnboardingCard extends StatelessWidget {
  final String title;
  final String message;
  final List<String> steps;
  final String? ctaLabel;
  final VoidCallback? onCtaTap;

  const OperationalOnboardingCard({
    super.key,
    required this.title,
    required this.message,
    required this.steps,
    this.ctaLabel,
    this.onCtaTap,
  });

  @override
  Widget build(BuildContext context) {
    final shouldRenderCta =
        ctaLabel?.trim().isNotEmpty == true && onCtaTap != null;

    return HomePanelCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Constants.kPrimaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.route_outlined,
                  color: Constants.kPrimaryColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: homeTitleStyle(15)),
                    const SizedBox(height: 6),
                    Text(message, style: homeBodyStyle(Colors.black54)),
                  ],
                ),
              ),
            ],
          ),
          if (steps.isNotEmpty) ...[
            const SizedBox(height: 16),
            Column(
              children: steps
                  .map(
                    (step) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _OperationalOnboardingStep(label: step),
                    ),
                  )
                  .toList(),
            ),
          ],
          if (shouldRenderCta) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onCtaTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.kPrimaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  ctaLabel!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _OperationalOnboardingStep extends StatelessWidget {
  final String label;

  const _OperationalOnboardingStep({required this.label});

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: Constants.kPrimaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(99),
            ),
            child: const Icon(
              Icons.check_rounded,
              size: 15,
              color: Constants.kPrimaryColor,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: homeBodyStyle(Constants.kGreyText),
            ),
          ),
        ],
      );
}
