// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relatorioStatusLotes_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RelatorioStatusLotes _$RelatorioStatusLotesFromJson(
        Map<String, dynamic> json) =>
    RelatorioStatusLotes(
      title: json['title'] as String?,
      subtitle: json['subtitle'] as String?,
      statusData: (json['statusData'] as List<dynamic>?)
              ?.map((e) => StatusData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$RelatorioStatusLotesToJson(
        RelatorioStatusLotes instance) =>
    <String, dynamic>{
      'title': instance.title,
      'subtitle': instance.subtitle,
      'statusData': instance.statusData?.map((e) => e.toJson()).toList(),
    };

StatusData _$StatusDataFromJson(Map<String, dynamic> json) => StatusData(
      label: json['label'] as String?,
      value: _parseToInt(json['value']),
      color: json['color'] as String?,
      speciesDetails: (json['speciesDetails'] as List<dynamic>?)
              ?.map((e) => SpeciesDetails.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$StatusDataToJson(StatusData instance) =>
    <String, dynamic>{
      'label': instance.label,
      'value': instance.value,
      'color': instance.color,
      'speciesDetails':
          instance.speciesDetails?.map((e) => e.toJson()).toList(),
    };

SpeciesDetails _$SpeciesDetailsFromJson(Map<String, dynamic> json) =>
    SpeciesDetails(
      name: json['name'] as String?,
      percentage: _parseToDouble(json['percentage']),
    );

Map<String, dynamic> _$SpeciesDetailsToJson(SpeciesDetails instance) =>
    <String, dynamic>{
      'name': instance.name,
      'percentage': instance.percentage,
    };
