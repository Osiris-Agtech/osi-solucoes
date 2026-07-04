class HomeBasicTipSource {
  static const Map<String, List<String>> tips = {
    'geral': [
      'Mantenha o caderno de campo atualizado para rastreabilidade das operações.',
      'Acompanhe a previsão do tempo para planejar irrigações e colheitas.',
      'Revise as tarefas do dia pela manhã para priorizar o que é crítico.',
      'Lotes com colheita próxima precisam de atenção redobrada na irrigação.',
    ],
    'agenda': [
      'Organizar as tarefas por prioridade ajuda a otimizar o dia de campo.',
      'Tarefas vencidas devem ser reavaliadas antes de criar novas atividades.',
      'Marque tarefas como concluídas assim que finalizar para manter o histórico.',
    ],
    'lote': [
      'Monitore a condutividade elétrica (EC) da solução nutritiva semanalmente.',
      'Lotes ativos com baixa taxa de germinação podem indicar problemas no substrato.',
      'Faça rotação de culturas para preservar a qualidade do solo.',
    ],
    'protocolo': [
      'Protocolos bem definidos garantem consistência entre ciclos de cultivo.',
      'Atualize os protocolos sempre que identificar uma melhoria no processo.',
    ],
    'solucao': [
      'Soluções nutritivas devem ser preparadas com água de qualidade conhecida.',
      'O pH da solução deve ser verificado diariamente para evitar desbalanços.',
    ],
    'reservatorio': [
      'Reservatórios com solução devem ter a CE monitorada regularmente.',
      'Lave os reservatórios entre mudanças de solução para evitar contaminação.',
    ],
    'caderno_campo': [
      'Registre observações de campo assim que possível para não perder detalhes.',
      'Fotos incluídas no caderno de campo enriquecem o histórico do lote.',
    ],
    'cultivo': [
      'A taxa de germinação é um dos primeiros indicadores de sucesso do ciclo.',
      'Colheitas próximas exigem planejamento de mão de obra e logística.',
    ],
  };

  static String getRandomTip(String? category) {
    final key = category ?? 'geral';
    final categoryTips = tips[key] ?? tips['geral']!;
    return categoryTips[DateTime.now().millisecondsSinceEpoch % categoryTips.length];
  }

  static List<String> getTips(String? category, {int count = 3}) {
    final key = category ?? 'geral';
    final categoryTips = tips[key] ?? tips['geral']!;
    return categoryTips.take(count).toList();
  }
}
