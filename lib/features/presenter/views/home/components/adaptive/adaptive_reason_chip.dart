import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/views/home/components/home_panel_shared.dart';

class AdaptiveReasonChip extends StatelessWidget {
  final String reason;
  final String? explanation;

  const AdaptiveReasonChip({
    super.key,
    required this.reason,
    this.explanation,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showReason(context),
      child: Container(
        height: 28,
        constraints: const BoxConstraints(maxWidth: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Constants.kCardColor,
          borderRadius: BorderRadius.circular(99),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.info_outline,
              size: 13,
              color: Constants.kGreyMedium,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                'Por que isso?',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Constants.kGreyMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReason(BuildContext context) {
    final displayText = explanation ?? reason;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 20,
                  color: Constants.kPrimaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Motivo da adaptação',
                  style: homeTitleStyle(16),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              displayText,
              style: homeBodyStyle(Colors.black87),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.kPrimaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Entendi'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
