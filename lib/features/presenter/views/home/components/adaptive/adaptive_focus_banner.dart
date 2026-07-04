import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/views/home/adaptive/instant_adaptive_home_view_data.dart';
import 'package:osi_solucoes/features/presenter/views/home/components/home_panel_shared.dart';

class AdaptiveFocusBanner extends StatelessWidget {
  final AdaptiveFocusBannerViewData data;
  final VoidCallback? onCtaTap;

  const AdaptiveFocusBanner({
    super.key,
    required this.data,
    this.onCtaTap,
  });

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
          Icon(
            Icons.track_changes_rounded,
            size: 22,
            color: Constants.kPrimaryColor,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              data.message,
              style: homeBodyStyle(Colors.black87),
            ),
          ),
          if (data.targetRoute != null && data.ctaLabel != null && onCtaTap != null) ...[
            const SizedBox(width: 8),
            TextButton(
              onPressed: onCtaTap,
              style: TextButton.styleFrom(
                foregroundColor: Constants.kPrimaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                data.ctaLabel!,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
