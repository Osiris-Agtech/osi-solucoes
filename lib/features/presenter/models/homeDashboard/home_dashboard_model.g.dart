// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeDashboard _$HomeDashboardFromJson(Map<String, dynamic> json) =>
    HomeDashboard(
      resumo: json['resumo'] == null
          ? null
          : HomeResumo.fromJson(json['resumo'] as Map<String, dynamic>),
      tarefas: json['tarefas'] == null
          ? null
          : HomeTarefas.fromJson(json['tarefas'] as Map<String, dynamic>),
      producao: json['producao'] == null
          ? null
          : HomeProducao.fromJson(json['producao'] as Map<String, dynamic>),
      culturas: (json['culturas'] as List<dynamic>?)
          ?.map((e) => HomeCultura.fromJson(e as Map<String, dynamic>))
          .toList(),
      equipe: json['equipe'] == null
          ? null
          : HomeEquipeResumo.fromJson(json['equipe'] as Map<String, dynamic>),
      alertasCritico: (json['alertasCritico'] as List<dynamic>?)
          ?.map((e) => HomeAlertaCritico.fromJson(e as Map<String, dynamic>))
          .toList(),
      infoContext: json['infoContext'] == null
          ? null
          : HomeInfoContext.fromJson(
              json['infoContext'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HomeDashboardToJson(HomeDashboard instance) =>
    <String, dynamic>{
      'resumo': instance.resumo?.toJson(),
      'tarefas': instance.tarefas?.toJson(),
      'producao': instance.producao?.toJson(),
      'culturas': instance.culturas?.map((e) => e.toJson()).toList(),
      'equipe': instance.equipe?.toJson(),
      'alertasCritico':
          instance.alertasCritico?.map((e) => e.toJson()).toList(),
      'infoContext': instance.infoContext?.toJson(),
    };

HomeResumo _$HomeResumoFromJson(Map<String, dynamic> json) => HomeResumo(
      totalLotes: (json['totalLotes'] as num?)?.toInt(),
      lotesAtivos: (json['lotesAtivos'] as num?)?.toInt(),
      lotesFinalizados: (json['lotesFinalizados'] as num?)?.toInt(),
      taxaConclusao: (json['taxaConclusao'] as num?)?.toDouble(),
      lotesPorStatus: (json['lotesPorStatus'] as List<dynamic>?)
          ?.map((e) => HomeLoteStatus.fromJson(e as Map<String, dynamic>))
          .toList(),
      lotesComColheitaProxima:
          (json['lotesComColheitaProxima'] as num?)?.toInt(),
      especiesEmAndamento: (json['especiesEmAndamento'] as List<dynamic>?)
          ?.map((e) => HomeEspecieDetalhe.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HomeResumoToJson(HomeResumo instance) =>
    <String, dynamic>{
      'totalLotes': instance.totalLotes,
      'lotesAtivos': instance.lotesAtivos,
      'lotesFinalizados': instance.lotesFinalizados,
      'taxaConclusao': instance.taxaConclusao,
      'lotesPorStatus': instance.lotesPorStatus,
      'lotesComColheitaProxima': instance.lotesComColheitaProxima,
      'especiesEmAndamento': instance.especiesEmAndamento,
    };

HomeTarefas _$HomeTarefasFromJson(Map<String, dynamic> json) => HomeTarefas(
      pendentesHoje: (json['pendentesHoje'] as num?)?.toInt(),
      pendentesSemana: (json['pendentesSemana'] as num?)?.toInt(),
      atrasadas: (json['atrasadas'] as num?)?.toInt(),
      porVencimento: json['porVencimento'] == null
          ? null
          : HomeTarefasPorVencimento.fromJson(
              json['porVencimento'] as Map<String, dynamic>),
      porPrioridade: json['porPrioridade'] == null
          ? null
          : HomeTarefasPorPrioridade.fromJson(
              json['porPrioridade'] as Map<String, dynamic>),
      ultimasTarefas: (json['ultimasTarefas'] as List<dynamic>?)
          ?.map((e) => HomeTarefaDetalhe.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HomeTarefasToJson(HomeTarefas instance) =>
    <String, dynamic>{
      'pendentesHoje': instance.pendentesHoje,
      'pendentesSemana': instance.pendentesSemana,
      'atrasadas': instance.atrasadas,
      'porVencimento': instance.porVencimento,
      'porPrioridade': instance.porPrioridade,
      'ultimasTarefas': instance.ultimasTarefas,
    };

HomeProducao _$HomeProducaoFromJson(Map<String, dynamic> json) => HomeProducao(
      totalPlantasColhidas: (json['totalPlantasColhidas'] as num?)?.toInt(),
      totalEmbalagensProduzidas:
          (json['totalEmbalagensProduzidas'] as num?)?.toInt(),
      lotesComColheitaProxima:
          (json['lotesComColheitaProxima'] as num?)?.toInt(),
      periodoInicio: json['periodoInicio'] as String?,
      periodoFim: json['periodoFim'] as String?,
      producaoMensal: (json['producaoMensal'] as List<dynamic>?)
          ?.map((e) => HomeProducaoMensal.fromJson(e as Map<String, dynamic>))
          .toList(),
      taxasMedia: json['taxasMedia'] == null
          ? null
          : HomeTaxasMedia.fromJson(json['taxasMedia'] as Map<String, dynamic>),
      comparativoPeriodo: json['comparativoPeriodo'] == null
          ? null
          : HomeComparativoPeriodo.fromJson(
              json['comparativoPeriodo'] as Map<String, dynamic>),
      culturaMaisProducao: json['culturaMaisProducao'] == null
          ? null
          : HomeCulturaDestaque.fromJson(
              json['culturaMaisProducao'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HomeProducaoToJson(HomeProducao instance) =>
    <String, dynamic>{
      'totalPlantasColhidas': instance.totalPlantasColhidas,
      'totalEmbalagensProduzidas': instance.totalEmbalagensProduzidas,
      'lotesComColheitaProxima': instance.lotesComColheitaProxima,
      'periodoInicio': instance.periodoInicio,
      'periodoFim': instance.periodoFim,
      'producaoMensal': instance.producaoMensal,
      'taxasMedia': instance.taxasMedia,
      'comparativoPeriodo': instance.comparativoPeriodo,
      'culturaMaisProducao': instance.culturaMaisProducao,
    };

HomeCultura _$HomeCulturaFromJson(Map<String, dynamic> json) => HomeCultura(
      nome: json['nome'] as String?,
      quantidade: (json['quantidade'] as num?)?.toInt(),
      cor: json['cor'] as String?,
    );

Map<String, dynamic> _$HomeCulturaToJson(HomeCultura instance) =>
    <String, dynamic>{
      'nome': instance.nome,
      'quantidade': instance.quantidade,
      'cor': instance.cor,
    };

HomeLoteStatus _$HomeLoteStatusFromJson(Map<String, dynamic> json) =>
    HomeLoteStatus(
      status: json['status'] as String?,
      quantidade: (json['quantidade'] as num?)?.toInt(),
      cor: json['cor'] as String?,
    );

Map<String, dynamic> _$HomeLoteStatusToJson(HomeLoteStatus instance) =>
    <String, dynamic>{
      'status': instance.status,
      'quantidade': instance.quantidade,
      'cor': instance.cor,
    };

HomeEspecieDetalhe _$HomeEspecieDetalheFromJson(Map<String, dynamic> json) =>
    HomeEspecieDetalhe(
      nome: json['nome'] as String?,
      percentual: (json['percentual'] as num?)?.toDouble(),
      status: json['status'] as String?,
    );

Map<String, dynamic> _$HomeEspecieDetalheToJson(HomeEspecieDetalhe instance) =>
    <String, dynamic>{
      'nome': instance.nome,
      'percentual': instance.percentual,
      'status': instance.status,
    };

HomeProducaoMensal _$HomeProducaoMensalFromJson(Map<String, dynamic> json) =>
    HomeProducaoMensal(
      mes: json['mes'] as String?,
      quantidade: (json['quantidade'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$HomeProducaoMensalToJson(HomeProducaoMensal instance) =>
    <String, dynamic>{
      'mes': instance.mes,
      'quantidade': instance.quantidade,
    };

HomeTaxasMedia _$HomeTaxasMediaFromJson(Map<String, dynamic> json) =>
    HomeTaxasMedia(
      taxaGerminacao: (json['taxaGerminacao'] as num?)?.toDouble(),
      taxaTransplantio: (json['taxaTransplantio'] as num?)?.toDouble(),
      taxaEmbalagem: (json['taxaEmbalagem'] as num?)?.toDouble(),
      taxaGlobal: (json['taxaGlobal'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$HomeTaxasMediaToJson(HomeTaxasMedia instance) =>
    <String, dynamic>{
      'taxaGerminacao': instance.taxaGerminacao,
      'taxaTransplantio': instance.taxaTransplantio,
      'taxaEmbalagem': instance.taxaEmbalagem,
      'taxaGlobal': instance.taxaGlobal,
    };

HomeComparativoPeriodo _$HomeComparativoPeriodoFromJson(
        Map<String, dynamic> json) =>
    HomeComparativoPeriodo(
      plantasColhidas: (json['plantasColhidas'] as num?)?.toInt(),
      variacaoPercentual: (json['variacaoPercentual'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$HomeComparativoPeriodoToJson(
        HomeComparativoPeriodo instance) =>
    <String, dynamic>{
      'plantasColhidas': instance.plantasColhidas,
      'variacaoPercentual': instance.variacaoPercentual,
    };

HomeCulturaDestaque _$HomeCulturaDestaqueFromJson(Map<String, dynamic> json) =>
    HomeCulturaDestaque(
      nome: json['nome'] as String?,
      quantidade: (json['quantidade'] as num?)?.toInt(),
      percentualDoTotal: (json['percentualDoTotal'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$HomeCulturaDestaqueToJson(
        HomeCulturaDestaque instance) =>
    <String, dynamic>{
      'nome': instance.nome,
      'quantidade': instance.quantidade,
      'percentualDoTotal': instance.percentualDoTotal,
    };

HomeEquipeResumo _$HomeEquipeResumoFromJson(Map<String, dynamic> json) =>
    HomeEquipeResumo(
      membrosAtivos: (json['membrosAtivos'] as num?)?.toInt(),
      taxaConclusaoMedia: (json['taxaConclusaoMedia'] as num?)?.toDouble(),
      atividadesNoPrazo: (json['atividadesNoPrazo'] as num?)?.toInt(),
      atividadesVencidas: (json['atividadesVencidas'] as num?)?.toInt(),
    );

Map<String, dynamic> _$HomeEquipeResumoToJson(HomeEquipeResumo instance) =>
    <String, dynamic>{
      'membrosAtivos': instance.membrosAtivos,
      'taxaConclusaoMedia': instance.taxaConclusaoMedia,
      'atividadesNoPrazo': instance.atividadesNoPrazo,
      'atividadesVencidas': instance.atividadesVencidas,
    };

HomeTarefaDetalhe _$HomeTarefaDetalheFromJson(Map<String, dynamic> json) =>
    HomeTarefaDetalhe(
      id: (json['id'] as num?)?.toInt(),
      titulo: json['titulo'] as String?,
      loteNome: json['loteNome'] as String?,
      data: json['data'] as String?,
      vencida: json['vencida'] as bool?,
    );

Map<String, dynamic> _$HomeTarefaDetalheToJson(HomeTarefaDetalhe instance) =>
    <String, dynamic>{
      'id': instance.id,
      'titulo': instance.titulo,
      'loteNome': instance.loteNome,
      'data': instance.data,
      'vencida': instance.vencida,
    };

HomeTarefasPorVencimento _$HomeTarefasPorVencimentoFromJson(
        Map<String, dynamic> json) =>
    HomeTarefasPorVencimento(
      hoje: (json['hoje'] as num?)?.toInt(),
      estaSemana: (json['estaSemana'] as num?)?.toInt(),
      proximaSemana: (json['proximaSemana'] as num?)?.toInt(),
    );

Map<String, dynamic> _$HomeTarefasPorVencimentoToJson(
        HomeTarefasPorVencimento instance) =>
    <String, dynamic>{
      'hoje': instance.hoje,
      'estaSemana': instance.estaSemana,
      'proximaSemana': instance.proximaSemana,
    };

HomeTarefasPorPrioridade _$HomeTarefasPorPrioridadeFromJson(
        Map<String, dynamic> json) =>
    HomeTarefasPorPrioridade(
      alta: (json['alta'] as num?)?.toInt(),
      media: (json['media'] as num?)?.toInt(),
      baixa: (json['baixa'] as num?)?.toInt(),
    );

Map<String, dynamic> _$HomeTarefasPorPrioridadeToJson(
        HomeTarefasPorPrioridade instance) =>
    <String, dynamic>{
      'alta': instance.alta,
      'media': instance.media,
      'baixa': instance.baixa,
    };

HomeAlertaCritico _$HomeAlertaCriticoFromJson(Map<String, dynamic> json) =>
    HomeAlertaCritico(
      tipo: json['tipo'] as String?,
      mensagem: json['mensagem'] as String?,
      loteId: (json['loteId'] as num?)?.toInt(),
      loteNome: json['loteNome'] as String?,
      gravidade: json['gravidade'] as String?,
      data: json['data'] as String?,
    );

Map<String, dynamic> _$HomeAlertaCriticoToJson(HomeAlertaCritico instance) =>
    <String, dynamic>{
      'tipo': instance.tipo,
      'mensagem': instance.mensagem,
      'loteId': instance.loteId,
      'loteNome': instance.loteNome,
      'gravidade': instance.gravidade,
      'data': instance.data,
    };
