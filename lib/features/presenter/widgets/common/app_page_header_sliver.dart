import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

class AppPageHeaderSliver extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final VoidCallback? onBack;
  final List<Widget> actions;
  final PreferredSizeWidget? bottom;
  final Color backgroundColor;
  final double expandedHeight;
  final bool pinned;
  final bool floating;
  final int titleMaxLines;
  final int subtitleMaxLines;

  const AppPageHeaderSliver({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.onBack,
    this.actions = const [],
    this.bottom,
    this.backgroundColor = Colors.white,
    this.expandedHeight = 120,
    this.pinned = false,
    this.floating = true,
    this.titleMaxLines = 1,
    this.subtitleMaxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final bottomHeight = bottom?.preferredSize.height ?? 0;

    return SliverAppBar(
      backgroundColor: backgroundColor,
      automaticallyImplyLeading: false,
      forceElevated: true,
      elevation: 1,
      pinned: pinned,
      floating: floating,
      expandedHeight: expandedHeight,
      toolbarHeight: expandedHeight,
      actions: actions,
      bottom: bottom,
      flexibleSpace: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + bottomHeight),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (leading != null)
                leading!
              else if (onBack != null)
                IconButton(
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  alignment: Alignment.centerLeft,
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back),
                  color: Constants.kPrimaryColor,
                ),
              if (leading != null || onBack != null) const SizedBox(height: 4),
              Text(
                title,
                maxLines: titleMaxLines,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  maxLines: subtitleMaxLines,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Constants.kGreyMedium,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
