// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:osi_solucoes/features/presenter/models/acao/acao_model.dart';
import 'package:osi_solucoes/features/presenter/models/conta/conta_model.dart';
import 'package:osi_solucoes/features/presenter/models/cultura/cultura_model.dart';
import 'package:osi_solucoes/features/presenter/models/lote/lote_model.dart';

part 'protocolo_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Protocolo {
  @JsonKey(required: false, disallowNullValue: false)
  int? id;
  @JsonKey(required: false, disallowNullValue: false)
  String? nome;
  @JsonKey(required: false, disallowNullValue: false)
  String? descricao;
  @JsonKey(required: false, disallowNullValue: false)
  String? tipo_cultura;
  @JsonKey(required: false, disallowNullValue: false)
  String? sistema_cultivo;
  @JsonKey(required: false, disallowNullValue: false)
  String? implantacao;
  @JsonKey(required: false, disallowNullValue: false)
  DateTime? created_at;
  @JsonKey(required: false, disallowNullValue: false)
  DateTime? updated_at;
  @JsonKey(required: false, disallowNullValue: false)
  DateTime? deleted_at;
  @JsonKey(required: false, disallowNullValue: false, name: 'acoes')
  List<Acao>? acao;
  @JsonKey(required: false, disallowNullValue: false)
  Cultura? cultura;
  @JsonKey(required: false, disallowNullValue: false)
  Conta? conta;
  @JsonKey(required: false, disallowNullValue: false, defaultValue: [])
  List<Lote> lotes;

  Protocolo({
    this.id,
    this.nome,
    this.descricao,
    this.implantacao,
    this.tipo_cultura,
    this.sistema_cultivo,
    this.created_at,
    this.updated_at,
    this.deleted_at,
    this.conta,
    this.acao,
    this.cultura,
    this.lotes = const [],
  });

  factory Protocolo.fromJson(Map<String, dynamic> json) =>
      _$ProtocoloFromJson(json);

  Map<String, dynamic> toJson() => _$ProtocoloToJson(this);
}
