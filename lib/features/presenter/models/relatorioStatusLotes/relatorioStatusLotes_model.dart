import "package:json_annotation/json_annotation.dart";

part "relatorioStatusLotes_model.g.dart";

// Função helper para converter String para int
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
class RelatorioStatusLotes {
  @JsonKey(required: false, disallowNullValue: false)
  String? title;

  @JsonKey(required: false, disallowNullValue: false)
  String? subtitle;

  @JsonKey(required: false, disallowNullValue: false, defaultValue: [])
  List<StatusData>? statusData;

  RelatorioStatusLotes({
    this.title,
    this.subtitle,
    this.statusData,
  });

  factory RelatorioStatusLotes.fromJson(Map<String, dynamic> json) {
    try {
      // Remove __typename se existir
      json.remove('__typename');
      print('🔍 RelatorioStatusLotes JSON: $json');
      return _$RelatorioStatusLotesFromJson(json);
    } catch (e) {
      print('❌ Erro na conversão RelatorioStatusLotes: $e');
      print('📋 JSON problemático: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => _$RelatorioStatusLotesToJson(this);

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "subtitle": subtitle,
      "statusData": statusData?.map((data) => data.toMap()).toList(),
    };
  }

  @override
  String toString() {
    return 'RelatorioStatusLotes{title: $title, subtitle: $subtitle, statusData: ${statusData?.length} items}';
  }
}

@JsonSerializable(explicitToJson: true)
class StatusData {
  @JsonKey(required: false, disallowNullValue: false)
  String? label;

  @JsonKey(
    required: false,
    disallowNullValue: false,
    fromJson: _parseToInt,
  )
  int? value;

  @JsonKey(required: false, disallowNullValue: false)
  String? color;

  @JsonKey(required: false, disallowNullValue: false, defaultValue: [])
  List<SpeciesDetails>? speciesDetails;

  StatusData({
    this.label,
    this.value,
    this.color,
    this.speciesDetails,
  });

  factory StatusData.fromJson(Map<String, dynamic> json) {
    try {
      // Remove __typename se existir
      json.remove('__typename');
      print('🔍 StatusData JSON: $json');
      return _$StatusDataFromJson(json);
    } catch (e) {
      print('❌ Erro na conversão StatusData: $e');
      print('📋 JSON problemático: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => _$StatusDataToJson(this);

  Map<String, dynamic> toMap() {
    return {
      "label": label,
      "value": value,
      "color": color,
      "speciesDetails":
          speciesDetails?.map((species) => species.toMap()).toList(),
    };
  }

  @override
  String toString() {
    return 'StatusData{label: $label, value: $value, color: $color, speciesDetails: ${speciesDetails?.length} items}';
  }
}

@JsonSerializable(explicitToJson: true)
class SpeciesDetails {
  @JsonKey(required: false, disallowNullValue: false)
  String? name;

  @JsonKey(
    required: false,
    disallowNullValue: false,
    fromJson: _parseToDouble,
  )
  double? percentage;

  SpeciesDetails({
    this.name,
    this.percentage,
  });

  factory SpeciesDetails.fromJson(Map<String, dynamic> json) {
    try {
      // Remove __typename se existir
      json.remove('__typename');
      print('🔍 SpeciesDetails JSON: $json');
      return _$SpeciesDetailsFromJson(json);
    } catch (e) {
      print('❌ Erro na conversão SpeciesDetails: $e');
      print('📋 JSON problemático: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => _$SpeciesDetailsToJson(this);

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "percentage": percentage,
    };
  }

  @override
  String toString() {
    return 'SpeciesDetails{name: $name, percentage: $percentage}';
  }
}
