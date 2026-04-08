import 'package:flutter/material.dart';

/// Badge de alerta com indicador de gravidade
class AlertBadge extends StatelessWidget {
  final String gravidade; // 'alta', 'media', 'baixa'
  final int count;
  final double size;

  const AlertBadge({
    super.key,
    required this.gravidade,
    this.count = 0,
    this.size = 20,
  });

  Color _getGravidadeColor() {
    switch (gravidade) {
      case 'alta':
        return const Color(0xFFDC2626);
      case 'media':
        return const Color(0xFFF59E0B);
      case 'baixa':
        return const Color(0xFF10B981);
      default:
        return Colors.grey;
    }
  }

  IconData _getGravidadeIcon() {
    switch (gravidade) {
      case 'alta':
        return Icons.error;
      case 'media':
        return Icons.warning_amber;
      case 'baixa':
        return Icons.info_outline;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (count == 0) return const SizedBox.shrink();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _getGravidadeColor(),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          count > 9 ? '9+' : count.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

/// Widget de lista de alertas críticos
class AlertList extends StatelessWidget {
  final List<AlertItem> alerts;
  final double maxHeight;

  const AlertList({
    super.key,
    required this.alerts,
    this.maxHeight = 180,
  });

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) return const SizedBox.shrink();

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: alerts.length,
        separatorBuilder: (_, __) => const Divider(height: 8, thickness: 0.5),
        itemBuilder: (context, index) {
          final alert = alerts[index];
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                alert.gravidadeIcon,
                size: 18,
                color: alert.gravidadeColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert.mensagem,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (alert.loteNome != null)
                      Text(
                        alert.loteNome!,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black54,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class AlertItem {
  final String tipo;
  final String mensagem;
  final String? loteNome;
  final String gravidade;

  const AlertItem({
    required this.tipo,
    required this.mensagem,
    this.loteNome,
    required this.gravidade,
  });

  IconData get gravidadeIcon {
    switch (gravidade) {
      case 'alta':
        return Icons.error;
      case 'media':
        return Icons.warning_amber;
      case 'baixa':
        return Icons.info_outline;
      default:
        return Icons.info;
    }
  }

  Color get gravidadeColor {
    switch (gravidade) {
      case 'alta':
        return const Color(0xFFDC2626);
      case 'media':
        return const Color(0xFFF59E0B);
      case 'baixa':
        return const Color(0xFF10B981);
      default:
        return Colors.grey;
    }
  }
}
