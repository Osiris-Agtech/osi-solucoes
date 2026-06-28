import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

class AppSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;

  const AppSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    this.padding = const EdgeInsets.fromLTRB(20, 20, 20, 8),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: Constants.kPrimaryColor),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Constants.kText2,
                  ),
                ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Constants.kGreyMedium,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
