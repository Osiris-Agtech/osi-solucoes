# Decisão: arquitetura da Home orientada ao trabalho diário

## Decisão

O redesenho da Home deve ser implementado por composição de seções coesas, preservando `HomeDashboard` como fonte principal de dados e evitando adicionar novas responsabilidades grandes a `home_page.dart`.

O sistema adaptativo existente também deve ser preservado. `HomeStore.loadAdaptiveInterface()`, atalhos/recomendações adaptativas, `adaptiveDashboard`, `adaptiveCardType`, `cardOrder` e métricas/tracking relacionados não devem ser removidos pela refatoração. A decisão é mudar a hierarquia visual, não descontinuar adaptação: dados críticos não dependem exclusivamente de carousel, e recomendações adaptativas viram ações recomendadas discretas, limitadas e validadas.

A implementação futura deve preferir:

- componentes de seção em `home/components` ou estrutura equivalente já existente;
- modelos/mappers simples de apresentação quando necessário;
- skeletons por bloco principal;
- navegação somente para rotas existentes;
- regras de negócio preservadas no store/domínio existente;
- tracking existente preservado nos fluxos equivalentes, incluindo `MetricsTrackingService.trackSessionStart()` e `trackDashboardShown()` quando aplicáveis, e tracking de navegação de dashboard somente se existir na implementação-alvo.

## Motivo

`home_page.dart` já possui aproximadamente 3571 linhas e concentra layout, drawer, header, dashboard, `PageView`, módulos, navegação, métricas e painters. Expandir esse arquivo aumentaria acoplamento, dificultaria validação visual e elevaria o risco de regressão.

`home_store.dart` também já acumula estado de UI, dashboard e interface adaptativa. A separação por componentes e, quando necessário, por mappers de apresentação reduz a necessidade de alterar regras de negócio ou contratos existentes, mantendo a feature focada em reorganização da experiência.

O esclarecimento posterior de produto confirmou que atalhos e dashboards adaptativos são usados no sistema adaptativo e devem continuar ativos. Por isso, a extração visual precisa tratar dados adaptativos como entradas preservadas, não como ruído a remover.

Essa abordagem também atende ao objetivo de produto confirmado em `PRODUCT.md`: priorizar o trabalho diário de cultivo, com Home clara, confiável e objetiva.

## Descartados

- **Adicionar todo o novo layout diretamente em `home_page.dart`**: descartado porque aumenta um arquivo já grande e mistura ainda mais responsabilidades.
- **Criar nova camada arquitetural ou pacote de design system**: descartado porque o escopo pede redesenho da Home, não substituição arquitetural ampla.
- **Alterar `HomeDashboard` ou contratos de backend para obter novos dados**: descartado porque os dados existentes já cobrem resumo, tarefas, produção, lotes e alertas; mudanças de contrato seriam desnecessárias para a primeira entrega.
- **Usar carousel como estrutura principal para dados críticos**: descartado porque informações críticas não devem depender de descoberta sequencial.
- **Criar favoritos/recentes como nova regra de negócio nesta feature**: descartado enquanto não houver evidência de suporte existente; fallback recomendado é exibir até 6 acessos principais.
- **Remover atalhos ou dashboards adaptativos por simplificação visual**: descartado porque eles fazem parte do sistema adaptativo existente; o redesenho deve apenas reduzir seu peso visual e validar sua apresentação.
- **Criar novos eventos de tracking para compensar a refatoração**: descartado para esta entrega; a decisão é preservar métricas existentes nos pontos equivalentes, sem inventar analytics novo.

## Decisões relacionadas

- `.specs/decisions/home-modules-inline-expansion.md`: define que o botão “Ver todos” do card “Módulos principais” expande inline, sem navegação para `Routes.modulosPage`, e que Setores/Lotes ficam fora apenas dessa seção.
- `.specs/decisions/home-account-actions-header-option-a.md`: define que saudação e ações de conta ficam em `HomeDayHeader`, enquanto o header fixo da Home preserva apenas o botão de menu acessível, sem título e com baixo ruído visual.
