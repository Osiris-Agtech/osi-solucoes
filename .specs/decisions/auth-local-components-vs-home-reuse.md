# Decisão: componentes visuais locais de auth em vez de reutilizar componentes da Home

## Decisão

As telas de Login, Cadastro e Escolha de Conta/MultiAccounts devem adotar componentes visuais locais ao fluxo auth, inspirados na linguagem aprovada da nova Home, em vez de importar diretamente componentes específicos da Home ou criar um design system global nesta entrega.

Componentes sugeridos para implementação futura incluem `AuthScaffold`, `AuthPanelCard`, `AuthHeader`, `AuthTextField`, `AuthPrimaryButton`, `AuthSecondaryAction`, `AuthFeedbackMessage` e `AccountSelectionCard`.

A recomendação técnica atual é colocar os componentes compartilhados do fluxo auth em `lib/features/presenter/views/login/components/auth/`, separando-os dos componentes legados/específicos de Login. A implementação futura pode escolher outro local se a leitura do código mostrar melhor coesão, desde que preserve a separação entre componentes auth compartilhados, componentes específicos de Login e componentes da Home.

Decisões finais de UX para a padronização visual auth:

- Login deve usar header mais textual com logo menor.
- No Login, “Criar conta” deve ficar dentro do `AuthPanelCard` como linha/link final, com peso secundário e sem competir com o CTA “Entrar”.
- O header deve garantir logo por asset/local fallback robusto, sem fallback remoto/frágil, preservando dimensões/layout se o asset falhar.
- Erros de Login/Cadastro devem aparecer como mensagens inline na tela ou seção afetada, não dialogs como padrão visual.
- Cadastro deve usar seções visuais dentro do mesmo fluxo, sem virar wizard ou rota nova.
- MultiAccounts deve usar iniciais da conta como fallback primário quando a imagem estiver ausente, lenta ou falhar.

## Motivo

A nova Home é a referência visual aprovada, mas seus componentes (`HomePanelCard`, `HomeBadge`, `HomeAssetIcon` e estilos auxiliares) pertencem ao contexto da Home e carregam responsabilidade de apresentação daquele fluxo. Importá-los diretamente em auth criaria acoplamento entre telas que evoluem por motivos diferentes.

Ao mesmo tempo, criar um design system global ampliaria o escopo além da padronização visual de autenticação e poderia exigir refatoração transversal não solicitada.

Componentes locais permitem reaproveitar a linguagem visual aprovada — card branco com raio 20, sombra leve, tipografia compacta, cor semântica, badges discretos, ícones/tiles, responsividade e estados explícitos — mantendo a mudança limitada, reversível e alinhada ao fluxo auth.

As decisões de UX fecham pontos que estavam abertos na spec base e reduzem ambiguidade de implementação: header textual diminui peso visual da logo no Login; “Criar conta” como linha/link final dentro do painel preserva acesso ao cadastro sem competir com o CTA de entrada; mensagens inline preservam contexto de correção; seções no Cadastro reduzem carga cognitiva sem alterar fluxo; iniciais de conta evitam dependência de imagem remota ou fallback genérico pouco informativo.

## Descartados

- **Importar `HomePanelCard`, `HomeBadge`, `HomeAssetIcon` ou estilos da Home diretamente em auth**: descartado por acoplar autenticação à implementação visual de Home.
- **Criar design system global agora**: descartado porque o escopo pedido é padronizar Login, Cadastro e MultiAccounts, não redesenhar todo o app.
- **Manter cada tela auth com componentes próprios e sem camada local compartilhada**: descartado porque preservaria inconsistência visual e duplicação entre Login, Cadastro e MultiAccounts.
- **Usar dialogs como padrão visual de erro em auth**: descartado porque remove contexto da tarefa e diverge da linguagem visual estrutural proposta.
- **Usar fallback remoto ou URL fixa para imagens/logos**: descartado por fragilidade e risco de salto visual; preferir fallback local dimensionado.
- **Usar ícone genérico como fallback primário de conta**: descartado em favor de iniciais, que preservam identidade da conta sem depender de imagem.

## Consequências

- A implementação futura deve criar componentes locais de auth com API simples e focada em apresentação.
- A linguagem visual da Home deve ser replicada por decisão de design, não por dependência direta de código.
- `AuthHeader`, `AuthFeedbackMessage` e `AccountSelectionCard` passam a carregar responsabilidades explícitas sobre logo/fallback, feedback inline e iniciais da conta.
- Telas orquestradoras devem preservar contratos atuais ao migrar erro de dialog para inline.
- Uma futura iniciativa de design system global pode absorver esses padrões depois, mas isso exigirá decisão separada.
