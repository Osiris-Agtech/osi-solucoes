import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

import 'home_info_view_data.dart';

class HomeTodayCultivationInfoContent extends StatelessWidget {
  final HomeInfoViewData data;

  const HomeTodayCultivationInfoContent({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final firstItem = data.items.isNotEmpty ? data.items.first : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (data.subtitle != null) ...[
          Text(
            data.subtitle!,
            style: const TextStyle(
              fontSize: 12,
              height: 1.35,
              color: Constants.kGreyText,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (firstItem != null) ...[
          _FeaturedActivity(item: firstItem),
        ],
        if (data.metrics.isNotEmpty) ...[
          if (firstItem != null) const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: data.metrics.map(_SupportingMetricChip.new).toList(),
          ),
        ],
      ],
    );
  }
}

class _FeaturedActivity extends StatelessWidget {
  final HomeInfoListItem item;

  const _FeaturedActivity({required this.item});

  @override
  Widget build(BuildContext context) {
    final color = _itemToneColor(item.tone);
    final metadata = _metadataFor(item);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                item.tone == HomeInfoItemTone.danger
                    ? Icons.warning_amber_rounded
                    : Icons.event_available_rounded,
                size: 16,
                color: color,
              ),
              const SizedBox(width: 6),
              Text(
                item.tone == HomeInfoItemTone.danger
                    ? 'Atividade em atraso'
                    : 'Próxima atividade',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            item.title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (item.subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              item.subtitle!,
              style: const TextStyle(
                fontSize: 12,
                color: Constants.kGreyText,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (metadata != null) ...[
            const SizedBox(height: 8),
            Text(
              metadata,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Constants.kText2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

class _SupportingMetricChip extends StatelessWidget {
  final HomeInfoMetric metric;

  const _SupportingMetricChip(this.metric);

  @override
  Widget build(BuildContext context) {
    final color = _metricToneColor(metric.tone);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        '${metric.value} ${metric.label.toLowerCase()}',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

String? _metadataFor(HomeInfoListItem item) {
  final parts = [item.lotName, item.date].whereType<String>().toList();
  if (parts.isEmpty) return null;
  return parts.join(' • ');
}

Color _itemToneColor(HomeInfoItemTone tone) {
  switch (tone) {
    case HomeInfoItemTone.warning:
      return const Color(0xFFD97706);
    case HomeInfoItemTone.danger:
      return Constants.kErrorColor;
    case HomeInfoItemTone.neutral:
      return Constants.kPrimaryColor;
  }
}

Color _metricToneColor(HomeInfoMetricTone tone) {
  switch (tone) {
    case HomeInfoMetricTone.positive:
      return const Color(0xFF059669);
    case HomeInfoMetricTone.warning:
      return const Color(0xFFD97706);
    case HomeInfoMetricTone.danger:
      return Constants.kErrorColor;
    case HomeInfoMetricTone.neutral:
      return Constants.kGreyText;
  }
}
