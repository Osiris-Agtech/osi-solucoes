import 'package:flutter/material.dart';
import 'package:osi_solucoes/core/constants/constants.dart';

class FieldActivityItem {
  final String title;
  final String lote;
  final DateTime? date;
  final String user;
  final IconData icon;
  final Color color;

  const FieldActivityItem({
    required this.title,
    required this.lote,
    this.date,
    required this.user,
    this.icon = Icons.agriculture,
    this.color = Constants.kPrimaryColor,
  });
}

class FieldActivitiesWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<FieldActivityItem> activities;
  final Function(int)? onActivityTap;
  final VoidCallback? onViewAll;

  const FieldActivitiesWidget({
    Key? key,
    this.title = 'Caderno de Campo',
    this.subtitle = 'Últimas atividades',
    this.activities = const [
      FieldActivityItem(
        title: 'Aplicação de Defensivo',
        lote: 'Lote A-12',
        user: 'João Silva',
        icon: Icons.pest_control,
        color: Color(0xFFDC2626),
      ),
      FieldActivityItem(
        title: 'Irrigação Programada',
        lote: 'Lote B-08',
        user: 'Maria Santos',
        icon: Icons.water_drop,
        color: Color(0xFF06B6D4),
      ),
      FieldActivityItem(
        title: 'Colheita Iniciada',
        lote: 'Lote C-05',
        user: 'Pedro Costa',
        icon: Icons.agriculture,
        color: Color(0xFF059669),
      ),
      FieldActivityItem(
        title: 'Análise do Solo',
        lote: 'Lote D-15',
        user: 'Ana Oliveira',
        icon: Icons.science,
        color: Color(0xFF8B5CF6),
      ),
    ],
    this.onActivityTap,
    this.onViewAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.all(size.width * 0.05),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 4),
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildActivitiesList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final now = DateTime.now();
    final todayActivities = activities.where((activity) {
      final activityDate = activity.date ?? now;
      return activityDate.day == now.day &&
          activityDate.month == now.month &&
          activityDate.year == now.year;
    }).length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: Constants.kPrimaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.today,
                size: 16,
                color: Constants.kPrimaryColor,
              ),
              const SizedBox(width: 4),
              Text(
                '$todayActivities hoje',
                style: const TextStyle(
                  color: Constants.kPrimaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivitiesList() {
    return Column(
      children: [
        ...activities.asMap().entries.map((entry) {
          final index = entry.key;
          final activity = entry.value;
          final isLast = index == activities.length - 1;

          return Column(
            children: [
              _buildActivityItem(activity, index),
              if (!isLast) const SizedBox(height: 12),
            ],
          );
        }).toList(),
        const SizedBox(height: 16),
        _buildViewAllButton(),
      ],
    );
  }

  Widget _buildActivityItem(FieldActivityItem activity, int index) {
    return GestureDetector(
      onTap: () => onActivityTap?.call(index),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[100]!,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Activity icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: activity.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                activity.icon,
                color: activity.color,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),

            // Activity content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          activity.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 12,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        activity.lote,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.person,
                        size: 12,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          activity.user,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewAllButton() {
    return GestureDetector(
      onTap: onViewAll,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Constants.kPrimaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Constants.kPrimaryColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Ver caderno completo',
              style: TextStyle(
                color: Constants.kPrimaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            SizedBox(width: 4),
            Icon(
              Icons.arrow_forward_ios,
              color: Constants.kPrimaryColor,
              size: 12,
            ),
          ],
        ),
      ),
    );
  }
}
