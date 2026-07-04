import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/views/home/adaptive/instant_adaptive_home_view_data.dart';
import 'package:osi_solucoes/features/presenter/views/home/components/home_panel_shared.dart';

class NextStepCard extends StatelessWidget {
  final NextStepViewData data;
  final VoidCallback onCtaTap;
  final VoidCallback? onInfoTap;

  const NextStepCard({
    super.key,
    required this.data,
    required this.onCtaTap,
    this.onInfoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: data.isProminent
            ? Constants.kPrimaryColor.withValues(alpha: 0.04)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(
            color: Constants.kPrimaryColor,
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  data.title,
                  style: homeTitleStyle(data.isProminent ? 18 : 16),
                ),
              ),
              if (data.infoExplanation != null && onInfoTap != null)
                GestureDetector(
                  onTap: onInfoTap,
                  child: Icon(
                    Icons.info_outline_rounded,
                    size: 20,
                    color: Constants.kPrimaryColor,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            data.description,
            style: homeBodyStyle(Colors.black54),
          ),
          const SizedBox(height: 14),
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
                data.ctaLabel,
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
