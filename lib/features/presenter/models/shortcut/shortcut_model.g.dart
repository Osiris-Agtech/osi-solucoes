// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shortcut_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShortcutModel _$ShortcutModelFromJson(Map<String, dynamic> json) =>
    ShortcutModel(
      route: json['route'] as String,
      title: json['title'] as String,
      icon: json['icon'] as String,
      colorHex: json['colorHex'] as String,
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      context: json['context'] as String?,
      resourceId: json['resourceId'] as String?,
      resourceType: json['resourceType'] as String?,
      resourceName: json['resourceName'] as String?,
    );

Map<String, dynamic> _$ShortcutModelToJson(ShortcutModel instance) =>
    <String, dynamic>{
      'route': instance.route,
      'title': instance.title,
      'icon': instance.icon,
      'colorHex': instance.colorHex,
      'confidence': instance.confidence,
      'context': instance.context,
      'resourceId': instance.resourceId,
      'resourceType': instance.resourceType,
      'resourceName': instance.resourceName,
    };
