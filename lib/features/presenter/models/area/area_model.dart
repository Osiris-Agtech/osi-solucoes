// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:osi_solucoes/features/presenter/models/conta/conta_model.dart';
import 'package:osi_solucoes/features/presenter/models/localizacao/localizacao_model.dart';
import 'package:osi_solucoes/features/presenter/models/setor/setor_model.dart';

part 'area_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Area {
  @JsonKey(required: false, disallowNullValue: false)
  int? id;

  @JsonKey(required: false, disallowNullValue: false)
  String? nome;

  @JsonKey(required: false, disallowNullValue: false)
  String? descricao;

  @JsonKey(required: false, disallowNullValue: false)
  String? imagem;

  @JsonKey(required: false, disallowNullValue: false)
  String? tipo;

  @JsonKey(required: false, disallowNullValue: false)
  DateTime? created_at;

  @JsonKey(required: false, disallowNullValue: false)
  Conta? conta;

  @JsonKey(required: false, disallowNullValue: false)
  Localizacao? localizacao;

  @JsonKey(required: false, disallowNullValue: false)
  List<Setor>? setores;

  Area({
    this.id,
    this.nome,
    this.descricao,
    this.imagem,
    this.tipo,
    this.created_at,
    this.conta,
    this.localizacao,
    this.setores,
  });

  factory Area.fromJson(Map<String, dynamic> json) => _$AreaFromJson(json);

  Map<String, dynamic> toJson() => _$AreaToJson(this);
}



// List<Estufa> listaEstufas = [
//   Estufa(
//       id: 01,
//       nome: "Estufa UFMT",
//       endereco: "Rua França, Maria Joaquina 1, Pontal do Araguaia - MT",
//       setores: 04,
//       lotes: 16),
//   Estufa(
//       id: 02,
//       nome: "Estufa FAAZ",
//       endereco: "Rua França, Maria Joaquina 1, Pontal do Araguaia - MT",
//       setores: 04,
//       lotes: 16),
//   Estufa(
//       id: 03,
//       nome: "Estufa OSIRIS",
//       endereco: "Rua França, Maria Joaquina 1, Pontal do Araguaia - MT",
//       setores: 04,
//       lotes: 16),
//   Estufa(
//       id: 01,
//       nome: "Estufa UFMT",
//       endereco: "Rua França, Maria Joaquina 1, Pontal do Araguaia - MT",
//       setores: 04,
//       lotes: 16),
//   Estufa(
//       id: 02,
//       nome: "Estufa FAAZ",
//       endereco: "Rua França, Maria Joaquina 1, Pontal do Araguaia - MT",
//       setores: 04,
//       lotes: 16),
//   Estufa(
//       id: 03,
//       nome: "Estufa OSIRIS",
//       endereco: "Rua França, Maria Joaquina 1, Pontal do Araguaia - MT",
//       setores: 04,
//       lotes: 16),
//   Estufa(
//       id: 01,
//       nome: "Estufa UFMT",
//       endereco: "Rua França, Maria Joaquina 1, Pontal do Araguaia - MT",
//       setores: 04,
//       lotes: 16),
//   Estufa(
//       id: 02,
//       nome: "Estufa FAAZ",
//       endereco: "Rua França, Maria Joaquina 1, Pontal do Araguaia - MT",
//       setores: 04,
//       lotes: 16),
//   Estufa(
//       id: 03,
//       nome: "Estufa OSIRIS",
//       endereco: "Rua França, Maria Joaquina 1, Pontal do Araguaia - MT",
//       setores: 04,
//       lotes: 16),
// ];
