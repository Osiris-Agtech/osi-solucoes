import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

import 'app_panel_card.dart';

class AppEntityCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? description;
  final Widget? leading;
  final Widget? image;
  final List<Widget> badges;
  final List<Widget> metadata;
  final List<Widget> actions;
  final VoidCallback? onTap;
  final bool isDisabled;
  final EdgeInsetsGeometry padding;

  const AppEntityCard({
    super.key,
    required this.title,
    this.subtitle,
    this.description,
    this.leading,
    this.image,
    this.badges = const [],
    this.metadata = const [],
    this.actions = const [],
    this.onTap,
    this.isDisabled = false,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isDisabled ? 0.5 : 1,
      child: AppPanelCard(
        onTap: isDisabled ? null : onTap,
        padding: padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 14)],
            if (image != null) ...[image!, const SizedBox(width: 14)],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Constants.kText2,
                          ),
                        ),
                      ),
                      if (badges.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Wrap(spacing: 6, runSpacing: 6, children: badges),
                      ],
                    ],
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Constants.kGreyText,
                      ),
                    ),
                  ],
                  if (description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      description!,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: Constants.kGreyText2,
                      ),
                    ),
                  ],
                  if (metadata.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Wrap(spacing: 8, runSpacing: 6, children: metadata),
                  ],
                ],
              ),
            ),
            if (actions.isNotEmpty) ...[
              const SizedBox(width: 8),
              Wrap(spacing: 4, children: actions),
            ] else if (onTap != null && !isDisabled) ...[
              const SizedBox(width: 8),
              const Icon(
                Icons.chevron_right,
                color: Constants.kGreyLight,
                size: 20,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
