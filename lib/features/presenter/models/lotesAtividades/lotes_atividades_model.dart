// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:sigma_hort_gestao_equipe/features/presenter/models/atividade/atividade_model.dart';
import 'package:sigma_hort_gestao_equipe/features/presenter/models/conta/conta_model.dart';
import 'package:sigma_hort_gestao_equipe/features/presenter/models/lote/lote_model.dart';

import 'package:sigma_hort_gestao_equipe/features/presenter/models/usuario/usuario_model.dart';

part 'lotes_atividades_model.g.dart';

@JsonSerializable(explicitToJson: true)
class LotesAtividades {
  @JsonKey(required: false, disallowNullValue: false)
  int? id;
  @JsonKey(required: false, disallowNullValue: false)
  Atividade? atividade;
  @JsonKey(required: false, disallowNullValue: false)
  Conta? conta;
  @JsonKey(required: false, disallowNullValue: false)
  Lote? lote;
  @JsonKey(required: false, disallowNullValue: false)
  Usuario? usuario;

  LotesAtividades({
    this.id,
    this.atividade,
    this.conta,
    this.lote,
    this.usuario,
  });

  factory LotesAtividades.fromJson(Map<String, dynamic> json) =>
      _$LotesAtividadesFromJson(json);

  Map<String, dynamic> toJson() => _$LotesAtividadesToJson(this);
}
