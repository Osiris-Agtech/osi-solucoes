// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cargo_permissao_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CargoPermissao _$CargoPermissaoFromJson(Map<String, dynamic> json) =>
    CargoPermissao(
      id: (json['id'] as num?)?.toInt(),
      cargo: json['cargo'] == null
          ? null
          : Cargo.fromJson(json['cargo'] as Map<String, dynamic>),
      permissao: json['permissao'] == null
          ? null
          : Permissao.fromJson(json['permissao'] as Map<String, dynamic>),
      status: json['status'] as bool?,
    );

Map<String, dynamic> _$CargoPermissaoToJson(CargoPermissao instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cargo': instance.cargo?.toJson(),
      'permissao': instance.permissao?.toJson(),
      'status': instance.status,
    };
