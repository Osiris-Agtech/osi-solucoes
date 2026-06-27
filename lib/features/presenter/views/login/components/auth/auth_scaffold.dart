import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

class AuthScaffold extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final Widget? leading;

  const AuthScaffold({
    super.key,
    required this.child,
    this.maxWidth = 520,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Constants.kSecondBackgroundColor,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Constants.kSecondBackgroundColor,
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Constants.kSecondBackgroundColor,
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            onVerticalDragCancel: () => FocusScope.of(context).unfocus(),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    constraints.maxWidth >= 720 ? 32 : 20,
                    leading == null ? 24 : 12,
                    constraints.maxWidth >= 720 ? 32 : 20,
                    28 + MediaQuery.viewInsetsOf(context).bottom,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (leading != null) leading!,
                          child,
                        ],
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
