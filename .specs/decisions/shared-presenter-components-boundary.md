# Decisão: boundary dos componentes compartilhados presenter

## Contexto

A Home e Auth/Login consolidaram uma linguagem visual mais consistente para o app. Os módulos principais podem se beneficiar de componentes presenter reutilizáveis, mas importar widgets diretamente de Home/Auth criaria dependências entre fluxos com responsabilidades diferentes.

## Decisão

Componentes compartilhados presenter devem ficar fora de Home/Auth, inicialmente em `lib/features/presenter/widgets/common/` ou local equivalente dentro da boundary presenter.

Esses componentes não devem acessar `Get`, `GetIt`, stores, services ou rotas. Eles devem receber dados de apresentação, widgets filhos e callbacks por props.

`core/widgets` fica descartado no primeiro momento até que a API estabilize com uso real em múltiplos módulos.

## Por quê

- Evita acoplamento de módulos operacionais a componentes específicos da Home ou do fluxo de autenticação.
- Mantém a camada compartilhada focada em apresentação, sem misturar navegação, estado global ou regras de negócio.
- Permite adoção incremental e revisão da API antes de tornar os widgets globais.
- Reduz risco de criar um design system grande antes de validar os padrões em telas reais.

## O que foi descartado

- Reutilizar diretamente `home/components` como biblioteca compartilhada.
- Reutilizar diretamente `login/components` ou componentes Auth em módulos operacionais.
- Criar os widgets inicialmente em `core/widgets`, pois isso indicaria estabilidade e escopo global prematuros.
- Permitir que componentes comuns resolvam dependências, naveguem ou chamem stores/services internamente.

## Consequências

- Cada tela continuará responsável por stores, navegação, carregamento de dados e mapeamento de models para props de apresentação.
- A camada comum pode evoluir por uso real, começando pequena.
- Promoção futura para `core/widgets` exige decisão explícita, API estável e evidência de reutilização fora da boundary presenter.
