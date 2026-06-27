# Padronização visual das telas de autenticação pela linguagem da nova Home

## Contexto

O produto registrado em `PRODUCT.md` é `product`. A personalidade definida é clara, confiável e objetiva, com interface voltada a reduzir ruído visual, apoiar decisões rápidas e preservar familiaridade. A nova Home, especificada em `.specs/home-daily-panel-redesign.md`, é a referência visual aprovada para essa linguagem.

As telas atuais de autenticação (`login_page.dart`, `cadastro_page.dart`, `multi_account_page.dart` e componentes em `login/components`) cumprem o fluxo funcional, mas usam padrões visuais divergentes entre si e em relação à nova Home: espaçamentos baseados diretamente em frações da tela, cards/campos com estilos diferentes, botões grandes e pouco compactos, loading por `CircularProgressIndicator` central, tratamento visual limitado de estados e pouco alinhamento com a semântica de cor definida para a Home.

A exploração já realizada indica a abordagem recomendada: criar componentes visuais locais ao fluxo auth inspirados na Home, sem importar componentes específicos da Home para evitar acoplamento entre fluxos.

Esta especificação cobre UX, arquitetura visual e critérios de aceite para implementação futura. Não inclui implementação de código de produção.

## Resumo e problema

Padronizar Login, Cadastro e Escolha de Conta/MultiAccounts usando a linguagem visual aprovada da nova Home, mantendo a autenticação familiar, direta e previsível. A mudança deve melhorar consistência, legibilidade, responsividade e estados explícitos sem alterar regras de login, cadastro, seleção de conta, armazenamento local, rotas, backend ou contratos.

Problemas observados:

- Login e Cadastro usam estruturas visuais diferentes, apesar de pertencerem ao mesmo fluxo.
- MultiAccounts possui card/lista de contas com aparência própria e menos alinhada aos cards da Home.
- Campos e botões não seguem um padrão compartilhado de raio, sombra, tipografia compacta e hierarquia.
- Loading aparece principalmente por spinners e erro por dialogs; o padrão visual aprovado para auth deve migrar erros para mensagens inline persistentes e contextualizadas.
- Responsividade existe parcialmente no Login, mas Cadastro e MultiAccounts dependem mais de medidas proporcionais diretas da tela.
- Há risco de acoplamento se a implementação importar diretamente `HomePanelCard`, `HomeBadge` ou outros componentes específicos da Home.

## Objetivos

- Aplicar às telas auth a linguagem visual aprovada da nova Home: cards brancos com raio 20, sombra leve, tipografia compacta, cores semânticas, badges discretos, ícones/tiles e estados explícitos.
- Preservar familiaridade e eficiência da tarefa: Login deve continuar rápido, Cadastro deve continuar claro e MultiAccounts deve facilitar escolha segura de conta.
- Criar componentes visuais locais ao fluxo auth para reduzir duplicação sem transformar a mudança em design system global.
- Melhorar responsividade em mobile, teclado aberto, tablet e desktop usando composição previsível com `ConstrainedBox`, `LayoutBuilder` e `Wrap` quando aplicável.
- Garantir acessibilidade básica: contraste, áreas de toque adequadas, textos sem overflow e estados que não dependem apenas de cor.
- Manter stores, regras de autenticação, seleção de conta, `LocalStorage`, rotas, backend e contratos intactos.

## Fora de escopo

- Implementar código de produção nesta etapa.
- Alterar regras de negócio de login, cadastro, validação de credenciais, criação de usuário ou seleção de conta.
- Alterar `LoginStore`, `CadastroStore`, `AuthController` ou modelos de usuário/conta além de eventual conexão visual futura estritamente necessária.
- Alterar `LocalStorage().storageUser`, navegação para `HomePage`, recuperação de senha, cadastro ou MultiAccounts.
- Alterar contratos de backend, schema de banco, mensagens de API ou fluxo de autenticação.
- Criar design system global para todo o app.
- Importar diretamente componentes específicos da Home para auth, como `HomePanelCard`, `HomeBadge`, `HomeAssetIcon`, `homeTitleStyle` ou `homeBodyStyle`, salvo decisão futura explícita.
- Introduzir analytics, logs, i18n, testes novos ou infraestrutura nova sem solicitação específica.
- Redesenhar a Home novamente.

## Padrões visuais da Home a reaproveitar

Os padrões abaixo devem inspirar equivalentes locais em auth, sem dependência direta de widgets da Home.

### Card branco com raio 20 e sombra leve

- Usar containers brancos com `BorderRadius.circular(20)` para painéis principais.
- Aplicar sombra leve equivalente à Home: offset baixo, blur suave e opacidade baixa.
- Evitar elevações fortes, fundos concorrentes e múltiplos cards aninhados sem necessidade.

### Tipografia compacta e hierarquia clara

- Títulos curtos, com peso alto e altura de linha compacta.
- Textos auxiliares com tamanho menor, legíveis, sem competir com CTA principal.
- Evitar títulos em múltiplas linhas grandes quando uma frase objetiva resolve.

### Cor semântica

- Usar `Constants.kPrimaryColor` para ação primária e destaques principais.
- Usar `Constants.kErrorColor` para falha/erro.
- Usar `Constants.kWarninngColor` para atenção, quando houver aviso não bloqueante.
- Usar tons neutros existentes (`kGreyMedium`, `kGreyText`, `kGreyText2`, `kSecondBackgroundColor`) para conteúdo secundário.
- Não comunicar status apenas por cor; combinar com texto, ícone ou rótulo.

### Badges discretos

- Badges devem ser pequenos, arredondados, com cor semântica em baixa opacidade e texto curto.
- Usar para contexto complementar, por exemplo “Conta ativa”, “Obrigatório”, “Opcional” ou “Acesso seguro”, se fizer sentido para a tela.
- Não usar badges como decoração sem informação útil.

### Ícones e tiles

- Ícones devem aparecer em tiles compactos com fundo semântico em baixa opacidade, como na Home.
- Login e Cadastro podem usar ícones para reforçar contexto do painel, não para distrair da tarefa.
- MultiAccounts deve usar tile/card de conta com imagem ou fallback consistente.

### Responsividade por composição

- Usar `LayoutBuilder` para adaptar largura, distribuição e densidade.
- Usar `ConstrainedBox` para limitar largura máxima de formulários/painéis em telas grandes.
- Usar `Wrap` quando conteúdo lateral ou cards de contas precisarem quebrar linha sem overflow.
- Evitar alturas fixas que comprimam textos ou campos com erro.

### Estados explícitos

- Loading, erro, vazio e imagem ausente/lenta devem ter tratamento visual planejado.
- O layout não deve depender apenas de spinner centralizado como única resposta.
- Mensagens de erro devem ser visíveis, objetivas e próximas da tarefa.

## Regras por tela

### Login

- Deve ser a tela auth mais compacta e direta.
- Estrutura recomendada:
  - `AuthScaffold` com fundo neutro alinhado à Home (`Constants.kSecondBackgroundColor` ou equivalente aprovado).
  - painel central `AuthPanelCard` limitado por `ConstrainedBox` em tablet/desktop.
  - `AuthHeader` mais textual, com logo menor, nome do produto, frase curta e possível badge discreto de segurança/contexto.
  - campos de e-mail e senha com `AuthTextField`.
  - CTA primário `AuthPrimaryButton` para entrar.
  - ações secundárias visuais menores: recuperar senha e criar conta.
  - “Criar conta” como linha/link final dentro do `AuthPanelCard`, após o CTA principal e demais feedbacks/ações relevantes.
- O botão “Entrar” deve ser visualmente dominante, mas não exagerado; altura e texto devem seguir densidade compacta da Home.
- Recuperar senha deve permanecer acessível, com menor peso visual que o CTA primário.
- Criar conta deve ser uma ação secundária clara, com peso visual secundário, posicionada como linha/link final dentro do `AuthPanelCard`, sem competir com o CTA primário “Entrar”.
- Validações existentes de e-mail/senha devem permanecer; apenas a apresentação visual deve mudar futuramente.
- Ao pressionar Enter/Done na senha, o comportamento funcional existente deve ser preservado.
- Erro de login deve aparecer como mensagem inline na tela, de forma explícita e legível, sem depender de dialog ou fechamento automático rápido para ser compreendido.
- A implementação futura deve verificar como garantir que a logo apareça sempre usando asset/local fallback robusto, evitando fallback remoto/frágil e preservando dimensões/layout se o asset falhar.

### Cadastro

- Deve parecer parte do mesmo fluxo do Login, mas com suporte a formulário maior.
- Estrutura recomendada:
  - `AuthScaffold` com rolagem segura para teclado aberto.
  - `AuthPanelCard` com seções visuais locais dentro do mesmo fluxo para agrupar dados pessoais, contato/endereço e credenciais.
  - `AuthHeader` com título objetivo e texto curto sobre criação de conta.
  - campos usando `AuthTextField` com indicador discreto para campos opcionais.
  - CTA primário de confirmação no final do formulário, sempre com largura e altura consistentes.
- O formulário deve evitar grandes blocos de espaço vazio e padding proporcional excessivo.
- Campos opcionais devem ser indicados com texto/badge discreto, sem competir com label.
- Linhas com Estado/País devem usar `LayoutBuilder` ou `Wrap` para não quebrar em telas estreitas.
- Loading de verificação/cadastro deve preservar o contexto da tela e deixar claro que a ação está em andamento.
- Erros de cadastro devem aparecer como mensagens inline na tela ou na seção afetada, informar o problema e permitir correção sem perder o contexto do formulário.
- O fluxo comentado de validação de e-mail não deve ser reativado nem redesenhado nesta feature sem decisão separada.

### Escolha de Conta / MultiAccounts

- Deve funcionar como continuação natural do Login quando há múltiplas contas.
- Estrutura recomendada:
  - `AuthScaffold` com header compacto e botão voltar preservando comportamento existente.
  - `AuthPanelCard` contendo instrução curta e lista/grid de contas.
  - `AccountSelectionCard` para cada vínculo de conta.
- Cada conta deve exibir:
  - imagem da conta quando disponível;
  - fallback visual consistente com iniciais da conta quando imagem estiver ausente, lenta ou falhar;
  - nome da conta;
  - cargo/vínculo;
  - estado visual de seleção/loading quando o usuário toca em uma conta.
- A lista deve usar `Wrap` ou grid responsivo para mobile/tablet/desktop, sem cards estreitos demais.
- A instrução “Selecione para avançar” deve ser integrada ao painel ou rodapé discreto, sem parecer elemento solto.
- Se a lista de contas estiver vazia ou impossível apesar de o fluxo chegar à tela, deve haver estado explícito com ação segura de voltar ao login ou tentar novamente, sem inventar novo contrato.
- O comportamento de seleção deve preservar `authController.usuario`, `selected_conta`, `LocalStorage().storageUser(...)` e navegação para `HomePage`.

## Arquitetura proposta e decisões de design

### Direção geral

Criar componentes visuais locais ao fluxo auth, inspirados nos padrões aprovados da Home, mas independentes dos componentes específicos de Home. Essa abordagem reduz duplicação entre Login, Cadastro e MultiAccounts sem acoplar a autenticação a uma feature visualmente específica.

Essa camada local não é um design system global. Ela deve existir para padronizar somente o fluxo auth nesta entrega.

### Componentes locais sugeridos

Local sugerido para implementação futura: `lib/features/presenter/views/login/components/auth/`, separando componentes compartilhados do fluxo auth dos componentes legados/específicos de Login e evitando mistura com `home/components`. Se a leitura do código indicar alternativa local mais coesa, ela pode ser adotada desde que preserve essa separação de responsabilidade.

- `AuthScaffold`
  - Responsável por fundo, safe area, comportamento com teclado, rolagem, largura máxima e padding responsivo.
  - Deve aceitar conteúdo flexível para Login, Cadastro e MultiAccounts.

- `AuthPanelCard`
  - Card branco com raio 20, padding consistente e sombra leve inspirada em `HomePanelCard`.
  - Não deve importar `HomePanelCard` diretamente.

- `AuthHeader`
  - Título, subtítulo, logo menor/ícone e badge opcional.
  - Deve manter tom claro, confiável e objetivo.
  - Deve prever logo via asset/local fallback robusto, sem depender de URL remota, e reservar dimensões estáveis para evitar salto de layout se o asset falhar.

- `AuthTextField`
  - Campo visual padronizado para login/cadastro.
  - Deve receber controller, label, tipo de teclado, obscure/visibility, validador existente e indicação opcional.
  - Não deve conter regra de negócio própria além de apresentação e encaminhamento de callbacks recebidos.

- `AuthPrimaryButton`
  - CTA principal com cor primária, altura consistente, texto compacto e estado de loading/disabled quando aplicável.

- `AuthSecondaryAction`
  - Link ou botão secundário para recuperar senha, criar conta ou voltar.
  - Deve ter peso visual menor que o CTA principal.

- `AuthFeedbackMessage`
  - Mensagem inline de erro, aviso ou sucesso, combinando texto, cor semântica e ícone.
  - Deve ser o padrão visual para erros de Login e Cadastro em vez de dialogs.

- `AccountSelectionCard`
  - Card/tile para vínculo de conta em MultiAccounts.
  - Deve tratar imagem, fallback com iniciais da conta, nome, cargo, toque, loading de seleção e área de toque adequada.

### Interfaces/dados envolvidos

Os componentes devem receber dados e callbacks já existentes, sem introduzir novos contratos de domínio.

- Login:
  - `LoginStore.email`
  - `LoginStore.senha`
  - `LoginStore.validateEmail(...)`
  - `LoginStore.validateSenha(...)`
  - `LoginStore.toggleObscure()`
  - `LoginStore.login()`
  - respostas existentes: `"sucesso"`, `"multiple"` ou mensagem de erro.

- Cadastro:
  - Controllers existentes de `CadastroStore` para nome, sobrenome, telefone, CEP, endereço, e-mail e senha.
  - Validações existentes no formulário.
  - `CadastroStore.verificaEmail()`
  - `CadastroStore.cadastraUser()`
  - `CadastroStore.buscaCEP()`
  - `CadastroStore.toggleObscure()`

- MultiAccounts:
  - `Usuario user`
  - `user.contas`
  - `conta.conta?.imagem`
  - `conta.conta?.nome`
  - `conta.cargo?.cargo`
  - `AuthController.usuario`
  - `selected_conta`
  - `LocalStorage().storageUser(...)`

### Boundaries obrigatórias

- Não alterar stores, regras de autenticação, regras de cadastro ou seleção de conta.
- Não alterar `LocalStorage`, rotas, backend, contratos, modelos ou mensagens retornadas por serviços.
- Não mover lógica de negócio para componentes visuais.
- Não usar dialogs como padrão visual para erros de Login/Cadastro; dialogs só podem permanecer para casos funcionais existentes que não sejam feedback visual padrão e exigiriam decisão separada para alteração.
- Não importar `HomePanelCard`, `HomeBadge`, `HomeAssetIcon`, `homeTitleStyle` ou `homeBodyStyle` diretamente em auth, salvo decisão futura.
- Não criar design system global nesta feature.
- Não criar nova camada arquitetural, pacote ou convenção global sem aprovação.
- Não adicionar analytics/logs ou eventos novos.
- Não reativar fluxos comentados de validação de e-mail no Cadastro.

## Responsividade e acessibilidade

### Mobile

- Layout vertical, com foco na tarefa principal.
- Formulários devem rolar quando o teclado estiver aberto.
- Evitar alturas fixas em campos que possam cortar mensagens de erro.
- Botões e cards tocáveis devem ter área mínima adequada para toque.

### Teclado aberto

- Login deve manter e-mail/senha/CTA acessíveis com rolagem previsível.
- Cadastro deve permitir navegar entre campos sem esconder validações ou CTA de forma permanente.
- Tocar fora do campo deve continuar fechando o teclado quando esse comportamento já existir.

### Tablet e desktop

- Usar `ConstrainedBox` para limitar largura de painéis e melhorar legibilidade.
- MultiAccounts pode usar mais colunas, mas sem esticar cards ou imagens de forma excessiva.
- Cadastro pode usar agrupamentos ou linhas responsivas apenas quando não prejudicar leitura.

### Contraste, toque e texto

- Buscar contraste WCAG AA para textos, botões, mensagens e badges.
- Estados de erro/loading/sucesso devem combinar cor com texto/ícone.
- Textos devem usar `maxLines`, `overflow` e quebras responsáveis quando necessário.
- Nenhum texto principal deve ficar comprimido ou invisível em mobile estreito.
- Áreas clicáveis devem ser claras e consistentes: botões, links e cards de conta.

## Estados

### Loading

- Login: botão principal deve indicar processamento ou a tela deve exibir estado claro sem perder contexto.
- Cadastro: verificação de e-mail, busca de CEP e cadastro devem comunicar andamento explicitamente.
- MultiAccounts: seleção de conta deve indicar qual card está em processamento quando possível.
- O uso de `CircularProgressIndicator` pode existir como elemento interno, mas não deve ser a única linguagem visual do estado quando houver contexto disponível.

### Erro de login

- Deve aparecer como `AuthFeedbackMessage` inline, com cor semântica de erro, ícone ou texto claro.
- Deve preservar os campos preenchidos quando o fluxo existente permitir.
- Deve permitir tentativa de correção sem navegação inesperada.
- Não deve usar dialog como padrão visual de erro.

### Erro de cadastro

- Deve distinguir erro de validação local de erro retornado pelo serviço, quando essa informação já existir.
- Deve manter o usuário no formulário e orientar correção.
- Deve usar mensagem inline na tela ou na seção afetada.
- Não deve depender de dialog temporário que desaparece sem contexto.

### Imagem de conta ausente, lenta ou com falha

- `AccountSelectionCard` deve exibir fallback visual consistente com iniciais da conta quando `conta.conta?.imagem` estiver ausente, lenta ou falhar.
- Loading de imagem deve preservar dimensões do card para evitar salto de layout.

### Estado vazio/impossível em conta

- Se `user.contas` estiver vazio ou nulo em MultiAccounts, exibir mensagem explícita e ação segura.
- Ação permitida: voltar ao Login ou tentar novamente se houver fluxo existente.
- Não criar rota, recuperação automática ou contrato novo nesta feature.

## Critérios de aceite verificáveis

- Existe spec em `.specs/` para a padronização visual auth antes de qualquer implementação.
- Login, Cadastro e MultiAccounts usam linguagem visual consistente inspirada na nova Home.
- Login possui painel compacto com card branco, raio 20, sombra leve, header, campos padronizados, CTA primário e ações secundárias discretas.
- Login posiciona “Criar conta” como linha/link final dentro do `AuthPanelCard`, com peso secundário e sem competir visualmente com o CTA “Entrar”.
- Login usa header mais textual com logo menor e preserva dimensões/layout quando a logo estiver carregando ou falhar.
- Logo em Login usa asset/local fallback robusto e não depende de fallback remoto/frágil para aparecer.
- Cadastro usa a mesma linguagem visual do Login, com campos padronizados, indicação clara de campos opcionais e seções visuais dentro do mesmo fluxo.
- MultiAccounts usa cards/tiles de conta consistentes com o padrão de card/ícone/tile da Home.
- Cards principais usam branco, raio 20 e sombra leve.
- Tipografia é compacta, com hierarquia clara e textos auxiliares menores.
- Cores seguem semântica: primária para ação, erro para falha, atenção para aviso, neutros para suporte.
- Badges, quando usados, são discretos e informativos.
- Ícones/tiles são usados para reforçar contexto sem competir com a tarefa.
- Layouts usam `ConstrainedBox`, `LayoutBuilder` e `Wrap` ou equivalentes responsivos quando aplicável.
- Login não apresenta overflow com teclado aberto em mobile.
- Cadastro não corta campos, erros ou CTA em mobile estreito.
- MultiAccounts não apresenta cards estreitos demais, imagens deformadas ou texto estourado em mobile/tablet/desktop.
- Estados de loading são explícitos e preservam contexto da tarefa.
- Erros de login e cadastro aparecem como mensagens inline na tela ou seção afetada, são legíveis, persistem tempo suficiente para compreensão e não dependem apenas de cor.
- Imagens de conta ausentes/lentas/com falha têm fallback visual consistente com iniciais da conta.
- Estado vazio/impossível de contas é tratado explicitamente se o fluxo receber lista vazia/nula.
- Nenhuma store, regra de auth, seleção de conta, `LocalStorage`, rota, backend ou contrato é alterado pela padronização visual.
- Nenhum componente específico de Home é importado diretamente em auth.
- Não é criado design system global.
- Não há implementação de código de produção nesta etapa de especificação.

## Riscos e validações

### Riscos

- Reutilizar diretamente componentes da Home parece reduzir trabalho, mas cria acoplamento entre Home e auth e pode dificultar evolução independente.
- Criar um design system global agora ampliaria o escopo e poderia gerar refatoração transversal não solicitada.
- Cadastro já possui muitos campos e pode ficar visualmente pesado se todo o conteúdo for colocado em um único painel sem hierarquia.
- Loading por dialog/spinner é comportamento existente; trocar sua apresentação futuramente exige cuidado para não alterar fluxo assíncrono ou navegação.
- MultiAccounts depende de imagens remotas; sem fallback dimensionado pode haver salto de layout ou estado quebrado.
- Medidas proporcionais diretas por `MediaQuery` podem manter overflows se não forem substituídas por constraints responsivas na implementação futura.

### Validações futuras recomendadas

- Revisar diff para confirmar que mudanças ficam restritas ao fluxo auth e componentes locais.
- Executar análise estática Flutter/Dart existente no projeto.
- Validar manualmente Login em mobile estreito, teclado aberto, tablet e desktop.
- Validar manualmente Cadastro com campos obrigatórios vazios, erro de e-mail, busca de CEP e erro de cadastro.
- Validar manualmente MultiAccounts com uma conta, múltiplas contas, imagem lenta, imagem ausente/falha e lista vazia/nula quando possível simular.
- Conferir contraste dos botões, badges, labels, mensagens de erro e textos secundários.
- Confirmar que Login continua navegando para Home ou MultiAccounts conforme resposta existente.
- Confirmar que Cadastro continua navegando para Home após sucesso conforme fluxo atual.
- Confirmar que MultiAccounts preserva seleção de conta, `LocalStorage().storageUser(...)` e navegação para Home.
- Confirmar que nenhum import de `home/components/home_panel_shared.dart` aparece em arquivos auth.

## Perguntas e decisões abertas

- Fechado: Cadastro deve usar seções visuais locais dentro do mesmo fluxo.
- Fechado: Login deve usar header mais textual com logo menor.
- Fechado: erros de Login/Cadastro devem usar mensagens inline como padrão visual, não dialogs.
- Fechado: MultiAccounts deve usar iniciais da conta como fallback primário de imagem.
- Fechado: componentes compartilhados auth devem ficar onde fizer mais sentido na leitura do código; recomendação técnica atual é `lib/features/presenter/views/login/components/auth/` para separar componentes compartilhados do fluxo auth dos componentes legados de Login.
- Fechado: a ação secundária “Criar conta” no Login deve ficar dentro do `AuthPanelCard` como linha/link final, com peso secundário e sem competir com o CTA “Entrar”.
