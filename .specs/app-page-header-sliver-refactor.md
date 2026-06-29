# Refatoração conservadora de `AppPageHeaderSliver`

## Contexto

`AppPageHeaderSliver` é o header compartilhado em `lib/features/presenter/widgets/common/app_page_header_sliver.dart` e já é usado por múltiplas telas operacionais, incluindo Agenda, Detalhes do Reservatório e Relatórios.

O usuário solicitou refatorar primeiro apenas esse componente para resolver overflow e espaçamento do header nessas telas, sem implementar alterações diretas nas páginas consumidoras neste momento. A motivação é estabilizar um componente comum pequeno antes de ampliar padronizações visuais em outras áreas.

O componente atual usa `SliverAppBar` com `expandedHeight` e `toolbarHeight` iguais, `actions` nativas do app bar e conteúdo customizado em `flexibleSpace`. Essa composição cria risco de colisão entre título/subtítulo, botão de voltar, ações e área inferior, especialmente quando textos crescem, quando há menu de ações em Detalhes do Reservatório ou quando o header aparece em telas com densidade diferente como Agenda e Relatórios.

Esta especificação cobre o comportamento esperado e as restrições da refatoração futura. Não inclui implementação de código de produto.

## Objetivos

- Eliminar overflow visual do header em Agenda, Detalhes do Reservatório e Relatórios.
- Corrigir espaçamento vertical e horizontal do header mantendo aparência conservadora e familiar.
- Preservar a API pública existente de `AppPageHeaderSliver` para evitar migração obrigatória dos consumidores atuais.
- Manter `AppPageHeaderSliver` como componente presenter comum e puro, sem conhecer stores, rotas, models ou regras das telas.
- Melhorar robustez para títulos/subtítulos longos, ações à direita, botão de voltar e `bottom` opcional.
- Evitar transformar o componente em scaffold, shell global ou abstração de navegação.

## Fora de escopo

- Implementar código de produto nesta etapa.
- Refatorar Agenda, Detalhes do Reservatório, Relatórios ou outras telas consumidoras, salvo ajustes mínimos futuros caso a validação prove indispensável.
- Alterar stores, rotas, services, models, contratos de API ou regras de negócio.
- Criar novo design system, tema global, barrel export ou camada em `core/widgets`.
- Redesenhar visualmente as páginas consumidoras.
- Alterar semântica de navegação de `onBack`, `leading` ou `actions`.
- Remover parâmetros públicos já existentes do componente.
- Introduzir analytics, logs, i18n, testes novos ou infraestrutura nova sem solicitação específica.

## Abordagem técnica e decisões de design

### Direção geral

A refatoração deve ser local e conservadora: reorganizar a composição interna de `AppPageHeaderSliver` para lidar melhor com espaço disponível, preservando a assinatura atual e os valores padrão sempre que possível.

A mudança deve priorizar layout resiliente sobre novos recursos. Qualquer parâmetro novo só deve ser adicionado se for opcional, com default compatível e justificado por uso real.

### Decisões obrigatórias

- Preservar o nome, construtor e parâmetros públicos existentes:
  - `title`
  - `subtitle`
  - `leading`
  - `onBack`
  - `actions`
  - `bottom`
  - `backgroundColor`
  - `expandedHeight`
  - `pinned`
  - `floating`
  - `titleMaxLines`
  - `subtitleMaxLines`
- Manter comportamento de prioridade atual: `leading` customizado tem precedência sobre `onBack`.
- Manter `actions` como entrada visual genérica; o componente não deve interpretar ações nem executar navegação.
- Usar somente dados e widgets recebidos por props e constantes visuais existentes.
- Reorganizar internamente para que texto e ações disputem espaço de forma controlada, com `Expanded`/`Flexible`, constraints, ellipsis e áreas de toque previsíveis.
- Tratar `bottom` como parte real da altura e do padding, evitando que conteúdo textual fique encoberto ou comprimido.
- Preservar o uso em `CustomScrollView` como sliver.

### Recomendações de layout interno para implementação futura

- Separar a linha de navegação/ações da área textual quando necessário, em vez de empilhar tudo em uma única coluna rígida.
- Reservar espaço horizontal para `actions` sem sobrepor título/subtítulo.
- Aplicar `SafeArea(top: true, bottom: false)` sem duplicar safe area com telas que já usam `SafeArea` externo.
- Evitar `toolbarHeight` rigidamente igual a `expandedHeight` se isso contribuir para colisões com `flexibleSpace`; a implementação deve verificar a forma mais simples e compatível com `SliverAppBar`.
- Calcular altura efetiva considerando `bottom.preferredSize.height`, top safe area e densidade mínima do conteúdo.
- Usar padding responsivo simples e estável, preferindo valores já praticados no app (`16` horizontal e espaçamento vertical compacto) em vez de proporções da tela.
- Garantir que textos usem `maxLines` e `TextOverflow.ellipsis` conforme os parâmetros existentes.
- Manter títulos com hierarquia semelhante à atual: título destacado e subtítulo secundário.

## Estruturas e interfaces envolvidas

### Componente alvo

Arquivo primário:

```text
lib/features/presenter/widgets/common/app_page_header_sliver.dart
```

Interface pública atual a preservar conceitualmente:

```text
AppPageHeaderSliver({
  required String title,
  String? subtitle,
  Widget? leading,
  VoidCallback? onBack,
  List<Widget> actions = const [],
  PreferredSizeWidget? bottom,
  Color backgroundColor = Colors.white,
  double expandedHeight = 120,
  bool pinned = false,
  bool floating = true,
  int titleMaxLines = 1,
  int subtitleMaxLines = 1,
})
```

### Consumidores prioritários para validação

- `lib/features/presenter/views/agenda/agenda_page.dart`
  - Usa título `Agenda`, subtítulo curto e `onBack`.
- `lib/features/presenter/views/reservatorio/detalhes_reservatorio_page.dart`
  - Usa título dinâmico do reservatório, subtítulo com volume, `onBack` e `actions` com `PopupMenuButton`.
- `lib/features/presenter/views/relatorios/relatorios_page.dart`
  - Usa título `Relatórios`, subtítulo curto e `onBack`.

### Outros consumidores afetados indiretamente

A refatoração pode impactar qualquer tela que usa `AppPageHeaderSliver`, como Caderno de Campo, Histórico, Solução, Reservatórios, Protocolo, Área de Cultivo e Gerenciar Equipe. A compatibilidade visual deve ser preservada por default.

## Requisitos verificáveis

1. O componente não deve apresentar overflow renderizado pelo Flutter em Agenda, Detalhes do Reservatório e Relatórios em larguras mobile comuns.
2. O título deve continuar visível e truncado com ellipsis quando exceder `titleMaxLines`.
3. O subtítulo deve continuar visível e truncado com ellipsis quando exceder `subtitleMaxLines`.
4. Quando `actions` existir, a área de ações não deve sobrepor título, subtítulo ou botão de voltar.
5. Quando `onBack` existir e `leading` não existir, o botão de voltar deve permanecer acessível e visualmente alinhado.
6. Quando `leading` existir, ele deve continuar substituindo o botão padrão de `onBack`.
7. Quando `bottom` existir, o conteúdo principal do header não deve ficar encoberto pela área inferior.
8. Os defaults atuais devem continuar permitindo chamadas existentes sem alteração nos consumidores.
9. A refatoração não deve introduzir dependência de stores, `Get`, `GetIt`, rotas, services ou models no componente comum.
10. A mudança deve se limitar ao componente comum, exceto se uma validação futura demonstrar ajuste consumidor mínimo e inevitável.

## Restrições de arquitetura e acoplamento

- `AppPageHeaderSliver` deve permanecer em `lib/features/presenter/widgets/common/`.
- O componente deve continuar sendo um widget presenter puro.
- Entradas permitidas: strings, widgets, callbacks, cores, flags e `PreferredSizeWidget`.
- Saídas permitidas: callbacks já recebidos, como `onBack` ou ações externas passadas por `actions`.
- Não permitido: acessar stores MobX, service locators, navegação direta, models de domínio, storage, API ou regras específicas de Agenda/Reservatórios/Relatórios.
- Não permitido: criar abstração global de scaffold ou acoplar o header a uma feature específica.
- Não permitido: alterar contratos públicos de páginas ou componentes consumidores como parte desta refatoração.

## Riscos

- Ajustar altura/padding do header pode alterar visualmente telas consumidoras além das três priorizadas.
- Mudanças em `SliverAppBar` podem afetar comportamento de scroll, principalmente combinações de `pinned` e `floating`.
- Preservar `expandedHeight` com defaults antigos pode não ser suficiente para casos com textos longos e muitas ações; a refatoração deve lidar com truncamento e distribuição de espaço.
- Telas com `SafeArea` externo podem sofrer espaçamento superior duplicado se o componente não tratar safe area de forma cuidadosa.
- `actions` arbitrárias podem ter tamanhos inesperados; o componente deve se proteger contra sobreposição, mas não deve tentar normalizar qualquer widget externo complexo.

## Plano de validação

Validação automatizada mínima, se os comandos existentes estiverem disponíveis no repositório:

- Rodar análise estática Flutter/Dart existente, preferencialmente `flutter analyze`.
- Rodar testes existentes, se houver comando já configurado e identificável.

Validação manual obrigatória da refatoração futura:

- Abrir Agenda e verificar ausência de overflow no header e espaçamento correto antes do calendário.
- Abrir Detalhes do Reservatório com nome curto e nome longo e verificar título, subtítulo, voltar e menu de ações sem colisão.
- Abrir Relatórios e verificar ausência de overflow e alinhamento consistente com a lista de relatórios.
- Verificar em largura estreita de mobile e largura maior de tablet/desktop quando possível.
- Verificar pelo menos um consumidor não prioritário de `AppPageHeaderSliver` para confirmar compatibilidade visual básica.

Se não houver ambiente Flutter funcional disponível, a validação deve registrar explicitamente essa limitação e incluir evidência de análise estática não executada.

## Critérios de aceite

- `AppPageHeaderSliver` é refatorado sem remover ou renomear parâmetros públicos existentes.
- Agenda, Detalhes do Reservatório e Relatórios não exibem `RenderFlex overflowed` ou clipping visível no header em mobile.
- Título, subtítulo, voltar e ações permanecem utilizáveis e visualmente separados.
- A aparência permanece conservadora: fundo, hierarquia tipográfica, cores principais e densidade geral não viram um redesign completo.
- O componente continua puro e sem dependências de domínio, navegação ou stores.
- Chamadas existentes ao componente continuam compilando sem alteração obrigatória.
- `bottom`, quando usado por qualquer consumidor, tem espaço respeitado e não sobrepõe o conteúdo do header.
- Validação executada é registrada com comandos e/ou passos manuais realizados.

## Open questions

- Há algum dispositivo-alvo mínimo oficial para largura/altura que deve guiar a validação visual? Na ausência dessa definição, usar larguras mobile comuns e tablet/desktop como validação conservadora.
- Algum consumidor atual depende visualmente do `toolbarHeight` igual a `expandedHeight`? A implementação deve verificar regressões nos usos existentes.
- O projeto possui comando padrão de validação Flutter além de `flutter analyze`? Se existir, ele deve ser preferido.
