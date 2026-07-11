import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';
import 'package:osi_solucoes/features/presenter/views/home/components/home_panel_shared.dart';
import 'home_today_cultivation_info_content.dart';
import 'home_info_view_data.dart';

class HomeInfoCard extends StatelessWidget {
  final HomeInfoViewData data;
  final VoidCallback? onCtaTap;
  final VoidCallback? onTap;
  final bool isLoading;

  const HomeInfoCard({
    super.key,
    required this.data,
    this.onCtaTap,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildSkeleton();
    }

    if (data.type == HomeInfoType.operationalOnboarding) {
      return _buildOperationalOnboardingCard();
    }

    return HomePanelCard(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 14),
            _buildContent(),
            if (data.type != HomeInfoType.basicTip &&
                data.ctaLabel != null &&
                onCtaTap != null) ...[
              const SizedBox(height: 14),
              _buildCta(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(_iconForType(data.type),
            size: 20, color: _colorForType(data.type)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            data.title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOperationalOnboardingCard() {
    final shouldRenderCta =
        data.ctaLabel?.trim().isNotEmpty == true && onCtaTap != null;

    return HomePanelCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Constants.kPrimaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.route_outlined,
                  color: Constants.kPrimaryColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.title, style: homeTitleStyle(15)),
                    if (data.subtitle != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        data.subtitle!,
                        style: homeBodyStyle(Colors.black54),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (data.items.isNotEmpty) ...[
            const SizedBox(height: 16),
            Column(
              children: data.items
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _OperationalOnboardingStep(label: item.title),
                    ),
                  )
                  .toList(),
            ),
          ],
          if (shouldRenderCta) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onCtaTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constants.kPrimaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  data.ctaLabel!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (data.type == HomeInfoType.todayCultivation) {
      return HomeTodayCultivationInfoContent(data: data);
    }

    // basic_tip: just show the tip text
    if (data.type == HomeInfoType.basicTip && data.tipText != null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Constants.kPrimaryColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.lightbulb_outline,
                size: 18, color: Constants.kPrimaryColor),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                data.tipText!,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.45,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Subtitle
        if (data.subtitle != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              data.subtitle!,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ),
        // Metrics row
        if (data.metrics.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: data.metrics.map((m) => _MetricChip(metric: m)).toList(),
          ),
          if (data.items.isNotEmpty) const SizedBox(height: 12),
        ],
        // Items
        if (data.items.isNotEmpty) ...[
          ...data.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: _InfoListItem(item: item),
              )),
        ],
      ],
    );
  }

  Widget _buildCta() {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onCtaTap,
        style: TextButton.styleFrom(
          foregroundColor: Constants.kPrimaryColor,
          backgroundColor: Constants.kPrimaryColor.withValues(alpha: 0.08),
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              data.ctaLabel!,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right_rounded, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeleton() {
    return HomePanelCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 16,
            width: 140,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconForType(HomeInfoType type) {
    switch (type) {
      case HomeInfoType.todayCultivation:
        return Icons.eco_rounded;
      case HomeInfoType.reservoirReport:
        return Icons.water_drop_rounded;
      case HomeInfoType.fieldNotesSummary:
        return Icons.menu_book_rounded;
      case HomeInfoType.operationalOnboarding:
        return Icons.route_outlined;
      case HomeInfoType.basicTip:
        return Icons.lightbulb_outline;
    }
  }

  Color _colorForType(HomeInfoType type) {
    switch (type) {
      case HomeInfoType.todayCultivation:
        return Constants.kPrimaryColor;
      case HomeInfoType.reservoirReport:
        return const Color(0xFF2563EB);
      case HomeInfoType.fieldNotesSummary:
        return const Color(0xFFD97706);
      case HomeInfoType.operationalOnboarding:
        return Constants.kPrimaryColor;
      case HomeInfoType.basicTip:
        return Constants.kGreyText;
    }
  }
}

class _MetricChip extends StatelessWidget {
  final HomeInfoMetric metric;

  const _MetricChip({required this.metric});

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(metric.tone);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            metric.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            metric.value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _toneColor(HomeInfoMetricTone tone) {
    switch (tone) {
      case HomeInfoMetricTone.positive:
        return const Color(0xFF059669);
      case HomeInfoMetricTone.warning:
        return const Color(0xFFD97706);
      case HomeInfoMetricTone.danger:
        return const Color(0xFFDC2626);
      case HomeInfoMetricTone.neutral:
        return const Color(0xFF4B5563);
    }
  }
}

class _InfoListItem extends StatelessWidget {
  final HomeInfoListItem item;

  const _InfoListItem({required this.item});

  @override
  Widget build(BuildContext context) {
    final color = _itemToneColor(item.tone);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            item.tone == HomeInfoItemTone.danger
                ? Icons.warning_rounded
                : Icons.circle_rounded,
            size: 8,
            color: color,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    item.subtitle!,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (item.lotName != null ||
                    item.date != null ||
                    item.userName != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    [
                      item.lotName,
                      item.userName,
                      item.date,
                    ].whereType<String>().join(' • '),
                    style: const TextStyle(fontSize: 11, color: Colors.black45),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _itemToneColor(HomeInfoItemTone tone) {
    switch (tone) {
      case HomeInfoItemTone.warning:
        return const Color(0xFFD97706);
      case HomeInfoItemTone.danger:
        return const Color(0xFFDC2626);
      case HomeInfoItemTone.neutral:
        return const Color(0xFF4B5563);
    }
  }
}

class _OperationalOnboardingStep extends StatelessWidget {
  final String label;

  const _OperationalOnboardingStep({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: Constants.kPrimaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(99),
          ),
          child: const Icon(
            Icons.check_rounded,
            size: 15,
            color: Constants.kPrimaryColor,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: homeBodyStyle(Constants.kGreyText),
          ),
        ),
      ],
    );
  }
}
