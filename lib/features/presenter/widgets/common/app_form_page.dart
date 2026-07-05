import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/widgets/common/app_form_header.dart';

class AppFormPage extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onBack;
  final List<Widget> actions;
  final double maxWidth;
  final Color backgroundColor;
  final EdgeInsetsGeometry contentPadding;
  final double cardMinHeight;

  const AppFormPage({
    super.key,
    required this.title,
    required this.child,
    this.onBack,
    this.actions = const [],
    this.maxWidth = 640,
    this.backgroundColor = Constants.kBackgroundColor,
    this.contentPadding = const EdgeInsets.all(24),
    this.cardMinHeight = 400,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Constants.kBackgroundColor,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: backgroundColor,
            appBar: AppFormHeader(
              title: title,
              onBack: onBack,
              actions: actions,
            ),
            body: LayoutBuilder(
              builder: (context, constraints) {
                final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
                final horizontalPadding =
                    constraints.maxWidth >= 720 ? 32.0 : 20.0;
                final verticalPadding = 24.0 + 28.0 + bottomInset;
                final availableHeight = constraints.maxHeight;
                final cardMaxHeight = availableHeight - verticalPadding;

                return Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    24.0,
                    horizontalPadding,
                    28.0 + bottomInset,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - verticalPadding,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: maxWidth,
                          minHeight: cardMinHeight,
                          maxHeight: cardMaxHeight,
                        ),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.07),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: contentPadding,
                            child: child,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
