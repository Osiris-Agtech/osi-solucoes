import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

class AppFormHeader extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;
  final VoidCallback? onBack;
  final List<Widget> actions;
  final PreferredSizeWidget? bottom;
  final Color backgroundColor;

  const AppFormHeader({
    super.key,
    this.title,
    this.leading,
    this.onBack,
    this.actions = const [],
    this.bottom,
    this.backgroundColor = Colors.white,
  });

  @override
  Size get preferredSize {
    final bottomHeight = bottom?.preferredSize.height ?? 0;
    return Size.fromHeight(kToolbarHeight + bottomHeight);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      leadingWidth: leading != null || onBack != null ? 56 : null,
      leading: leading ??
          (onBack != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: _FormBackButton(onPressed: onBack!),
                )
              : null),
      title: title != null
          ? Text(
              title!,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
      titleSpacing: title != null ? 8 : null,
      actions: actions,
      bottom: bottom,
    );
  }
}

class _FormBackButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _FormBackButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 40,
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
