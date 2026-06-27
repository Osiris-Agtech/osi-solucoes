# Decisão — Adaptação visual local da Home sem alteração de API

## Contexto

A nova Home já recebe dados reais pelo GraphQL `homeDashboard` e sinais adaptativos pela Cloud Function `getAdaptiveInterface`. A necessidade atual é adaptar visualmente os cards usando esses dados existentes, sem alterar contratos externos nesta etapa.

## Decisão

Usar adaptação visual local na camada de apresentação, preferencialmente em `HomePanelMapper` e `HomePanelViewData`, mantendo `homeDashboard` como fonte dos dados reais dos cards e usando `adaptiveCardType`/`cardOrder` apenas como sinais de foco, prioridade e destaque visual.

## Por que

- Evita breaking change em GraphQL, Cloud Function e clientes.
- Permite validar a experiência visual com dados já disponíveis.
- Reduz risco operacional e custo de coordenação com backend.
- Mantém componentes visuais simples, recebendo dados prontos.
- Evita transformar `home_page.dart`, `home_store.dart` ou `adaptive_interface_service.dart` em pontos de regra visual.

## Alternativas descartadas

### Alterar `homeDashboard` para retornar cards já adaptados

Descartada nesta etapa por exigir mudança de contrato de API e coordenação backend/frontend antes de validar o valor da experiência visual.

### Alterar `getAdaptiveInterface` para retornar payload completo dos cards

Descartada porque duplicaria dados que já vêm de `homeDashboard`, aumentaria acoplamento com a Cloud Function e criaria risco de divergência entre fontes.

### Recriar carousel legado orientado por `cardOrder`

Descartada porque a abordagem desejada é usar `cardOrder` como foco de interface e prioridade visual, não como restauração de uma estrutura legada.

### Colocar lógica adaptativa nos widgets ou em `home_page.dart`

Descartada por aumentar acoplamento, dificultar testes e expandir arquivos de UI com regra de apresentação derivada.

## Consequências

- A implementação deve investir em view data mais expressiva.
- Fallbacks precisam ser bem definidos para confiança baixa, source não adaptativo, tipo desconhecido e dados ausentes.
- Mudanças futuras no backend podem ser consideradas depois que a adaptação visual estiver validada.

## Open questions que precisam de clarificação

1. O backend pretende estabilizar uma enum pública para `cardType` no futuro?
2. A adaptação local será permanente ou uma ponte até o backend retornar uma composição visual completa?
