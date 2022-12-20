// ignore_for_file: file_names

import 'package:osi_solucoes/features/presenter/models/fertilizante/fertilizante_model.dart'
    show Fertilizante;

class ReposicaoFert {
  final Fertilizante fertilizante;
  final double valor;

  ReposicaoFert({required this.fertilizante, required this.valor});
}
