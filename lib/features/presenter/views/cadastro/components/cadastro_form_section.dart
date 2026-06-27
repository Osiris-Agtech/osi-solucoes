import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/views/login/components/auth/auth_widgets.dart';

class CadastroFormSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const CadastroFormSection({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Constants.kSecondBackgroundColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                AuthIconTile(icon: icon, size: 34),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    color: Constants.kText2,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            for (var index = 0; index < children.length; index++) ...[
              if (index > 0) const SizedBox(height: 12),
              children[index],
            ],
          ],
        ),
      ),
    );
  }
}
