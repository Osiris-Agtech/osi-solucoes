// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:osi_solucoes/features/presenter/models/area/area_model.dart';
import 'package:osi_solucoes/features/presenter/models/lote/lote_model.dart';
import 'package:osi_solucoes/features/presenter/models/reservatorio/reservatorio_model.dart';

part 'setor_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Setor {
  @JsonKey(required: false, disallowNullValue: false)
  int? id;

  @JsonKey(required: false, disallowNullValue: false)
  String? nome;

  @JsonKey(required: false, disallowNullValue: false)
  String? descricao;

  @JsonKey(required: false, disallowNullValue: false)
  DateTime? created_at;

  @JsonKey(required: false, disallowNullValue: false)
  Area? area;

  @JsonKey(required: false, disallowNullValue: false)
  Reservatorio? reservatorio;

  @JsonKey(required: false, disallowNullValue: false)
  List<Lote>? lotes;

  Setor({
    this.id,
    this.nome,
    this.descricao,
    this.created_at,
    this.area,
    this.reservatorio,
    this.lotes,
  });

  factory Setor.fromJson(Map<String, dynamic> json) => _$SetorFromJson(json);

  Map<String, dynamic> toJson() => _$SetorToJson(this);
}

// List<Setor> listaEstufas = [
//   Setor(
//       id: 01,
//       nome: "Estufa UFMT",
//       endereco: "Rua França, Maria Joaquina 1, Pontal do Araguaia - MT",
//       setores: 04,
//       lotes: 16),
//   Setor(
//       id: 02,
//       nome: "Estufa FAAZ",
//       endereco: "Rua França, Maria Joaquina 1, Pontal do Araguaia - MT",
//       setores: 04,
//       lotes: 16),
//   Setor(
//       id: 03,
//       nome: "Estufa OSIRIS",
//       endereco: "Rua França, Maria Joaquina 1, Pontal do Araguaia - MT",
//       setores: 04,
//       lotes: 16),
//   Setor(
//       id: 01,
//       nome: "Estufa UFMT",
//       endereco: "Rua França, Maria Joaquina 1, Pontal do Araguaia - MT",
//       setores: 04,
//       lotes: 16),
//   Setor(
//       id: 02,
//       nome: "Estufa FAAZ",
//       endereco: "Rua França, Maria Joaquina 1, Pontal do Araguaia - MT",
//       setores: 04,
//       lotes: 16),
//   Setor(
//       id: 03,
//       nome: "Estufa OSIRIS",
//       endereco: "Rua França, Maria Joaquina 1, Pontal do Araguaia - MT",
//       setores: 04,
//       lotes: 16),
//   Setor(
//       id: 01,
//       nome: "Estufa UFMT",
//       endereco: "Rua França, Maria Joaquina 1, Pontal do Araguaia - MT",
//       setores: 04,
//       lotes: 16),
//   Setor(
//       id: 02,
//       nome: "Estufa FAAZ",
//       endereco: "Rua França, Maria Joaquina 1, Pontal do Araguaia - MT",
//       setores: 04,
//       lotes: 16),
//   Setor(
//       id: 03,
//       nome: "Estufa OSIRIS",
//       endereco: "Rua França, Maria Joaquina 1, Pontal do Araguaia - MT",
//       setores: 04,
//       lotes: 16),
// ];
