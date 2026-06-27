# Decisão: segunda onda de padronização estética presenter

## Contexto

A primeira onda de componentes compartilhados presenter estabeleceu uma boundary comum para padronização visual sem acoplar módulos à Home/Auth. A próxima etapa deve validar esses componentes em mais telas operacionais, usando o diagnóstico de exploração: Protocolos é seguro para migração direta; Solução está perto de 300 linhas e exige decomposição mínima/local ou substituições cuidadosas.

## Decisão

A segunda onda de aplicação deve priorizar Protocolos e Solução, usando os componentes comuns existentes em `lib/features/presenter/widgets/common/`.

Protocolos deve migrar diretamente para `AppPageHeaderSliver`, `AppSearchBar`, `AppStatePanel` e `AppEntityCard`, preservando busca, estados, FAB, navegação e bottom sheets.

Solução deve usar `AppPageHeaderSliver`, `AppSearchBar`, `AppStatePanel` e cards compostos com `AppPanelCard`/`AppIconTile`, preservando o grid atual. Como a tela está perto de 300 linhas, a migração deve ser feita por substituições cuidadosas ou decomposição mínima/local.

`AppPageHeaderSliver` pode receber melhorias pequenas guiadas por uso real, como `titleMaxLines`, `subtitleMaxLines`, padding configurável ou `safeArea` opcional. Ele não deve virar shell global.

Cadastros grandes, stores, rotas, models, services, Home e Auth/Login permanecem fora desta onda. Componentes comuns continuam puros.

## Por quê

- Protocolos oferece baixo risco para validar a aplicação direta de header, busca, estados e card de entidade.
- Solução valida composição visual com `AppPanelCard` e `AppIconTile` sem forçar uma abstração de entidade que pode não preservar o grid atual.
- Melhorar `AppPageHeaderSliver` por usos reais evita props antecipadas e amadurece a API com necessidades observadas.
- Manter cadastros grandes e camadas de estado/serviço fora do escopo reduz risco de regressão funcional.

## O que foi descartado

- Migrar cadastros de Protocolos ou Solução nesta onda.
- Alterar stores, rotas, models ou services para viabilizar padronização visual.
- Reescrever o grid de Solução ou substituir sua estrutura por uma lista genérica.
- Transformar `AppPageHeaderSliver` em shell global, scaffold compartilhado ou abstração de navegação.
- Aplicar `AppEntityCard` em Solução se isso quebrar o grid ou aumentar acoplamento.

## Consequências

- A segunda implementação deve continuar visual, incremental e reversível.
- Protocolos serve como validação de migração direta.
- Solução serve como validação de migração cuidadosa em arquivo próximo do limite de tamanho.
- A análise estática dos arquivos-alvo deve ficar limpa antes de concluir a onda.
