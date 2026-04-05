import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'shortcut_model.g.dart';

@JsonSerializable()
class ShortcutModel {
  final String route;
  final String title;
  final String icon;
  final String colorHex; // Armazena cor como hex para serialização
  final double confidence;
  final String? context;
  final String? resourceId;      // ID do recurso específico (lote, reservatório, etc.)
  final String? resourceType;    // Tipo do recurso ('lote', 'reservatorio', 'caderno_campo')
  final String? resourceName;    // Nome do recurso para exibir no atalho

  ShortcutModel({
    required this.route,
    required this.title,
    required this.icon,
    required this.colorHex,
    this.confidence = 0.0,
    this.context,
    this.resourceId,
    this.resourceType,
    this.resourceName,
  });

  Color get color {
    return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
  }

  /// Título a ser exibido no atalho
  /// Se tiver resourceName, mostra "Tipo: Nome do Recurso"
  /// Ex: "Lote: Tomate - Estufa 1"
  String get displayTitle {
    if (resourceName != null && resourceType != null) {
      final typeLabel = _getResourceTypeLabel(resourceType!);
      return '$typeLabel: $resourceName';
    }
    return title;
  }

  String _getResourceTypeLabel(String type) {
    switch (type) {
      case 'lote':
        return 'Lote';
      case 'reservatorio':
        return 'Reservatório';
      case 'caderno_campo':
        return 'Caderno';
      default:
        return type;
    }
  }

  factory ShortcutModel.fromJson(Map<String, dynamic> json) =>
      _$ShortcutModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShortcutModelToJson(this);

  // Factory para criar a partir da resposta do Cloud Function
  factory ShortcutModel.fromCloudResponse(
    String route,
    double confidence,
    Map<String, dynamic> routeConfig, {
    String? resourceId,
    String? resourceType,
    String? resourceName,
  }) {
    return ShortcutModel(
      route: route,
      title: routeConfig['title'] ?? route,
      icon: routeConfig['icon'] ?? 'assets/icons/info_icon.svg',
      colorHex: routeConfig['colorHex'] ?? '#6366F1',
      confidence: confidence,
      context: confidence > 0.7 ? 'frequente' : null,
      resourceId: resourceId,
      resourceType: resourceType,
      resourceName: resourceName,
    );
  }
}
