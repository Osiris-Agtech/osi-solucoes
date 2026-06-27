import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

class AccountSelectionCard extends StatelessWidget {
  final String name;
  final String role;
  final String? imageUrl;
  final bool isLoading;
  final VoidCallback onTap;

  const AccountSelectionCard({
    super.key,
    required this.name,
    required this.role,
    required this.onTap,
    this.imageUrl,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Constants.kBackgroundColor,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: isLoading ? null : onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 210,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isLoading
                  ? Constants.kPrimaryColor.withValues(alpha: 0.45)
                  : Constants.kGreyLight,
            ),
          ),
          child: Row(
            children: [
              _AccountAvatar(name: name, imageUrl: imageUrl),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Constants.kText2,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      role,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Constants.kGreyText,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              isLoading
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(
                      Icons.chevron_right,
                      color: Constants.kPrimaryColor,
                      size: 22,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccountAvatar extends StatelessWidget {
  final String name;
  final String? imageUrl;

  const _AccountAvatar({required this.name, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    return SizedBox.square(
      dimension: 52,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: url == null || url.isEmpty
            ? _InitialsAvatar(name: name)
            : Image.network(
                url,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _InitialsAvatar(name: name);
                },
                errorBuilder: (context, error, stackTrace) {
                  return _InitialsAvatar(name: name);
                },
              ),
      ),
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  final String name;

  const _InitialsAvatar({required this.name});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Constants.kPrimaryColor.withValues(alpha: 0.14),
      ),
      child: Center(
        child: Text(
          _initials(name),
          style: const TextStyle(
            color: Constants.kPrimaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  String _initials(String value) {
    final parts = value
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return '${parts.first.characters.first}${parts.last.characters.first}'
        .toUpperCase();
  }
}
