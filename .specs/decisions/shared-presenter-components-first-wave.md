# Decisão: primeira onda de padronização estética presenter

## Contexto

A spec de componentes compartilhados presenter precisa habilitar implementação imediata sem criar um design system amplo nem acoplar módulos operacionais à Home/Auth. A exploração indicou que Reservatórios tem busca, loading, empty e lista, enquanto Relatórios tem cards e badges locais, mas está em um arquivo de 314 linhas que exige cautela.

## Decisão

A primeira onda de aplicação deve priorizar Reservatórios e Relatórios, mantendo os componentes comuns em `lib/features/presenter/widgets/common/`.

Os componentes devem ser puros e não devem importar `Get`, `GetIt`, stores, rotas, services, models de Home/Auth ou models de domínio.

`AppSearchBar` deve aceitar `TextEditingController?` externo e callbacks, sem controller interno obrigatório.

Não haverá barrel export inicial para `common/`; os imports devem apontar para arquivos específicos até a API estabilizar.

`AppPageHeaderSliver` deve ser criado, mas aplicado apenas onde não houver risco de quebrar navegação, gesto de voltar, scroll ou composição de slivers existente.

Arquivos grandes de cadastro ficam fora da primeira onda.

## Por quê

- Reservatórios valida busca, loading, empty e lista com baixo risco relativo.
- Relatórios valida cards, badges e ícones em uma tela visualmente próxima da direção estética, mas demanda alterações pequenas pelo tamanho do arquivo.
- Controller externo em `AppSearchBar` preserva telas que já controlam texto e evita estado interno desnecessário.
- Evitar barrel export reduz superfície pública prematura.
- Criar `AppPageHeaderSliver` sem aplicação obrigatória permite estabilizar a API sem forçar mudança sensível de navegação.

## O que foi descartado

- Migrar primeiro arquivos grandes de cadastro.
- Aplicar `AppPageHeaderSliver` de forma ampla na primeira rodada.
- Criar controller interno obrigatório em `AppSearchBar`.
- Criar barrel export inicial para todos os widgets comuns.
- Reutilizar widgets de Home/Auth diretamente nos módulos operacionais.

## Consequências

- A primeira implementação deve ser majoritariamente visual e reversível.
- Telas grandes e formulários ficam para ondas futuras com decomposição/plano próprio.
- Cada tela continua responsável por store, navegação, mapeamento de dados e callbacks.
- A API dos componentes comuns deve evoluir por uso real antes de qualquer promoção para `core/widgets`.
