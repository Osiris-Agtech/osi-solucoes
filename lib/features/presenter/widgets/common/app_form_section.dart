import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

import 'app_panel_card.dart';

class AppFormSection extends StatelessWidget {
  final String title;
  final String? description;
  final List<Widget>? children;
  final Widget? child;
  final List<Widget> actions;
  final bool isRequired;
  final Widget? footer;

  const AppFormSection({
    super.key,
    required this.title,
    this.description,
    this.children,
    this.child,
    this.actions = const [],
    this.isRequired = false,
    this.footer,
  }) : assert(child != null || children != null);

  @override
  Widget build(BuildContext context) {
    return AppPanelCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Constants.kText2,
                        ),
                        children: [
                          if (isRequired)
                            const TextSpan(
                              text: ' *',
                              style: TextStyle(color: Constants.kErrorColor),
                            ),
                        ],
                      ),
                    ),
                    if (description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        description!,
                        style: const TextStyle(
                          fontSize: 12,
                          height: 1.35,
                          color: Constants.kGreyText2,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (actions.isNotEmpty) ...[
                const SizedBox(width: 8),
                Wrap(spacing: 6, children: actions),
              ],
            ],
          ),
          const SizedBox(height: 14),
          if (child != null)
            child!
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children!,
            ),
          if (footer != null) ...[
            const SizedBox(height: 12),
            footer!,
          ],
        ],
      ),
    );
  }
}
