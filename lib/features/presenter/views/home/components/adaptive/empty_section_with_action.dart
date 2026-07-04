import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/views/home/components/home_panel_shared.dart';

class EmptySectionWithAction extends StatelessWidget {
  final String title;
  final String message;
  final String ctaLabel;
  final VoidCallback onCtaTap;
  final IconData icon;

  const EmptySectionWithAction({
    super.key,
    required this.title,
    required this.message,
    required this.ctaLabel,
    required this.onCtaTap,
    this.icon = Icons.inbox_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return HomePanelCard(
      child: Column(
        children: [
          const SizedBox(height: 8),
          Icon(
            icon,
            size: 48,
            color: Constants.kGreyMedium,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: homeTitleStyle(15),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: homeBodyStyle(Colors.black54),
            textAlign: TextAlign.center,
          ),
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
                ctaLabel,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
