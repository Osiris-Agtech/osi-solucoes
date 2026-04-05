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
    super.key,
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
      FieldActivityItem(
        title: 'Adubação Foliar',
        lote: 'Lote E-20',
        user: 'Carlos Mendes',
        icon: Icons.eco,
        color: Color(0xFF10B981),
      ),
      FieldActivityItem(
        title: 'Controle de Pragas',
        lote: 'Lote F-03',
        user: 'Lucia Ferreira',
        icon: Icons.bug_report,
        color: Color(0xFFEA580C),
      ),
      FieldActivityItem(
        title: 'Medição pH',
        lote: 'Lote G-17',
        user: 'Roberto Alves',
        icon: Icons.tune,
        color: Color(0xFF7C3AED),
      ),
      FieldActivityItem(
        title: 'Plantio de Mudas',
        lote: 'Lote H-09',
        user: 'Sandra Lima',
        icon: Icons.local_florist,
        color: Color(0xFF059669),
      ),
    ],
    this.onActivityTap,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;
        final isVerySmallScreen = constraints.maxWidth < 400;

        // Calcula dimensões responsivas
        final horizontalPadding = constraints.maxWidth * 0.05;
        final internalPadding =
            isVerySmallScreen ? 16.0 : (isSmallScreen ? 20.0 : 24.0);

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Container(
            height: constraints.maxHeight, // Usa toda altura disponível
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 20),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 4),
                  color: Colors.black.withValues(alpha: .08),
                  blurRadius: 20,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(internalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(isSmallScreen, isVerySmallScreen),
                  SizedBox(height: isVerySmallScreen ? 12 : 16),
                  Expanded(
                      child: _buildActivitiesList(
                          isSmallScreen, isVerySmallScreen)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(
      [bool isSmallScreen = false, bool isVerySmallScreen = false]) {
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
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: isVerySmallScreen ? 18 : (isSmallScreen ? 20 : 22),
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: isVerySmallScreen ? 2 : 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: isVerySmallScreen ? 12 : 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isVerySmallScreen ? 8 : 12,
            vertical: isVerySmallScreen ? 4 : 6,
          ),
          decoration: BoxDecoration(
            color: Constants.kPrimaryColor.withValues(alpha: .1),
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
              SizedBox(width: isVerySmallScreen ? 2 : 4),
              Text(
                '$todayActivities hoje',
                style: TextStyle(
                  color: Constants.kPrimaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: isVerySmallScreen ? 10 : 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivitiesList(
      [bool isSmallScreen = false, bool isVerySmallScreen = false]) {
    return Column(
      children: [
        // Lista com scroll vertical
        Expanded(
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemCount: activities.length,
            separatorBuilder: (context, index) => SizedBox(
              height: isVerySmallScreen ? 8 : 12,
            ),
            itemBuilder: (context, index) {
              final activity = activities[index];
              return _buildActivityItem(
                  activity, index, isSmallScreen, isVerySmallScreen);
            },
          ),
        ),

        // Botão "Ver caderno completo" fixo na parte inferior
        SizedBox(height: isVerySmallScreen ? 12 : 16),
        _buildViewAllButton(isSmallScreen, isVerySmallScreen),
      ],
    );
  }

  Widget _buildActivityItem(FieldActivityItem activity, int index,
      [bool isSmallScreen = false, bool isVerySmallScreen = false]) {
    return GestureDetector(
      onTap: () => onActivityTap?.call(index),
      child: Container(
        padding: EdgeInsets.all(isVerySmallScreen ? 12 : 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
          border: Border.all(
            color: Colors.grey[100]!,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Activity icon
            Container(
              width: isVerySmallScreen ? 36 : 40,
              height: isVerySmallScreen ? 36 : 40,
              decoration: BoxDecoration(
                color: activity.color.withValues(alpha: .15),
                borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 10),
              ),
              child: Icon(
                activity.icon,
                color: activity.color,
                size: isVerySmallScreen ? 16 : 20,
              ),
            ),
            SizedBox(width: isVerySmallScreen ? 8 : 12),

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
                          style: TextStyle(
                            fontSize: isVerySmallScreen ? 12 : 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: isVerySmallScreen ? 2 : 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: isVerySmallScreen ? 10 : 12,
                        color: Colors.grey[500],
                      ),
                      SizedBox(width: isVerySmallScreen ? 2 : 4),
                      Text(
                        activity.lote,
                        style: TextStyle(
                          fontSize: isVerySmallScreen ? 10 : 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: isVerySmallScreen ? 8 : 12),
                      Icon(
                        Icons.person,
                        size: isVerySmallScreen ? 10 : 12,
                        color: Colors.grey[500],
                      ),
                      SizedBox(width: isVerySmallScreen ? 2 : 4),
                      Expanded(
                        child: Text(
                          activity.user,
                          style: TextStyle(
                            fontSize: isVerySmallScreen ? 10 : 12,
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

  Widget _buildViewAllButton(
      [bool isSmallScreen = false, bool isVerySmallScreen = false]) {
    return GestureDetector(
      onTap: onViewAll,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          vertical: isVerySmallScreen ? 10 : 12,
        ),
        decoration: BoxDecoration(
          color: Constants.kPrimaryColor.withValues(alpha: .05),
          borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 10),
          border: Border.all(
            color: Constants.kPrimaryColor.withValues(alpha: .2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ver caderno completo',
              style: TextStyle(
                color: Constants.kPrimaryColor,
                fontWeight: FontWeight.w600,
                fontSize: isVerySmallScreen ? 12 : 14,
              ),
            ),
            SizedBox(width: isVerySmallScreen ? 2 : 4),
            Icon(
              Icons.arrow_forward_ios,
              color: Constants.kPrimaryColor,
              size: isVerySmallScreen ? 10 : 12,
            ),
          ],
        ),
      ),
    );
  }
}
