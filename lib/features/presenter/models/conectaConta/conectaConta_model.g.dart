// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conectaConta_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConectaConta _$ConectaContaFromJson(Map<String, dynamic> json) => ConectaConta(
      id: _parseToInt(json['id']),
      cargo: json['cargo'] == null
          ? null
          : Cargo.fromJson(json['cargo'] as Map<String, dynamic>),
      conta: json['conta'] == null
          ? null
          : Conta.fromJson(json['conta'] as Map<String, dynamic>),
      usuario: json['usuario'] == null
          ? null
          : Usuario.fromJson(json['usuario'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ConectaContaToJson(ConectaConta instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cargo': instance.cargo?.toJson(),
      'conta': instance.conta?.toJson(),
      'usuario': instance.usuario?.toJson(),
    };
