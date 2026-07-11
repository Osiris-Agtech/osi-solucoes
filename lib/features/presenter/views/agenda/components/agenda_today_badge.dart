import 'package:flutter/material.dart';

class AgendaTodayBadge extends StatelessWidget {
  const AgendaTodayBadge({super.key});

  static const _foregroundColor = Color(0xFF0F6B3A);
  static const _backgroundColor = Color(0xFFEAF7EF);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: _foregroundColor),
      ),
      child: const Text(
        'Hoje',
        style: TextStyle(
          color: _foregroundColor,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
