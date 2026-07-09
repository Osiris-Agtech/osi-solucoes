import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

class AppPageHeaderSliver extends StatelessWidget {
  // Padding values match Spacing system (md=16, sm=8) for visual consistency.
  static const double _horizontalPadding = 16;
  static const double _topPadding = 8;
  static const double _bottomPadding = 16;
  // Navigation button (back or custom leading) — 40dp fits comfortably in a row
  // with title without consuming excessive vertical space.
  static const double _navigationButtonSize = 40;
  // Montserrat 22px/600 renders at ~32px actual line height
  // (font metrics + internal leading). Empirical values — bumped until
  // no overflow observed across all consumers.
  static const double _titleLineHeight = 32;
  // Montserrat 14px/500 renders at ~22px actual line height.
  static const double _subtitleLineHeight = 22;

  final String title;
  final String? subtitle;
  final Widget? subtitleWidget;
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
    this.subtitleWidget,
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
    final topSafeArea = MediaQuery.paddingOf(context).top;
    final effectiveToolbarHeight = _effectiveToolbarHeight();
    final effectiveExpandedHeight = _effectiveExpandedHeight(
      topSafeArea: topSafeArea,
      bottomHeight: bottomHeight,
      toolbarHeight: effectiveToolbarHeight,
    );

    return SliverAppBar(
      backgroundColor: backgroundColor,
      automaticallyImplyLeading: false,
      forceElevated: true,
      elevation: 1,
      pinned: pinned,
      floating: floating,
      expandedHeight: effectiveExpandedHeight,
      toolbarHeight: effectiveToolbarHeight,
      bottom: bottom,
      flexibleSpace: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                _horizontalPadding,
                _topPadding,
                _horizontalPadding,
                _bottomPadding + bottomHeight,
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (leading != null) ...[
                      SizedBox.square(
                        dimension: _navigationButtonSize,
                        child: Center(child: leading),
                      ),
                      const SizedBox(width: 12),
                    ] else if (onBack != null) ...[
                      _BackButton(onPressed: onBack!),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: _HeaderText(
                        title: title,
                        subtitle: subtitle,
                        subtitleWidget: subtitleWidget,
                        titleMaxLines: titleMaxLines,
                        subtitleMaxLines: subtitleMaxLines,
                      ),
                    ),
                    if (actions.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: _actionsMaxWidth(constraints.maxWidth),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          reverse: true,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: actions,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  double _effectiveExpandedHeight({
    required double topSafeArea,
    required double bottomHeight,
    required double toolbarHeight,
  }) {
    final minimumHeight = topSafeArea + toolbarHeight + bottomHeight;

    return expandedHeight > minimumHeight ? expandedHeight : minimumHeight;
  }

  double _effectiveToolbarHeight() {
    final minimumToolbarHeight =
        _topPadding + _contentHeight() + _bottomPadding;
    return kToolbarHeight > minimumToolbarHeight
        ? kToolbarHeight
        : minimumToolbarHeight;
  }

  double _contentHeight() {
    // Clamp to at least 1 — a zero/negative maxLines would hide the text,
    // which is never the intent when a title is provided.
    final titleLines = titleMaxLines < 1 ? 1 : titleMaxLines;
    final hasSubtitle = subtitle != null || subtitleWidget != null;
    // Use subtitleMaxLines for the string path; subtitleWidget controls its
    // own height so we use a single-line estimate.
    final subtitleLineCount = subtitleWidget != null
        ? 1
        : (subtitleMaxLines < 1 ? 1 : subtitleMaxLines);
    final textHeight = (_titleLineHeight * titleLines) +
        (hasSubtitle ? 2 + _subtitleLineHeight * subtitleLineCount : 0);

    return textHeight > _navigationButtonSize
        ? textHeight
        : _navigationButtonSize;
  }

  double _actionsMaxWidth(double availableWidth) {
    // Reserve up to ~38% of header width for actions — enough for a
    // PopupMenuButton or 2-3 icon buttons without starving the title area.
    final reservedWidth = availableWidth * 0.38;
    return reservedWidth < _navigationButtonSize
        ? _navigationButtonSize
        : reservedWidth;
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _BackButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppPageHeaderSliver._navigationButtonSize,
      child: Material(
        color: Constants.kSecondBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: const Icon(
            Icons.arrow_back,
            color: Constants.kPrimaryColor,
            size: 22,
          ),
        ),
      ),
    );
  }
}

class _HeaderText extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? subtitleWidget;
  final int titleMaxLines;
  final int subtitleMaxLines;

  const _HeaderText({
    required this.title,
    required this.subtitle,
    this.subtitleWidget,
    required this.titleMaxLines,
    required this.subtitleMaxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        if (subtitleWidget != null) ...[
          const SizedBox(height: 2),
          subtitleWidget!,
        ] else if (subtitle != null) ...[
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
    );
  }
}
