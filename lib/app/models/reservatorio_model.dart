import 'package:json_annotation/json_annotation.dart';

part 'reservatorio_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Reservatorio {
  @JsonKey(required: false, disallowNullValue: false)
  String? reservatorio;

  @JsonKey(required: false, disallowNullValue: false)
  bool? isSelected;

  Reservatorio({
    this.reservatorio,
    this.isSelected,
  });

  factory Reservatorio.fromJson(Map<String, dynamic> json) =>
      _$ReservatorioFromJson(json);

  Map<String, dynamic> toJson() => _$ReservatorioToJson(this);
}
