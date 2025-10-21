// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:osi_solucoes/features/presenter/models/conta/conta_model.dart';
import 'package:osi_solucoes/features/presenter/models/lote/lote_model.dart';

part 'cultura_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Cultura {
  @JsonKey(required: false, disallowNullValue: false)
  int? id;
  @JsonKey(required: false, disallowNullValue: false)
  String? nome;
  @JsonKey(required: false, disallowNullValue: false)
  bool? privado;
  @JsonKey(required: false, disallowNullValue: false)
  DateTime? created_at;
  @JsonKey(required: false, disallowNullValue: false)
  Conta? conta;
  @JsonKey(required: false, disallowNullValue: false)
  List<Lote>? lotes;

  Cultura({
    this.id,
    this.nome,
    this.privado,
    this.created_at,
    this.conta,
    this.lotes,
  });

  factory Cultura.fromJson(Map<String, dynamic> json) =>
      _$CulturaFromJson(json);

  Map<String, dynamic> toJson() => _$CulturaToJson(this);

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'nome': nome,
      'privado': privado,
      'created_at': created_at?.toIso8601String(),
    };
  }
}
