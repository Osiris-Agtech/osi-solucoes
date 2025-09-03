// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relatorioProducao_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RelatorioProducao _$RelatorioProducaoFromJson(Map<String, dynamic> json) =>
    RelatorioProducao(
      title: json['title'] as String?,
      subtitle: json['subtitle'] as String?,
      totalUnit: json['totalUnit'] as String?,
      months: (json['months'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      monthlyData: (json['monthlyData'] as List<dynamic>?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
      cultureData: (json['cultureData'] as List<dynamic>?)
              ?.map((e) => CultureData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$RelatorioProducaoToJson(RelatorioProducao instance) =>
    <String, dynamic>{
      'title': instance.title,
      'subtitle': instance.subtitle,
      'totalUnit': instance.totalUnit,
      'months': instance.months,
      'monthlyData': instance.monthlyData,
      'cultureData': instance.cultureData?.map((e) => e.toJson()).toList(),
    };

CultureData _$CultureDataFromJson(Map<String, dynamic> json) => CultureData(
      name: json['name'] as String?,
      color: json['color'] as String?,
      value: _parseToDouble(json['value']),
    );

Map<String, dynamic> _$CultureDataToJson(CultureData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'color': instance.color,
      'value': instance.value,
    };
