// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cargo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cargo _$CargoFromJson(Map<String, dynamic> json) => Cargo(
      id: _parseToInt(json['id']),
      cargo: json['cargo'] as String?,
      permissoes: (json['permissoes'] as List<dynamic>?)
          ?.map((e) => CargoPermissao.fromJson(e as Map<String, dynamic>))
          .toList(),
      usuarios: (json['usuarios'] as List<dynamic>?)
          ?.map((e) => ConectaConta.fromJson(e as Map<String, dynamic>))
          .toList(),
      concatenatedPermission: (json['concatenatedPermission'] as List<dynamic>?)
              ?.map((e) =>
                  ConcatenatedPermission.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$CargoToJson(Cargo instance) => <String, dynamic>{
      'id': instance.id,
      'cargo': instance.cargo,
      'permissoes': instance.permissoes?.map((e) => e.toJson()).toList(),
      'usuarios': instance.usuarios?.map((e) => e.toJson()).toList(),
      'concatenatedPermission':
          instance.concatenatedPermission?.map((e) => e.toJson()).toList(),
    };

ConcatenatedPermission _$ConcatenatedPermissionFromJson(
        Map<String, dynamic> json) =>
    ConcatenatedPermission(
      title: json['title'] as String?,
      permissionRead: json['permissionRead'] == null
          ? false
          : _parseToBool(json['permissionRead']),
      permissionWrite: json['permissionWrite'] == null
          ? false
          : _parseToBool(json['permissionWrite']),
    );

Map<String, dynamic> _$ConcatenatedPermissionToJson(
        ConcatenatedPermission instance) =>
    <String, dynamic>{
      'title': instance.title,
      'permissionWrite': instance.permissionWrite,
      'permissionRead': instance.permissionRead,
    };
