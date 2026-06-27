# Plano de implementação staged: Padronização visual auth

## Contexto

- Spec base: `.specs/auth-visual-standardization.md`
- Referência visual aprovada: `.specs/home-daily-panel-redesign.md`
- Telas alvo: Login, Cadastro e Escolha de Conta/MultiAccounts.

Este plano existe para orientar a implementação futura da padronização visual das telas de autenticação pela linguagem da nova Home, sem implementar código de produção nesta etapa.

A mudança deve ser visual e estrutural no nível de widgets de apresentação. Regras de autenticação, stores, `LocalStorage`, rotas, backend, contratos e modelos não devem ser alterados.

## Goals e non-goals

### Goals

- Preparar componentes visuais locais ao fluxo auth antes de aplicar redesign por tela.
- Padronizar Login, Cadastro e MultiAccounts com cards brancos, raio 20, sombra leve, tipografia compacta, cores semânticas, badges discretos e estados explícitos.
- Aplicar decisões finais de UX auth: Login com header textual e logo menor; erros inline; Cadastro com seções visuais; MultiAccounts com fallback de iniciais; componentes compartilhados em pasta auth coesa quando fizer sentido.
- Reduzir duplicação visual entre as telas auth sem criar design system global.
- Preservar comportamento funcional existente de login, cadastro, recuperação de senha, escolha de conta e navegação.
- Exigir decomposição de `cadastro_page.dart` antes de aplicar redesign visual, porque o arquivo já é grande e concentra muitos campos e responsabilidades de apresentação.

### Non-goals

- Não implementar código de produção neste plano.
- Não alterar `LoginStore`, `CadastroStore`, `AuthController`, modelos, datasources, repositories, rotas, backend ou contratos.
- Não alterar regras de validação, respostas esperadas de login (`"sucesso"`, `"multiple"`, erro), cadastro ou seleção de conta.
- Não importar componentes específicos da Home em auth.
- Não criar design system global, tema global novo ou tokens globais novos sem decisão separada.
- Não reativar fluxos comentados de validação de e-mail no Cadastro.

## Technical approach e design decisions

### Direção técnica

Criar uma camada local de componentes auth preferencialmente em `lib/features/presenter/views/login/components/auth/`, ou em local equivalente mais coeso se a leitura do código indicar, inspirada nos padrões da Home, mas independente dos widgets de Home.

Decisão principal:

- Reaproveitar `Constants` e a linguagem visual observada na Home.
- Não reaproveitar `HomePanelCard`, `HomeBadge`, `HomeAssetIcon`, `homeTitleStyle` ou `homeBodyStyle` por import direto.
- Usar `AuthFeedbackMessage` inline como padrão de erro visual em Login/Cadastro, não dialogs.
- Usar `AuthHeader` textual no Login com logo menor, asset/local fallback robusto e dimensões estáveis para evitar salto de layout.
- Posicionar “Criar conta” no Login como linha/link final dentro do `AuthPanelCard`, com peso secundário e sem competir com o CTA “Entrar”.
- Usar seções visuais no Cadastro dentro do mesmo fluxo.
- Usar iniciais da conta como fallback primário de imagem em MultiAccounts.
- Aplicar primeiro componentes puros e locais, depois integrar tela por tela: Login → MultiAccounts → Cadastro.

### Arquivos alvo e responsabilidade por arquivo

#### Arquivos existentes que podem ser tocados em implementação futura

- `lib/features/presenter/views/login/login_page.dart`
  - Responsabilidade atual: orquestra formulário de login, foco, validação, logo, campos, CTA, recuperação de senha, cadastro e navegação pós-login.
  - Mudança esperada: substituir composição visual inline por `AuthScaffold`, `AuthPanelCard`, `AuthHeader`, `AuthTextField`, `AuthPrimaryButton`, `AuthSecondaryAction` e `AuthFeedbackMessage`.
  - Decisão UX: header mais textual com logo menor; erro de login inline na tela; “Criar conta” como linha/link final dentro do `AuthPanelCard`; logo deve ter fallback local/asset robusto e dimensões preservadas se o asset falhar.
  - Limite: preservar chamadas a `store.validateEmail`, `store.validateSenha`, `store.login`, `store.toggleObscure`, `store.clearFields`, navegação para `HomePage`/`MultiAccountsPage` e comportamento de Enter/Done.

- `lib/features/presenter/views/login/multi_account_page.dart`
  - Responsabilidade atual: exibir contas vinculadas e executar seleção com `AuthController`, `LocalStorage().storageUser(...)` e navegação para `HomePage`.
  - Mudança esperada: usar shell auth, painel local e `AccountSelectionCard` para cada conta.
  - Decisão UX: imagem ausente/lenta/com falha deve usar iniciais da conta como fallback primário, sem URL remota fixa.
  - Limite: preservar `authController.usuario`, `selected_conta`, `LocalStorage().storageUser(...)`, fallback seguro de voltar e navegação existente.

- `lib/features/presenter/views/cadastro/cadastro_page.dart`
  - Responsabilidade atual: renderizar formulário longo de cadastro, app bar, campos, foco, validações e ações de cadastro/busca/retorno.
  - Mudança esperada: decompor primeiro em seções/componentes locais dentro do mesmo fluxo e só depois aplicar visual novo.
  - Decisão UX: erros devem aparecer inline na tela ou seção afetada; Cadastro deve usar seções visuais para reduzir carga cognitiva sem virar wizard/fluxo separado.
  - Limite: não expandir o arquivo com novo redesign inline; não alterar `CadastroStore` nem fluxo comentado de validação de e-mail.

- `lib/features/presenter/views/login/components/loginButton.dart`
  - Responsabilidade atual: CTA e fluxo de login com loading/dialog/navegação.
  - Mudança esperada: pode ser substituído por composição com `AuthPrimaryButton` e `AuthFeedbackMessage` inline ou reduzido a wrapper fino, preservando callbacks e fluxo.
  - Limite: não mover regra auth para botão visual genérico.

- `lib/features/presenter/views/login/components/registrarButton.dart`
  - Responsabilidade atual: ação de navegação para Cadastro.
  - Mudança esperada: substituir visual por `AuthSecondaryAction` mantendo destino `CadastroPage` e transição existente se mantida.

- `lib/features/presenter/views/login/components/forgotPassword.dart`
  - Responsabilidade atual: ação para rota de recuperação de senha.
  - Mudança esperada: substituir visual por `AuthSecondaryAction` mantendo `Routes.recuperarSenha`.

- `lib/features/presenter/views/login/components/loadingDialog.dart`
  - Responsabilidade atual: loading e dialog de erro compartilhados pelo login.
  - Mudança esperada: deixar de ser o padrão visual de erro em auth; migrar erro para `AuthFeedbackMessage` inline no nível da tela, sem alterar contratos async. Loading pode ser preservado temporariamente quando necessário para não mudar fluxo.
  - Limite: não criar mecanismo global de loading.

- `lib/core/constants/constants.dart`
  - Responsabilidade atual: cores globais básicas.
  - Mudança esperada: preferencialmente apenas consumo; evitar alterações.
  - Limite: não redesenhar paleta nem adicionar tokens globais para resolver apenas auth.

#### Arquivos de referência que não devem ser tocados para esta feature

- `lib/features/presenter/views/home/components/home_panel_shared.dart`
  - Usar como referência visual lida, não como dependência direta.
  - Não importar em auth.

- `lib/features/presenter/views/home/home_page.dart` e demais `lib/features/presenter/views/home/**`
  - Não alterar para esta padronização auth.

- `lib/features/presenter/viewmodels/login_store.dart`
- `lib/features/presenter/viewmodels/cadastro_store.dart`
- `lib/features/presenter/viewmodels/auth_controller.dart`
- `lib/features/data/**`
- `lib/core/services/local_storage.dart`
  - Não alterar; são boundaries funcionais fora do escopo visual.

### Novos componentes/módulos sugeridos

Criar localmente, com recomendação técnica de pasta em `lib/features/presenter/views/login/components/auth/`, sem promover para design system global. A pasta separa componentes compartilhados do fluxo auth dos componentes legados/específicos de Login; uma alternativa local equivalente pode ser escolhida se a leitura do código mostrar melhor coesão.

- `auth_scaffold.dart`
  - Fundo neutro, `SafeArea`/scroll responsivo, teclado aberto, largura máxima e padding padrão.
  - Recebe `Widget child`; não acessa stores, navegação ou `GetIt`.

- `auth_panel_card.dart`
  - Card branco, `BorderRadius.circular(20)`, padding consistente e sombra leve inspirada na Home.
  - Não importa `HomePanelCard`.

- `auth_header.dart`
  - Header textual com logo menor/ícone local, título, subtítulo e badge opcional.
  - Deve garantir logo com asset/local fallback robusto, sem fallback remoto/frágil.
  - Deve reservar dimensões do espaço da logo para preservar layout se asset falhar ou demorar.
  - Não decide fluxo; só renderiza dados recebidos.

- `auth_badge.dart`
  - Badge discreto informativo com cor semântica em baixa opacidade.
  - Evitar uso decorativo sem informação.

- `auth_icon_tile.dart`
  - Tile compacto para ícone contextual com fundo semântico em baixa opacidade.
  - Alternativa local ao padrão visual de `HomeAssetIcon`, sem importá-lo.

- `auth_text_field.dart`
  - Campo visual padronizado para Login/Cadastro.
  - Recebe controller, label, keyboard type, obscure, validator, input formatters, text input action, focus node e callbacks existentes.
  - Não valida dados por conta própria além de chamar validators recebidos.

- `auth_primary_button.dart`
  - CTA principal com altura compacta, estado loading/disabled visual e cor `Constants.kPrimaryColor`.
  - Não chama stores diretamente; recebe `onPressed` e estado.

- `auth_secondary_action.dart`
  - Link/botão secundário para recuperar senha, criar conta e voltar.
  - Peso visual menor que CTA primário.
  - No Login, a ação “Criar conta” deve ser usada como linha/link final dentro do `AuthPanelCard`, não como botão concorrente ao CTA “Entrar”.

- `auth_feedback_message.dart`
  - Mensagem inline de erro/aviso/sucesso.
  - Deve ser o padrão visual de erro para Login e Cadastro, substituindo dialogs como feedback visual padrão.
  - Deve combinar cor, texto e ícone.

- `account_selection_card.dart`
  - Card/tile local para cada vínculo de conta em MultiAccounts.
  - Recebe nome, cargo, imagem opcional, callback de seleção e estado loading visual.
  - Trata fallback visual de imagem ausente/lenta/com falha usando iniciais da conta, sem alterar dados e sem depender de URL remota fixa.

- Componentes locais de Cadastro, somente após decomposição:
  - `cadastro_form_section.dart`: agrupa título, descrição curta e campos relacionados em seção visual dentro do mesmo fluxo.
  - `cadastro_address_fields.dart`: agrupa CEP/endereço/cidade/estado/país com `LayoutBuilder`/`Wrap`.
  - `cadastro_credentials_fields.dart`: agrupa e-mail/senha/confirmar senha conforme fluxo atual.
  - Estes componentes devem permanecer em escopo auth/cadastro e não virar padrão global.

### Módulos/componentes reutilizados

- `Constants`: fonte de cores semânticas (`kPrimaryColor`, `kErrorColor`, `kWarninngColor`, neutros e backgrounds).
- `ResponsiveBreakpoints`: pode continuar sendo usado onde já existe, especialmente no Login.
- `Spacing`: pode ser reutilizado para espaçamentos responsivos já existentes, desde que não force medidas frágeis.
- `LoginStore`: controllers, validações, obscure state e login existentes.
- `CadastroStore`: controllers, validações e ações de cadastro/CEP/e-mail existentes.
- `AuthController`: seleção de usuário/conta existente no MultiAccounts.
- `LocalStorage().storageUser(...)`: persistência existente de usuário/conta.
- `Get`/rotas existentes: navegação atual para `HomePage`, `MultiAccountsPage`, `CadastroPage`, `Routes.recuperarSenha` e retorno.
- `loadingDialog.dart`: pode ser mantido temporariamente apenas para loading ou compatibilidade funcional; erro visual padrão deve migrar para `AuthFeedbackMessage` inline.

### Boundaries que não devem ser cruzadas

- Componentes visuais auth não devem acessar `GetIt`, stores, repositories, datasources, services ou `LocalStorage` diretamente.
- `AuthPrimaryButton`, `AuthTextField`, `AuthPanelCard`, `AuthHeader`, `AuthBadge` e `AccountSelectionCard` devem receber dados/callbacks por parâmetro.
- `AuthFeedbackMessage` deve receber conteúdo e severidade por parâmetro; não deve buscar erros em store diretamente.
- Navegação deve permanecer nas páginas orquestradoras ou wrappers existentes, não dentro de componentes visuais genéricos.
- Lógica de negócio de login/cadastro/seleção de conta deve permanecer em stores/controllers atuais.
- Nenhum arquivo auth deve importar componentes específicos de `lib/features/presenter/views/home/components/`.
- Nenhum componente Home deve importar componentes auth.
- Não criar dependência de auth para data layer diretamente.
- Não alterar schema, queries, models gerados ou contratos de API.
- Não adicionar analytics/logs/eventos novos.

### Arquivos que não devem crescer sem decomposição

- `lib/features/presenter/views/cadastro/cadastro_page.dart`
  - Já possui mais de 500 linhas e formulário longo.
  - Bloqueio: não aplicar redesign visual adicionando mais blocos inline; decompor antes.

- `lib/features/presenter/views/login/login_page.dart`
  - Já mistura shell, formulário, campos, logo e fluxo de submit.
  - Limite: não adicionar novos widgets grandes inline; extrair para componentes locais.

- `lib/features/presenter/views/login/multi_account_page.dart`
  - Já contém construção inline da lista/cards de conta e dialog local.
  - Limite: não adicionar fallback/loading/empty state inline sem extrair `AccountSelectionCard` e estado/painel local.

- `lib/features/presenter/views/login/components/loadingDialog.dart`
  - Deve continuar simples; não transformar em gerenciador global de estado.

- `lib/core/constants/constants.dart`
  - Não expandir com tokens específicos de auth; preferir constantes locais privadas nos componentes se necessário.

### Riscos de acoplamento

- Importar `HomePanelCard`/`HomeBadge` em auth cria acoplamento visual entre fluxos independentes.
- Criar componentes globais agora ampliaria o escopo e poderia forçar refatorações transversais não solicitadas.
- Colocar navegação dentro de componentes visuais genéricos dificulta reutilização e testes manuais de fluxo.
- Reescrever loading/erro pode alterar ordem async, fechamento de dialogs e navegação pós-login se não for feito no nível da tela; por isso a migração para inline deve preservar respostas e callbacks existentes.
- Redesenhar Cadastro sem decomposição tende a aumentar arquivo já grande e misturar seções, validação e layout.
- Usar `MediaQuery` proporcional diretamente em campos/cards pode manter overflows em mobile estreito e teclado aberto.
- Fallback de imagem remoto em MultiAccounts pode mascarar ausência de imagem real; usar iniciais da conta como fallback local visual em vez de URL externa fixa.

## Data structures ou interfaces envolvidas

Não há novos contratos de domínio previstos. Interfaces dos componentes devem receber os dados atuais:

- Login:
  - `TextEditingController` de `LoginStore.email` e `LoginStore.senha`.
  - Validators `store.validateEmail(...)` e `store.validateSenha(...)`.
  - `store.isObscure`, `store.toggleObscure()` e `store.login()`.
  - Respostas existentes: `"sucesso"`, `"multiple"` ou mensagem de erro.

- Cadastro:
  - Controllers atuais de `CadastroStore` para nome, sobrenome, telefone, CEP, logradouro, complemento, bairro, cidade, estado, país, e-mail, senha e demais campos existentes.
  - Validators e ações existentes em `CadastroStore`, incluindo `verificaEmail()`, `cadastraUser()`, `buscaCEP()` e `toggleObscure()`.
  - `TextInputFormatter`s atuais, incluindo dependências de `brasil_fields`, devem ser preservados.

- MultiAccounts:
  - `Usuario user` e `user.contas`.
  - `conta.conta?.imagem`, `conta.conta?.nome`, `conta.cargo?.cargo`.
  - `AuthController.usuario` e `authController.usuario.selected_conta`.
  - `LocalStorage().storageUser(authController.usuario)`.

## Etapas staged de implementação

### Stage 0: Preparação e verificação de escopo

- Confirmar que a spec base continua vigente: `.specs/auth-visual-standardization.md`.
- Revisar diffs antes de iniciar para garantir que a implementação futura não misture auth com Home.
- Listar imports atuais de auth e confirmar que nenhum componente Home será importado.

Critério de conclusão:

- Escopo limitado a auth visual e componentes locais.
- Nenhum arquivo de produção alterado nesta etapa de planejamento.

### Stage 1: Criar componentes visuais locais auth

- Criar `AuthScaffold`, `AuthPanelCard`, `AuthHeader`, `AuthBadge`, `AuthIconTile`, `AuthTextField`, `AuthPrimaryButton`, `AuthSecondaryAction` e `AuthFeedbackMessage`.
- Componentes devem ser puros, sem stores, `GetIt`, `Get`, `LocalStorage` ou imports de Home.
- Aplicar cores de `Constants` e geometria inspirada na Home localmente.
- Implementar `AuthHeader` com suporte a logo menor, conteúdo textual dominante, asset/local fallback robusto e dimensões estáveis.
- Implementar `AuthFeedbackMessage` como componente inline para erro/aviso/sucesso.

Critério de conclusão:

- Componentes compilam isoladamente.
- Nenhum componente local auth cruza boundary funcional.

Dependência bloqueante:

- Deve vir antes de aplicar redesign nas telas.

### Stage 2: Preparar `AccountSelectionCard` e estados de MultiAccounts

- Criar `AccountSelectionCard` com imagem, fallback local, nome, cargo, callback e estado visual de seleção/loading.
- Usar iniciais da conta como fallback local de imagem ausente/lenta/com falha.
- Planejar estado vazio/impossível para `user.contas` nulo/vazio usando ação segura de voltar ou fluxo existente.
- Não alterar seleção/persistência/navegação.

Critério de conclusão:

- MultiAccounts tem componente de card pronto para integração.
- Fallback de imagem usa iniciais da conta e não depende de URL remota fixa.

Pode rodar em paralelo com:

- Stage 3, desde que Stage 1 tenha definido tokens/componentes base usados pelo card.

### Stage 3: Decompor Cadastro antes do redesign visual

- Extrair seções visuais locais de cadastro sem mudar comportamento: identidade/dados pessoais, contato/endereço e credenciais/ações.
- Remover repetição de padding proporcional por campo quando possível por composição local.
- Preservar controllers, formatters, validators, focus scope e fluxo comentado sem reativá-lo.

Critério de conclusão:

- `cadastro_page.dart` fica como orquestrador de seções, não como arquivo que renderiza todos os campos inline.
- Cadastro permanece no mesmo fluxo, sem virar wizard ou rota nova.
- Nenhuma regra de cadastro muda.

Dependência bloqueante:

- Deve ocorrer antes do Stage 6.

Pode rodar em paralelo com:

- Stage 2, após Stage 1.

### Stage 4: Aplicar visual no Login

- Integrar `AuthScaffold`, `AuthPanelCard`, `AuthHeader`, `AuthTextField`, `AuthPrimaryButton` e `AuthSecondaryAction` em `login_page.dart`.
- Configurar `AuthHeader` do Login como textual, com logo menor e fallback local/asset robusto.
- Trocar erro visual padrão para `AuthFeedbackMessage` inline, preservando respostas existentes de `store.login()`.
- Preservar validação, foco, submit por Done/Enter, loading/erro e destinos de navegação.
- Ajustar CTA e ações secundárias para hierarquia compacta, mantendo “Entrar” como CTA dominante e “Criar conta” como linha/link final dentro do `AuthPanelCard`.

Critério de conclusão:

- Login usa linguagem visual auth local.
- Login apresenta header textual com logo menor e dimensões preservadas mesmo se o asset falhar.
- Login apresenta “Criar conta” dentro do `AuthPanelCard` como linha/link final, com peso secundário e sem competir com “Entrar”.
- Erro de Login aparece inline, não como dialog visual padrão.
- Fluxos `sucesso`, `multiple` e erro continuam equivalentes.

Dependência bloqueante:

- Stage 1 concluído.

### Stage 5: Aplicar visual no MultiAccounts

- Integrar `AuthScaffold`, `AuthPanelCard`, `AuthHeader` e `AccountSelectionCard` em `multi_account_page.dart`.
- Usar `Wrap`/grid responsivo para contas.
- Usar iniciais da conta como fallback de imagem.
- Adicionar estado vazio/impossível sem criar contrato novo.
- Preservar comportamento de voltar conforme `isLoggedIn`.

Critério de conclusão:

- MultiAccounts usa cards/tiles consistentes e responsivos.
- Imagens ausentes/lentas/com falha exibem iniciais da conta sem salto de layout.
- Seleção de conta preserva `AuthController`, `selected_conta`, `LocalStorage` e navegação.

Dependências bloqueantes:

- Stage 1 e Stage 2 concluídos.

### Stage 6: Aplicar visual no Cadastro após decomposição

- Integrar shell/painel/header/campos auth nas seções extraídas.
- Usar `LayoutBuilder`/`Wrap` em linhas como Estado/País.
- Exibir campos opcionais de forma discreta.
- Exibir erros como `AuthFeedbackMessage` inline na tela ou seção afetada.
- Preservar loading/erro/cadastro/CEP conforme fluxo atual.

Critério de conclusão:

- Cadastro parece parte do mesmo fluxo visual do Login.
- Cadastro usa seções visuais dentro do mesmo fluxo, sem wizard ou rota nova.
- Erros de Cadastro aparecem inline, não como dialogs visuais padrão.
- Mobile estreito e teclado aberto não cortam campos, erros ou CTA.

Dependências bloqueantes:

- Stage 1 e Stage 3 concluídos.

### Stage 7: Revisão de boundaries, responsividade e acabamento

- Verificar imports: auth não importa `home/components`.
- Verificar que stores, rotas, backend, contracts e `LocalStorage` não foram alterados.
- Validar mobile estreito, teclado aberto, tablet e desktop/web.
- Revisar contraste, áreas de toque, overflow, imagem de conta e estados de loading/erro.

Critério de conclusão:

- Critérios da spec base são atendidos sem crossing de boundaries.
- Diffs ficam restritos a componentes/telas auth e eventuais imports necessários.

## Paralelização e dependências

### Dependências bloqueantes

- Stage 1 bloqueia Stages 4, 5 e 6.
- Stage 2 bloqueia Stage 5.
- Stage 3 bloqueia Stage 6.
- Stage 7 deve ser sequencial após integração das telas.

### Tarefas que podem rodar em paralelo

- Após Stage 1:
  - Workstream A: `AccountSelectionCard` e estados de MultiAccounts.
  - Workstream B: decomposição estrutural do Cadastro.
  - Workstream C: integração visual do Login.

- Após Stage 2 e Stage 3:
  - Integração MultiAccounts e integração Cadastro podem avançar em paralelo, desde que não alterem componentes base compartilhados sem coordenação.

### Tarefas que devem ser sequenciais

- Definição/ajuste dos componentes base locais deve ser estabilizada antes de redesign por tela.
- Refatoração de Cadastro deve preceder seu redesign visual.
- Revisão final de boundaries e validações deve ocorrer depois de todas as integrações.

## Acceptance criteria

- Existe este plano staged em `.specs/` antes de qualquer implementação.
- O plano lista arquivos alvo e responsabilidade por arquivo.
- O plano lista novos componentes/módulos sugeridos.
- O plano lista módulos/componentes reutilizados.
- O plano define boundaries que não devem ser cruzadas.
- O plano identifica arquivos que não devem crescer sem decomposição, incluindo `cadastro_page.dart`.
- O plano identifica riscos de acoplamento.
- O plano define etapas staged com preparação de componentes locais antes da aplicação por tela.
- O plano diferencia tarefas paralelizáveis e dependências bloqueantes.
- O plano recomenda validações automatizadas e manuais.
- O plano registra decisões finais de UX para header do Login, “Criar conta” como linha/link final dentro do painel, erros inline, seções no Cadastro, fallback de iniciais em MultiAccounts e pasta recomendada de componentes auth.
- Nenhum código de produção foi alterado pela criação deste plano.

## Validações/comandos recomendados

Executar a partir da raiz do projeto após implementação futura:

```bash
flutter analyze
flutter test
flutter build apk --debug
```

Validações manuais recomendadas:

- Login em mobile estreito com teclado aberto.
- Login com e-mail/senha inválidos, erro de serviço, sucesso e resposta `"multiple"`.
- Login com asset de logo ausente/falho para conferir fallback local e preservação de layout.
- Login com submit por Done/Enter no campo senha.
- Recuperar senha e criar conta preservando destinos atuais.
- Cadastro em mobile estreito, tablet e desktop/web.
- Cadastro com campos obrigatórios vazios, opcionais preenchidos/vazios, busca de CEP, erro e sucesso.
- MultiAccounts com uma conta, múltiplas contas, imagem ausente, imagem lenta/falha com iniciais e lista vazia/nula quando simulável.
- Voltar no MultiAccounts com `isLoggedIn` verdadeiro e falso.
- Conferir que `LocalStorage().storageUser(...)` continua sendo chamado no fluxo de seleção.
- Conferir que nenhum arquivo auth importa `lib/features/presenter/views/home/components/*`.
- Conferir que `LoginStore`, `CadastroStore`, `AuthController`, datasources, repositories, rotas e contratos não foram alterados.

## Open questions

- Fechado: Login deve migrar para header mais textual com logo menor.
- Fechado: feedback de erro deve migrar para mensagem inline por tela/seção como padrão visual, não dialog.
- Fechado: Cadastro deve usar seções visuais dentro do mesmo fluxo.
- Fechado: MultiAccounts deve usar iniciais da conta como fallback primário de imagem.
- Fechado: componentes auth devem ficar onde fizer mais sentido; recomendação técnica atual é `lib/features/presenter/views/login/components/auth/` para separar componentes compartilhados do fluxo auth dos componentes legados de Login.
- Fechado: a ação secundária “Criar conta” no Login deve ficar dentro do `AuthPanelCard` como linha/link final, com peso secundário e sem competir com o CTA “Entrar”.
