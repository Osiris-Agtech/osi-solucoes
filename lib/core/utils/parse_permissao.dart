List<dynamic> parsePermissao(String permissao) {
  List<String> result = [];
  if (permissao.endsWith('view')) {
    result.add('view');
  } else {
    result.add('edit');
  }

  if (permissao.startsWith('area-cultivo-N1')) {
    result.insert(0, 'Cultivo');
    return result;
  }
  if (permissao.startsWith('caderno-campo')) {
    result.insert(0, 'Caderno');
    return result;
  }
  if (permissao.startsWith('solucao-nutritiva')) {
    result.insert(0, 'Solucao');
    return result;
  }
  if (permissao.startsWith('gerencia-equipe')) {
    result.insert(0, 'Equipe');
    return result;
  }
  if (permissao.startsWith('reservatorio')) {
    result.insert(0, 'Reservatório');
    return result;
  }
  return result;
}
