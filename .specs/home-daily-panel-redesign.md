# Home orientada ao trabalho diário de cultivo

## Resumo

Redesenhar a Home para priorizar o trabalho diário de cultivo. A tela deve abrir com contexto imediato da conta/usuário, tarefas urgentes, alertas críticos, indicadores do dia e caminhos claros para ação. A navegação por módulos passa a ser secundária e organizada, reduzindo ruído visual, carousels como única forma de descoberta e excesso de cores concorrentes.

O redesenho não remove nem quebra o sistema adaptativo existente. Atalhos, dashboards adaptativos, ordem/recomendações, métricas existentes e tracking relacionado devem continuar funcionando quando já forem usados pela Home. A mudança pretendida é de hierarquia visual: dados críticos deixam de depender exclusivamente de carousel, e recomendações adaptativas passam a aparecer como ações recomendadas discretas, limitadas e validadas.

Esta especificação cobre UX, estados, dados, navegação e arquitetura esperada para implementação futura. Não inclui implementação de código de produção.

## Problema

A Home atual concentra responsabilidades demais em `home_page.dart`, que possui aproximadamente 3571 linhas e mistura layout, drawer, header, dashboard, `PageView`, módulos, navegação, métricas e painters. `home_store.dart`, com aproximadamente 424 linhas, mistura estado de UI, dashboard e interface adaptativa.

Do ponto de vista de produto, a Home atual tende a funcionar como dashboard genérico ou vitrine de módulos, enquanto o objetivo confirmado em `PRODUCT.md` é que gestores e equipes operacionais abram a Home e entendam rapidamente:

- o contexto da conta atual;
- o que exige atenção hoje;
- quais tarefas estão urgentes;
- quais alertas são críticos;
- quais ações devem ser tomadas primeiro;
- para onde navegar para registrar ou revisar informações.

Também foram identificados `CircularProgressIndicator` e TODOs na Home, o que conflita com a diretriz de loading estrutural previsível e estados acionáveis.

## Objetivos

- Reorganizar a Home em uma hierarquia clara, com foco no que fazer hoje.
- Exibir contexto imediato da conta/usuário no topo.
- Destacar tarefas vencendo hoje, lotes ativos, próximas colheitas e alertas críticos no bloco “Hoje no cultivo”.
- Garantir que informações críticas não fiquem escondidas exclusivamente em carousel.
- Limitar ações recomendadas a no máximo 4 ações contextuais.
- Exibir indicação adaptativa discreta quando houver relevância real para a recomendação.
- Apresentar produção com métrica principal, tendência curta e link para relatórios.
- Reduzir e organizar módulos no card “Módulos principais”, com 6 módulos no estado compacto e expansão inline para 10 módulos no estado expandido.
- Usar cores de forma semântica e consistente.
- Substituir loading centralizado por skeleton nos principais blocos da Home.
- Garantir estados vazios com próximos passos acionáveis e sem TODOs.
- Preservar regras de negócio e contratos existentes do dashboard.
- Preservar `HomeStore.loadAdaptiveInterface()`, `store.shortcuts`/recomendações adaptativas, `adaptiveDashboard`, `adaptiveCardType` e `cardOrder` quando continuarem sendo a fonte existente para atalhos, dashboard recomendado ou ordenação.
- Preservar tracking existente relacionado à Home e ao sistema adaptativo, incluindo `MetricsTrackingService.trackSessionStart()` e `trackDashboardShown()` quando aplicáveis ao fluxo atual.
- Evitar adicionar novas responsabilidades grandes a `home_page.dart`, usando extração coesa.

## Fora de escopo

- Alterar regras de negócio de tarefas, alertas, produção, lotes ou colheitas.
- Alterar contratos de backend ou schema de banco.
- Criar novas entidades de domínio não existentes.
- Implementar novos relatórios ou telas de destino ainda inexistentes.
- Substituir o design system completo do app.
- Refatorar toda a navegação global do aplicativo.
- Reescrever `home_store.dart` além do necessário para separar responsabilidades da Home.
- Remover, desativar ou substituir o sistema adaptativo existente de atalhos/dashboard.
- Alterar ações recomendadas adaptativas por causa da lista de módulos; a exclusão de Setores e Lotes vale apenas para a seção “Módulos principais”.
- Remover métricas ou eventos de tracking existentes relacionados a sessão, exposição de dashboard, exposição/clique de atalhos ou navegação de dashboard.
- Introduzir analytics, logs, i18n, testes ou infraestrutura nova sem solicitação explícita.

## Usuários/contexto

Usuários primários: gestores e equipes operacionais de cultivo.

Contexto de uso:

- Rotina diária de operação, frequentemente em mobile.
- Necessidade de consulta rápida no início ou durante o turno.
- Decisões baseadas em pendências, alertas, produção e status dos lotes.
- Uso eventual em telas maiores para acompanhamento e revisão.

Necessidades principais:

- Identificar rapidamente o que precisa ser feito hoje.
- Entender se há risco operacional crítico.
- Acessar registros ou módulos relevantes com poucos toques.
- Evitar interpretar dashboards genéricos ou navegar por muitos cartões equivalentes.

## UX alvo

### Estrutura da Home

1. **Topo compacto**
   - Saudação curta.
   - Conta/contexto atual visível.
   - CTA primário: “Ver tarefas de hoje”.
   - Sem ocupar altura excessiva em mobile.

2. **Hoje no cultivo**
   - Bloco principal da Home.
   - Deve consolidar:
     - tarefas vencendo hoje;
     - lotes ativos;
     - próximas colheitas;
     - alertas críticos.
   - Alertas e pendências críticas devem aparecer diretamente na tela, não apenas em carousel.
   - Deve deixar clara a prioridade operacional.

3. **Ações recomendadas**
    - No máximo 4 ações.
    - Ações devem ser contextuais ao estado do dashboard quando possível.
   - Recomendações adaptativas já existentes podem alimentar esta seção, desde que sejam limitadas, tenham destino validado e não ocultem dados críticos.
    - Deve haver fallback seguro quando não houver recomendação específica.
    - Indicação adaptativa discreta pode explicar a recomendação, sem competir visualmente com o CTA principal.

4. **Produção**
   - Uma métrica principal.
   - Tendência curta ou comparação simples quando o dado existir.
   - Link para relatórios, apenas se houver rota/tela adequada.

5. **Módulos**
    - Acesso secundário.
    - Exibir 6 módulos no estado compacto do card “Módulos principais”.
    - O botão “Ver todos” deve expandir inline o próprio card para exibir a lista completa permitida, sem navegar para `Routes.modulosPage`.
    - No estado expandido, o botão muda para “Ver menos” e recolhe o card para o estado compacto.
    - Lista final permitida no card expandido: Cultivos/Áreas, Reservatórios, Caderno de Campo, Soluções Nutritivas, Relatórios, Ajustes, Gestão de equipe, Agenda, Protocolos, Histórico.
    - Setores e Lotes não devem aparecer nessa lista porque exigem contexto/id de área; essa exclusão não altera ações recomendadas adaptativas fora da seção de módulos.

### Hierarquia visual

- Prioridade 1: CTA de tarefas de hoje, alertas críticos e pendências do dia.
- Prioridade 2: indicadores operacionais do dia e produção resumida.
- Prioridade 3: ações recomendadas.
- Prioridade 4: módulos e atalhos secundários.

### Cores e semântica

- Cores devem usar a paleta existente em `constants.dart` sempre que possível.
- Vermelho/erro: falha, crítico ou vencido.
- Amarelo/atenção: risco, prazo próximo ou cuidado.
- Verde/sucesso: conclusão, produção positiva ou estado saudável.
- Cor primária: ação principal e navegação principal.
- Categorias devem manter consistência entre cartões, badges e ícones.
- Informação de prioridade não pode depender apenas da cor; deve incluir texto, ícone ou rótulo.

## Estados e dados

### Dados existentes a aproveitar

O model `HomeDashboard` já expõe dados necessários para a maior parte da reorganização:

- resumo;
- tarefas;
- produção;
- lotes;
- alertas.

Componentes existentes em `home/components` podem ser avaliados para reaproveitamento ou extração, incluindo:

- `daily_tasks_widget.dart`;
- `mini_charts.dart`;
- `productivity_chart_widget.dart`;
- outros componentes já presentes no diretório.

### Sistema adaptativo existente a preservar

Há evidência no código atual de uso de interface adaptativa na Home, incluindo `HomeStore.loadAdaptiveInterface()`, atalhos/recomendações em store, `adaptiveDashboard`, `adaptiveCardType` e `cardOrder`. Esta feature deve tratar esses dados como entradas existentes para apresentação, não como comportamento a remover.

Boundaries explícitas:

- `HomeStore.loadAdaptiveInterface()` deve continuar sendo chamado no fluxo em que a Home já carrega a interface adaptativa, salvo decisão futura específica.
- Atalhos/recomendações adaptativas existentes devem ser preservados e podem ser mapeados para “Ações recomendadas”, com limite de 4 itens e validação de rota/callback.
- `adaptiveDashboard`, `adaptiveCardType` e `cardOrder` devem continuar disponíveis para os fluxos que ainda dependem deles; o redesenho não deve apagar nem sobrescrever essa ordem com regra visual local incompatível.
- Dashboards adaptativos não devem voltar a ser o único local de dados críticos; quando usados, devem atuar como apoio ou personalização secundária da Home.
- Se algum dado adaptativo estiver ausente, a Home deve usar fallback seguro sem quebrar atalhos/dashboards existentes em sessões futuras.

### Estado: carregando

- Principais blocos devem usar skeleton/placeholder estrutural, não spinner centralizado como única experiência.
- Skeletons devem preservar a estrutura esperada dos blocos:
  - topo;
  - Hoje no cultivo;
  - ações recomendadas;
  - produção;
  - módulos.
- Evitar saltos grandes de layout entre loading e conteúdo carregado.

### Estado: vazio

- Estado vazio deve informar o que falta e qual próximo passo o usuário pode tomar.
- Não deve conter TODOs visíveis ou rotas inexistentes.
- Exemplos de próximos passos permitidos, desde que as rotas existam:
  - criar ou revisar tarefa;
  - cadastrar lote;
  - registrar produção;
  - acessar módulos principais.

### Estado: erro

- Erro deve indicar falha de carregamento de forma explícita.
- Deve oferecer ação segura de tentar novamente quando o store ou fluxo existente suportar refresh.
- Não deve ocultar totalmente navegação essencial se parte dos dados puder ser exibida com segurança.

### Estado: sem conta/contexto

- Topo deve deixar claro que não há conta/contexto selecionado.
- Deve orientar o próximo passo existente no produto, sem criar fluxo novo nesta feature.

### Estado: dados parciais

- A ausência de tarefas não deve apagar alertas ou produção.
- A ausência de produção não deve impedir tarefas e alertas de aparecerem.
- Cada bloco deve ter fallback próprio quando o dado específico estiver ausente.

## Regras de interação/navegação

- CTA “Ver tarefas de hoje” deve navegar para a tela/rota existente de tarefas filtrada para hoje, se esse filtro já existir.
- Se não existir filtro por hoje, o CTA deve navegar para a tela de tarefas existente sem inventar contrato novo; a limitação deve ser registrada para implementação.
- Alertas críticos devem ser clicáveis somente se houver tela/rota existente para detalhe ou lista de alertas.
- Ações recomendadas não devem apontar para TODOs, rotas temporárias ou callbacks vazios.
- Link para relatórios deve aparecer somente quando a tela de relatórios existir e puder ser acessada com segurança.
- Botão “Ver todos” em módulos deve expandir inline o próprio card, sem chamar `Get.toNamed` e sem navegar para `Routes.modulosPage`.
- No card “Módulos principais”, Setores e Lotes devem ser excluídos porque exigem contexto/id de área; ações recomendadas adaptativas não são alteradas por essa exclusão.
- Carousels podem existir como apoio, mas não podem ser o único local de informação crítica.
- A navegação deve preservar regras e permissões já existentes.
- Atalhos adaptativos existentes devem continuar navegando para destinos reais e validados; a redesign não deve trocar rotas adaptativas por TODOs, callbacks vazios ou destinos inexistentes.
- Quando houver tracking atual de sessão, dashboard ou navegação/exposição adaptativa, a redesign deve manter a chamada nos pontos equivalentes. `MetricsTrackingService.trackSessionStart()` e `trackDashboardShown()` são evidenciados no código; `trackDashboardNavigation()` só deve ser preservado se existir no branch/implementação em que a feature for aplicada.

## Acessibilidade/responsividade

- Buscar contraste compatível com WCAG AA para textos, botões, badges e estados.
- Prioridade e status devem combinar cor com texto, ícone ou rótulo.
- Textos devem permanecer legíveis em mobile, tablet e desktop.
- Evitar alturas fixas que causem clipping, overflow ou textos comprimidos.
- Cards principais devem aceitar conteúdo dinâmico sem quebrar a hierarquia.
- Em mobile, a Home deve priorizar leitura vertical com blocos compactos.
- Em telas maiores, blocos podem ser distribuídos em grid/responsivo, mantendo “Hoje no cultivo” como área prioritária.
- Elementos acionáveis devem ter área de toque adequada.
- Motion deve ser discreta e ligada a mudança de estado; não deve ser necessária para entender prioridade.

## Arquitetura proposta

### Direção geral

Implementar o redesenho por composição, extraindo responsabilidades da Home em componentes e builders coesos. `home_page.dart` não deve receber novas responsabilidades grandes nem continuar concentrando todos os blocos.

### Responsabilidades sugeridas

- `home_page.dart`
  - Orquestra a tela.
  - Conecta estado existente à composição visual.
  - Não deve conter regra detalhada de montagem de cada bloco.

- Store/View model da Home
  - Mantém carregamento, erro, refresh e seleção/contexto já existentes.
  - Pode expor dados derivados simples para a UI se isso reduzir duplicação.
  - Não deve absorver lógica visual extensa.

- Componentes de seção
  - Topo/contexto da conta.
  - Hoje no cultivo.
  - Ações recomendadas.
  - Produção resumida.
  - Módulos/favoritos/recentes.
  - Skeletons correspondentes.

- Helpers/mappers de apresentação, se necessários
  - Converter `HomeDashboard` em modelos de apresentação simples.
  - Ordenar ou limitar ações recomendadas.
  - Definir severidade visual a partir de dados existentes.

### Decisões de design técnico

- A implementação deve preservar `HomeDashboard` como fonte principal dos dados já existentes.
- A implementação deve preservar o carregamento e uso da interface adaptativa existente como entrada da Home, sem transformar a redesign em remoção de `HomeStore.loadAdaptiveInterface()` ou dos campos adaptativos do store.
- A feature deve preferir componentes novos ou extraídos em `home/components` a expandir `home_page.dart`.
- Se a feature tocar mais de 5 arquivos ou mais de 2 camadas, a implementação deve apresentar plano explícito antes de codar.
- Lógica de negócio deve permanecer fora de widgets de baixo nível; widgets devem receber dados prontos para renderizar.
- Não criar nova camada, pacote ou padrão arquitetural sem necessidade comprovada.

## Critérios de aceite verificáveis

- A Home inicia com topo compacto contendo saudação, contexto da conta/usuário e CTA “Ver tarefas de hoje”.
- O bloco “Hoje no cultivo” aparece antes dos módulos e mostra, quando disponíveis, tarefas de hoje, lotes ativos, próximas colheitas e alertas críticos.
- Alertas críticos e tarefas urgentes não ficam disponíveis exclusivamente em carousel.
- Ações recomendadas exibem no máximo 4 itens.
- A indicação adaptativa, quando exibida, é discreta e não compete com o CTA principal.
- Produção exibe métrica principal, tendência curta quando disponível e link para relatórios apenas se houver destino válido.
- Módulos exibem 6 itens no estado compacto do card “Módulos principais”.
- Ao clicar em “Ver todos”, o card expande inline para 10 itens e não executa `Get.toNamed` nem navega para `Routes.modulosPage`.
- No estado expandido, o botão exibe “Ver menos” e recolhe o card para 6 itens.
- A lista expandida contém somente: Cultivos/Áreas, Reservatórios, Caderno de Campo, Soluções Nutritivas, Relatórios, Ajustes, Gestão de equipe, Agenda, Protocolos, Histórico.
- Setores e Lotes não aparecem na seção “Módulos principais”.
- Cores seguem semântica consistente e não são o único meio de comunicar prioridade/status.
- Principais blocos possuem skeleton durante carregamento.
- A Home não usa `CircularProgressIndicator` como único loading dos principais blocos.
- Estados vazios exibem próximos passos acionáveis e não exibem TODOs.
- Nenhum CTA ou ação recomendada aponta para callback vazio, TODO ou rota inexistente.
- Layout mobile não apresenta overflow, textos ilegíveis ou alturas quebradas nos blocos principais, incluindo o card “Módulos principais” compacto e expandido.
- Layout em telas maiores mantém hierarquia e não estica cards de forma que prejudique leitura.
- `home_page.dart` não recebe novas responsabilidades grandes; blocos novos devem ser extraídos ou reutilizar componentes coesos.
- Regras de negócio existentes para dashboard, tarefas, lotes, alertas e produção são preservadas.
- `HomeStore.loadAdaptiveInterface()` continua preservado no fluxo de carga adaptativa existente da Home.
- Atalhos/recomendações adaptativas existentes continuam disponíveis e, quando exibidos na nova hierarquia, aparecem como ações recomendadas discretas, com no máximo 4 itens e destinos validados.
- `adaptiveDashboard`, `adaptiveCardType` e `cardOrder` não são removidos nem quebrados quando ainda forem usados para dashboard recomendado, tipo de card ou ordem dos cards.
- `MetricsTrackingService.trackSessionStart()` e `trackDashboardShown()` continuam sendo chamados nos fluxos equivalentes quando já eram aplicáveis; tracking de navegação de dashboard deve ser preservado se existir na implementação-alvo.
- Métricas/tracking existentes de exposição ou interação com atalhos adaptativos não são removidos pela redesign.
- Não há alteração de contrato de backend ou schema de banco para esta feature.

## Plano de validação

- Revisar diff para confirmar que nenhum arquivo fora do escopo foi alterado.
- Executar análise estática existente do Flutter/Dart, se disponível no projeto.
- Executar testes existentes, se houver suíte configurada.
- Validar manualmente a Home nos seguintes cenários:
  - dashboard carregado com tarefas, alertas, lotes e produção;
  - loading inicial;
  - erro de carregamento;
  - sem tarefas hoje;
  - sem alertas críticos;
  - sem produção;
  - sem conta/contexto selecionado, se o produto suportar esse estado;
  - mobile estreito;
  - tablet ou desktop.
- Verificar que não há TODOs visíveis na Home.
- Verificar que todos os CTAs navegam para rotas existentes.
- Verificar que atalhos e recomendações adaptativas continuam sendo carregados, exibidos quando aplicável e navegando para destinos válidos.
- Verificar que eventos de tracking existentes para sessão, dashboard e atalhos não foram removidos dos fluxos equivalentes.
- Verificar contraste e legibilidade dos principais textos, badges e botões.

## Riscos

- `home_page.dart` já é grande e pode incentivar mudanças locais em vez de extração coesa.
- Componentes existentes em `home/components` podem também estar grandes, exigindo cuidado para não apenas mover complexidade.
- Algumas navegações desejadas, como filtro “tarefas de hoje”, relatórios ou “ver todos”, podem não existir como rotas prontas.
- Dados de favoritos/recentes podem não existir; nesse caso, usar até 6 acessos principais evita criar nova regra de negócio.
- Skeletons podem introduzir inconsistência visual se não seguirem dimensões reais dos blocos.
- Excesso de recomendações “inteligentes” pode alterar expectativas de negócio; recomendações devem ser simples e baseadas em dados existentes.
- Ao reduzir o peso visual dos dashboards/atalhos adaptativos, há risco de remover comportamento usado por métricas e personalização; a implementação deve preservar o contrato existente e alterar apenas a apresentação.

## Perguntas em aberto

- Já existe rota/filtro específico para “tarefas de hoje” ou o CTA deve abrir a lista geral de tarefas inicialmente?
- Existe tela de relatórios adequada para o link da seção Produção?
- Quais rotas existentes devem ser associadas a Cultivos/Áreas, Reservatórios, Caderno de Campo, Soluções Nutritivas, Relatórios, Ajustes, Gestão de equipe, Agenda, Protocolos e Histórico?
- Quais severidades de alerta já existem no domínio e como devem mapear para crítico/atenção/informativo?
- Existe padrão de skeleton no projeto ou será necessário criar componentes locais para a Home?
- Há algum evento de tracking de navegação de dashboard além dos eventos evidenciados (`trackSessionStart()` e `trackDashboardShown()`) no branch final de implementação?
