// ignore_for_file: avoid_print

import "package:json_annotation/json_annotation.dart";

part "relatorioProducao_model.g.dart";

// Função helper para converter String para int
// ignore: unused_element
int? _parseToInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) {
    return int.tryParse(value);
  }
  if (value is double) return value.toInt();
  return null;
}

// Função helper para converter String para double
double? _parseToDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) {
    return double.tryParse(value);
  }
  return null;
}

@JsonSerializable(explicitToJson: true)
class RelatorioProducao {
  @JsonKey(required: false, disallowNullValue: false)
  String? title;

  @JsonKey(required: false, disallowNullValue: false)
  String? subtitle;

  @JsonKey(required: false, disallowNullValue: false)
  String? totalUnit;

  @JsonKey(required: false, disallowNullValue: false, defaultValue: [])
  List<String>? months;

  @JsonKey(required: false, disallowNullValue: false, defaultValue: [])
  List<double>? monthlyData;

  @JsonKey(required: false, disallowNullValue: false, defaultValue: [])
  List<CultureData>? cultureData;

  RelatorioProducao({
    this.title,
    this.subtitle,
    this.totalUnit,
    this.months,
    this.monthlyData,
    this.cultureData,
  });

  factory RelatorioProducao.fromJson(Map<String, dynamic> json) {
    try {
      // Remove __typename se existir
      json.remove('__typename');

      // Processar monthlyData para garantir que seja List<double>
      if (json['monthlyData'] != null) {
        json['monthlyData'] = (json['monthlyData'] as List)
            .map((item) => _parseToDouble(item) ?? 0.0)
            .toList();
      }

      print('🔍 RelatorioProducao JSON: $json');
      return _$RelatorioProducaoFromJson(json);
    } catch (e) {
      print('❌ Erro na conversão RelatorioProducao: $e');
      print('📋 JSON problemático: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => _$RelatorioProducaoToJson(this);

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "subtitle": subtitle,
      "totalUnit": totalUnit,
      "months": months,
      "monthlyData": monthlyData,
      "cultureData": cultureData?.map((data) => data.toMap()).toList(),
    };
  }

  @override
  String toString() {
    return 'RelatorioProducao{title: $title, subtitle: $subtitle, totalUnit: $totalUnit, months: ${months?.length} items, monthlyData: ${monthlyData?.length} items, cultureData: ${cultureData?.length} items}';
  }
}

@JsonSerializable(explicitToJson: true)
class CultureData {
  @JsonKey(required: false, disallowNullValue: false)
  String? name;

  @JsonKey(required: false, disallowNullValue: false)
  String? color;

  @JsonKey(
    required: false,
    disallowNullValue: false,
    fromJson: _parseToDouble,
  )
  double? value;

  CultureData({
    this.name,
    this.color,
    this.value,
  });

  factory CultureData.fromJson(Map<String, dynamic> json) {
    try {
      // Remove __typename se existir
      json.remove('__typename');
      print('🔍 CultureData JSON: $json');
      return _$CultureDataFromJson(json);
    } catch (e) {
      print('❌ Erro na conversão CultureData: $e');
      print('📋 JSON problemático: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => _$CultureDataToJson(this);

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "color": color,
      "value": value,
    };
  }

  @override
  String toString() {
    return 'CultureData{name: $name, color: $color, value: $value}';
  }
}
