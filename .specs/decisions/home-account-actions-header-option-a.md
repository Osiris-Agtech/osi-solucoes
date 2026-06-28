# Decisão: saudação e ações de conta no card da Home

## Decisão

A Home deve adotar a Opção A: combinar saudação, contexto de conta e ações úteis de usuário/conta dentro de `HomeDayHeader`, usando dados mínimos de apresentação e callbacks vindos da Home ou boundary equivalente.

Na Home, `MyHeaderDelegate` deve preservar apenas o botão de menu acessível, em apresentação sutil e de baixo ruído visual, sem título “Home”, saudação, cargo, conta, contexto detalhado de conta ou barra verde evidente. A ação “Sobre o App” não deve ser exibida enquanto não houver destino real. Logout no card deve exigir confirmação. Troca de conta só deve aparecer quando houver múltiplas contas ou quando a view data indicar troca disponível.

Componentes visuais não devem acessar `AuthController`, `HomeStore`, `GetIt`, `Get`, services, rotas ou `Usuario` inteiro.

## Motivo

A decisão remove duplicação entre header fixo e topo da Home, reduz o peso visual do header fixo, preserva a hierarquia visual do painel diário e mantém ações de conta próximas do contexto do usuário sem acoplar componentes visuais à autenticação ou navegação.

Callbacks centralizados na Home reduzem risco de rotas inválidas, logout acidental e dependência direta de controllers/stores dentro de widgets reutilizáveis.

## Descartados

- **Manter saudação/cargo no header fixo e no card**: descartado por duplicar informação e competir com o conteúdo prioritário da Home.
- **Exibir título curto “Home” no header fixo**: descartado porque o header deve atuar apenas como acesso discreto ao menu, enquanto o card permanece como ponto principal de saudação e contexto.
- **Usar barra verde evidente no header fixo**: descartado porque aumenta o ruído visual e compete com o card inicial.
- **Mover ações de conta para dentro de `MyHeaderDelegate`**: descartado porque aumenta responsabilidade do header fixo e mantém a saudação distante do contexto operacional do card.
- **Permitir logout direto em um toque**: descartado por risco de toque acidental.
- **Exibir “Sobre o App” preventivamente**: descartado enquanto não houver rota/tela real validada.
- **Deixar `HomeDayHeader` acessar autenticação, stores ou navegação diretamente**: descartado por acoplamento e por violar boundaries da Home.
