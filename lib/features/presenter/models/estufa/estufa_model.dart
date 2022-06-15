import 'package:json_annotation/json_annotation.dart';

part 'estufa_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Estufa {
  @JsonKey(required: false, disallowNullValue: false)
  int? id;

  @JsonKey(required: false, disallowNullValue: false)
  String? nome;

  @JsonKey(required: false, disallowNullValue: false)
  String? endereco;

  @JsonKey(required: false, disallowNullValue: false)
  int? setores;

  @JsonKey(required: false, disallowNullValue: false)
  int? lotes;

  Estufa({
    this.id,
    this.nome,
    this.endereco,
    this.setores,
    this.lotes,
  });

  factory Estufa.fromJson(Map<String, dynamic> json) => _$EstufaFromJson(json);

  Map<String, dynamic> toJson() => _$EstufaToJson(this);
}

List<Estufa> listaEstufas = [
  Estufa(
      id: 01,
      nome: "Estufa UFMT",
      endereco: "Rua França, Maria Joaquina 1, Pontal do Araguaia - MT",
      setores: 04,
      lotes: 16),
  Estufa(
      id: 02,
      nome: "Estufa FAAZ",
      endereco: "Rua França, Maria Joaquina 1, Pontal do Araguaia - MT",
      setores: 04,
      lotes: 16),
  Estufa(
      id: 03,
      nome: "Estufa OSIRIS",
      endereco: "Rua França, Maria Joaquina 1, Pontal do Araguaia - MT",
      setores: 04,
      lotes: 16),
  Estufa(
      id: 01,
      nome: "Estufa UFMT",
      endereco: "Rua França, Maria Joaquina 1, Pontal do Araguaia - MT",
      setores: 04,
      lotes: 16),
  Estufa(
      id: 02,
      nome: "Estufa FAAZ",
      endereco: "Rua França, Maria Joaquina 1, Pontal do Araguaia - MT",
      setores: 04,
      lotes: 16),
  Estufa(
      id: 03,
      nome: "Estufa OSIRIS",
      endereco: "Rua França, Maria Joaquina 1, Pontal do Araguaia - MT",
      setores: 04,
      lotes: 16),
  Estufa(
      id: 01,
      nome: "Estufa UFMT",
      endereco: "Rua França, Maria Joaquina 1, Pontal do Araguaia - MT",
      setores: 04,
      lotes: 16),
  Estufa(
      id: 02,
      nome: "Estufa FAAZ",
      endereco: "Rua França, Maria Joaquina 1, Pontal do Araguaia - MT",
      setores: 04,
      lotes: 16),
  Estufa(
      id: 03,
      nome: "Estufa OSIRIS",
      endereco: "Rua França, Maria Joaquina 1, Pontal do Araguaia - MT",
      setores: 04,
      lotes: 16),
];
