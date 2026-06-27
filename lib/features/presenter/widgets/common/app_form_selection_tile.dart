import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

import 'app_panel_card.dart';

class AppFormSelectionTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool isSelected;
  final bool isEnabled;
  final VoidCallback? onTap;
  final Widget? badge;
  final List<Widget> metadata;
  final String? errorText;

  const AppFormSelectionTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.isSelected = false,
    this.isEnabled = true,
    this.onTap,
    this.badge,
    this.metadata = const [],
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isEnabled ? 1 : 0.55,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppPanelCard(
            onTap: isEnabled ? onTap : null,
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                if (leading != null) ...[leading!, const SizedBox(width: 12)],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Constants.kText2,
                              ),
                            ),
                          ),
                          if (badge != null) ...[
                            const SizedBox(width: 8),
                            badge!,
                          ],
                        ],
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Constants.kGreyText2,
                          ),
                        ),
                      ],
                      if (metadata.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Wrap(spacing: 8, runSpacing: 6, children: metadata),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                trailing ??
                    Icon(
                      isSelected ? Icons.check_circle : Icons.chevron_right,
                      color: isSelected
                          ? Constants.kPrimaryColor
                          : Constants.kGreyLight,
                    ),
              ],
            ),
          ),
          if (errorText != null) ...[
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                errorText!,
                style: const TextStyle(
                  fontSize: 12,
                  color: Constants.kErrorColor,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
