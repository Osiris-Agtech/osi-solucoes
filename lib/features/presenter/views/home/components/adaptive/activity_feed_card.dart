import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/views/home/adaptive/instant_adaptive_home_view_data.dart';
import 'package:osi_solucoes/features/presenter/views/home/components/home_panel_shared.dart';

class ActivityFeedCard extends StatelessWidget {
  final List<ActivityFeedItemViewData> items;
  final ValueChanged<String>? onItemTap;

  const ActivityFeedCard({
    super.key,
    required this.items,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final visibleItems = items.take(5).toList();

    return HomePanelCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HomeSectionTitle(
            icon: Icons.history_rounded,
            title: 'Atividades recentes',
          ),
          const SizedBox(height: 12),
          ...visibleItems.map((item) => _ActivityItem(
                item: item,
                onTap: onItemTap != null && item.targetRoute != null
                    ? () => onItemTap!(item.targetRoute!)
                    : null,
              )),
        ],
      ),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final ActivityFeedItemViewData item;
  final VoidCallback? onTap;

  const _ActivityItem({
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tile = Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Constants.kPrimaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: homeTitleStyle(13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        item.subtitle,
                        style: homeBodyStyle(Colors.black54),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatRelativeTime(item.timestamp),
                      style: homeBodyStyle(
                        Constants.kGreyMedium.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (onTap != null)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Icon(
                Icons.chevron_right_rounded,
                size: 16,
                color: Constants.kGreyMedium,
              ),
            ),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: tile,
      );
    }

    return tile;
  }
}

String _formatRelativeTime(DateTime timestamp) {
  final now = DateTime.now();
  final diff = now.difference(timestamp);

  if (diff.inSeconds < 60) {
    return 'agora';
  } else if (diff.inMinutes < 60) {
    final m = diff.inMinutes;
    return 'há $m${m == 1 ? 'm' : 'm'}';
  } else if (diff.inHours < 24) {
    final h = diff.inHours;
    return 'há $h${h == 1 ? 'h' : 'h'}';
  } else if (diff.inDays < 7) {
    final d = diff.inDays;
    return 'há $d${d == 1 ? 'd' : 'd'}';
  } else {
    return '${timestamp.day}/${timestamp.month}';
  }
}
