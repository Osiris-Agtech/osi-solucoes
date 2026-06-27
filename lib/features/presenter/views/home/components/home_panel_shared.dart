import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

import '../models/home_panel_view_data.dart';

class HomePanelCard extends StatelessWidget {
  final Widget child;

  const HomePanelCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 3),
              blurRadius: 16,
              color: Colors.black.withValues(alpha: 0.06),
            ),
          ],
        ),
        child: child,
      );
}

class HomeSectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;

  const HomeSectionTitle({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(icon, color: Constants.kPrimaryColor, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: homeTitleStyle(16)),
                if (subtitle != null)
                  Text(subtitle!, style: homeBodyStyle(Colors.black54)),
              ],
            ),
          ),
        ],
      );
}

class HomeBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const HomeBadge({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Container(
        constraints: const BoxConstraints(maxWidth: 260),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Constants.kPrimaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(99),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: Constants.kPrimaryColor),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Constants.kPrimaryColor,
                ),
              ),
            ),
          ],
        ),
      );
}

class HomeAssetIcon extends StatelessWidget {
  final String iconAsset;
  final Color color;

  const HomeAssetIcon(
      {super.key, required this.iconAsset, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: SvgPicture.asset(
            iconAsset,
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
        ),
      );
}

TextStyle homeTitleStyle(double size) => TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w800,
      color: Colors.black87,
      height: 1.15,
    );

TextStyle homeBodyStyle(Color color) => TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: color,
      height: 1.25,
    );

Color homeToneColor(HomePanelTone tone) {
  switch (tone) {
    case HomePanelTone.primary:
      return Constants.kPrimaryColor;
    case HomePanelTone.success:
      return const Color(0xFF059669);
    case HomePanelTone.warning:
      return Constants.kWarninngColor;
    case HomePanelTone.danger:
      return Constants.kErrorColor;
    case HomePanelTone.neutral:
      return Constants.kGreyMedium;
  }
}
