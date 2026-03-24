# TDD — Visão Geral de Features e Dados do Sistema OSI Soluções

| Campo              | Valor                                                       |
| ------------------ | ----------------------------------------------------------- |
| Tech Lead          | @jvdan                                                      |
| Produto            | OSI Soluções — Gestão de Produção Hidropônica               |
| Escopo             | Mapeamento completo de features, modelos de dados e operações de banco |
| Status             | Referência / Documentação Viva                              |
| Criado             | 2026-03-22                                                  |
| Última atualização | 2026-03-22                                                  |

---

## Contexto

Este documento é uma referência técnica consolidada de todo o sistema OSI Soluções. Ele mapeia cada feature do app, os dados que cada uma coleta e persiste, e o contrato exato das operações GraphQL com o backend. Serve como guia de onboarding para novos desenvolvedores e como referência para decisões de produto e dados.

O sistema usa **GraphQL** como protocolo de comunicação com o backend principal e **Firebase Analytics + BigQuery** para telemetria comportamental (detalhado em `.specs/features/adaptive-interface/tdd.md`).

---

## Arquitetura de Dados

```
App Flutter
│
├─ GraphQL (backend principal)    ← domínio de negócio (lotes, setores, etc.)
│    └─ Queries + Mutations inline nos Datasources
│
├─ Firebase Analytics             ← telemetria de uso (eventos de navegação)
│    └─ Export automático → BigQuery (dados dos últimos 30+ dias)
│
└─ Local Storage                  ← token JWT, preferências de sessão
```

---

## Módulos / Features

O app possui **20 módulos funcionais** organizados em camadas (Clean Architecture + MVVM + MobX):

| # | Módulo | Rota Principal | Responsabilidade |
|---|--------|---------------|-----------------|
| 1 | **Autenticação** | `/loginPage` | Login, multi-conta, recuperação de senha |
| 2 | **Cadastro** | `/cadastroPage` | Criação de nova conta/usuário |
| 3 | **Home / Dashboard** | `/homePage` | Dashboard resumido + atalhos inteligentes |
| 4 | **Módulos** | `/modulosPage` | Seleção de módulo ativo por conta |
| 5 | **Área de Cultivo (N1)** | `/areaCultivoPage` | Gestão de áreas físicas de produção |
| 6 | **Setor (N2)** | `/setorPage` | Gestão de setores dentro de uma área |
| 7 | **Lote (N3)** | `/lotePage` | Gestão de lotes dentro de um setor |
| 8 | **Detalhes do Lote** | `/detalhesLotePage` | Visualização e edição de um lote específico |
| 9 | **Protocolo** | `/protocoloPage` | Templates de cultivo com fases e ações |
| 10 | **Agenda** | `/agendaPage` | Tarefas e atividades programadas |
| 11 | **Reservatório** | `/reservatoriosPage` | Gestão de reservatórios de solução nutritiva |
| 12 | **Soluções Nutritivas** | `/solucaoPage` | Formulação de soluções com fertilizantes |
| 13 | **Caderno de Campo** | `/cadernoCampoPage` | Registro de atividades por lote |
| 14 | **Gerenciar Equipe** | `/gerenciarEquipePage` | Cadastro e gestão de usuários da conta |
| 15 | **Histórico** | `/historicoPage` | Lotes finalizados e histórico de produção |
| 16 | **Ajustes** | `/ajustesPage` | Ajustes de parâmetros de cultivo |
| 17 | **Relatório de Produção** | (modal/sheet) | Gráficos e dados de produção por período |
| 18 | **Relatório de Status de Lotes** | (modal/sheet) | Distribuição de status dos lotes |
| 19 | **Recuperar Senha** | `/recuperarSenha` | Fluxo de recuperação via código de segurança |
| 20 | **Interface Adaptativa** | (serviço da Home) | ML para atalhos e dashboard personalizados |

---

## Hierarquia de Navegação e Dados

A navegação principal segue uma hierarquia obrigatória de 3 níveis:

```
Conta
  └─ Área (N1)
       └─ Setor (N2)
            └─ Lote (N3)
                 ├─ Atividades (Caderno de Campo)
                 ├─ Agenda (tarefas)
                 ├─ Protocolo
                 └─ Reservatório → Solução Nutritiva → Fertilizantes
```

Cada nível só pode ser acessado após o anterior ser selecionado e seu estado setado no store correspondente.

---

## Modelo de Dados Completo

### Entidade: Conta

Representa uma organização/empresa cliente da plataforma.

| Campo | Tipo | Descrição |
|---|---|---|
| `id` | `Int` | Identificador único |
| `nome` | `String` | Nome da conta |
| `nivel` | `String` | Nível de acesso da conta |
| `imagem` | `String?` | URL da imagem/logo |
| `cnpj` | `String?` | CNPJ da empresa |
| `created_at` | `DateTime` | Data de criação |

**Relacionamentos:** `usuarios[]` (via `ConectaConta`)

---

### Entidade: Usuario

Representa um usuário autenticado no sistema.

| Campo | Tipo | Descrição |
|---|---|---|
| `id` | `Int` | Identificador único |
| `nome` | `String` | Nome do usuário |
| `email` | `String` | E-mail (login) |
| `senha` | `String` | Senha (nunca retornada nas queries) |
| `cod_acesso` | `String?` | Código de acesso externo |
| `ativo` | `Boolean` | Se o usuário está ativo |
| `acesso_externo` | `Boolean` | Se permite acesso externo |

**Relacionamentos:** `pessoa` (dados pessoais), `contas[]` (via `ConectaConta`), `cargo` (por conta)

---

### Entidade: Pessoa

Dados pessoais vinculados a um usuário.

| Campo | Tipo | Descrição |
|---|---|---|
| `id` | `Int` | Identificador único |
| `nome` | `String` | Primeiro nome |
| `sobrenome` | `String?` | Sobrenome |
| `telefone` | `String?` | Telefone de contato |
| `imagem` | `String?` | URL da foto de perfil |
| `cidade` | `String?` | Cidade |
| `estado` | `String?` | Estado |
| `pais` | `String?` | País |
| `created_at` | `DateTime` | Data de criação |

---

### Entidade: ConectaConta

Relacionamento entre usuário, conta e cargo (multi-tenant).

| Campo | Tipo | Descrição |
|---|---|---|
| `id` | `Int` | Identificador único |
| `usuario` | `Usuario` | Usuário vinculado |
| `conta` | `Conta` | Conta vinculada |
| `cargo` | `Cargo` | Cargo do usuário nessa conta |

---

### Entidade: Cargo

Define o papel de um usuário dentro de uma conta.

| Campo | Tipo | Descrição |
|---|---|---|
| `id` | `Int` | Identificador único |
| `cargo` | `String` | Nome do cargo |
| `permissoes[]` | `CargoPermissao[]` | Permissões vinculadas ao cargo |

---

### Entidade: Permissao

Permissão granular de acesso a um módulo ou ação.

| Campo | Tipo | Descrição |
|---|---|---|
| `id` | `Int` | Identificador único |
| `nome` | `String` | Nome da permissão (ex: `N1_VIEW`, `N3_EDIT`) |

---

### Entidade: Area (N1)

Representa uma área física de produção (ex: estufa, galpão).

| Campo | Tipo | Descrição |
|---|---|---|
| `id` | `Int` | Identificador único |
| `nome` | `String` | Nome da área |
| `descricao` | `String?` | Descrição |
| `imagem` | `String?` | URL de imagem da área |
| `tipo` | `String?` | Tipo de área (ex: estufa, campo) |
| `created_at` | `DateTime` | Data de criação |

**Relacionamentos:** `conta`, `localizacao`, `setores[]`

---

### Entidade: Localizacao

Endereço físico vinculado a uma área.

| Campo | Tipo | Descrição |
|---|---|---|
| `id` | `Int` | Identificador único |
| `cep` | `String` | CEP |
| `endereco` | `String` | Logradouro |
| `bairro` | `String` | Bairro |
| `cidade` | `String` | Cidade |
| `estado` | `String` | Estado (UF) |
| `pais` | `String` | País |
| `complemento` | `String?` | Complemento do endereço |

---

### Entidade: Setor (N2)

Subdivisão de uma área de cultivo.

| Campo | Tipo | Descrição |
|---|---|---|
| `id` | `Int` | Identificador único |
| `nome` | `String` | Nome do setor |
| `descricao` | `String?` | Descrição do setor |
| `created_at` | `DateTime` | Data de criação |

**Relacionamentos:** `area`, `reservatorio`, `lotes[]`

---

### Entidade: Lote (N3)

Unidade central de produção. Representa um ciclo de cultivo de uma cultura.

| Campo | Tipo | Descrição |
|---|---|---|
| `id` | `Int` | Identificador único |
| `nome` | `String` | Nome/identificador do lote |
| `ativo` | `Boolean` | Se o lote está ativo (em produção) |
| `registro_data` | `DateTime` | Data de registro do lote |
| `semeadura_data` | `DateTime?` | Data de semeadura |
| `transplantio_data` | `DateTime?` | Data de transplantio |
| `colheita_data` | `DateTime?` | Data de colheita prevista/realizada |
| `bandeijas_semeadas` | `Int?` | Quantidade de bandejas semeadas |
| `mudas_transplantadas` | `Int?` | Quantidade de mudas transplantadas |
| `plantas_colhidas` | `Int?` | Quantidade de plantas colhidas |
| `embalagens_produzidas` | `Int?` | Quantidade de embalagens produzidas |
| `fase_dias` | `Int?` | Dias na fase atual |
| `fase_data` | `DateTime?` | Data de início da fase atual |
| `proxima_fase` | `String?` | Nome da próxima fase |
| `deleted_at` | `DateTime?` | Data de soft-delete |

**Relacionamentos:** `setor`, `cultura`, `protocolo`, `reservatorio`, `agenda[]`, `lotes_atividades[]`

---

### Entidade: Cultura

Tipo de planta/cultura cultivada.

| Campo | Tipo | Descrição |
|---|---|---|
| `id` | `Int` | Identificador único |
| `nome` | `String` | Nome da cultura (ex: "Alface", "Tomate") |
| `privado` | `Boolean` | Se é cultura privada da conta ou pública do sistema |
| `created_at` | `DateTime` | Data de criação |

**Relacionamentos:** `conta?` (se privado), `lotes[]`

---

### Entidade: Protocolo

Template de cultivo com sequência de fases e ações.

| Campo | Tipo | Descrição |
|---|---|---|
| `id` | `Int` | Identificador único |
| `nome` | `String` | Nome do protocolo |
| `descricao` | `String?` | Descrição |
| `tipo_cultura` | `String?` | Tipo de cultura para o qual se aplica |
| `sistema_cultivo` | `String?` | Sistema de cultivo (ex: NFT, DFT) |
| `implantacao` | `String?` | Modo de implantação |
| `created_at` | `DateTime` | Data de criação |
| `updated_at` | `DateTime?` | Última atualização |
| `deleted_at` | `DateTime?` | Data de soft-delete |

**Relacionamentos:** `cultura`, `conta`, `acoes[]`, `lotes[]`

---

### Entidade: Fase

Etapa dentro de um protocolo de cultivo.

| Campo | Tipo | Descrição |
|---|---|---|
| `id` | `Int` | Identificador único |
| `nome` | `String` | Nome da fase (ex: "Semeadura", "Berçário") |
| `descricao` | `String?` | Descrição |
| `duracao_dias` | `Int` | Duração em dias |
| `created_at` | `DateTime` | Data de criação |
| `updated_at` | `DateTime?` | Última atualização |
| `deleted_at` | `DateTime?` | Data de soft-delete |

**Relacionamentos:** `conta`, `acoes[]`

---

### Entidade: Acao

Atividade específica dentro de uma fase do protocolo.

| Campo | Tipo | Descrição |
|---|---|---|
| `id` | `Int` | Identificador único |
| `titulo` | `String` | Título da ação |
| `descricao` | `String?` | Descrição detalhada |
| `duracao_dias` | `Int?` | Duração prevista |
| `duracao_dias_real` | `Int?` | Duração real registrada |
| `alerta` | `Boolean?` | Se gera alerta/notificação |
| `created_at` | `DateTime` | Data de criação |
| `updated_at` | `DateTime?` | Última atualização |
| `deleted_at` | `DateTime?` | Data de soft-delete |

**Relacionamentos:** `protocolo`, `fase`

---

### Entidade: Agenda

Tarefa ou atividade programada para um lote.

| Campo | Tipo | Descrição |
|---|---|---|
| `id` | `Int` | Identificador único |
| `titulo` | `String?` | Título da atividade |
| `descricao` | `String?` | Descrição |
| `data` | `DateTime` | Data programada |
| `data_inicio` | `DateTime?` | Data de início |
| `data_fim` | `DateTime?` | Data de fim |
| `ativo` | `Boolean?` | Se está ativa |
| `alerta` | `Boolean?` | Se gera alerta |
| `finalizado` | `Boolean?` | Se foi concluída |
| `privado` | `Boolean?` | Se é privada |
| `created_at` | `DateTime` | Data de criação |

**Relacionamentos:** `lote`, `usuario`, `contas[]`

---

### Entidade: Atividade

Template de atividade reutilizável para registros no caderno de campo.

| Campo | Tipo | Descrição |
|---|---|---|
| `id` | `Int` | Identificador único |
| `nome` | `String` | Nome da atividade |
| `descricao` | `String?` | Descrição |
| `privado` | `Boolean` | Se é privada da conta |
| `created_at` | `DateTime` | Data de criação |

**Relacionamentos:** `conta`, `lotes_atividades[]`

---

### Entidade: LotesAtividades

Registro de execução de uma atividade em um lote (caderno de campo).

| Campo | Tipo | Descrição |
|---|---|---|
| `id` | `Int` | Identificador único |
| `atividade` | `Atividade` | Atividade realizada |
| `lote` | `Lote` | Lote onde foi executada |
| `usuario` | `Usuario` | Usuário que registrou |
| `conta` | `Conta` | Conta associada |

---

### Entidade: Reservatorio

Reservatório físico de solução nutritiva.

| Campo | Tipo | Descrição |
|---|---|---|
| `id` | `Int` | Identificador único |
| `nome` | `String` | Nome/identificador do reservatório |
| `volume` | `Decimal` | Volume em litros |
| `created_at` | `DateTime` | Data de criação |

**Relacionamentos:** `conta`, `solucao` (SolucaoNutritiva), `lotes[]`

---

### Entidade: SolucaoNutritiva

Formulação de solução nutritiva.

| Campo | Tipo | Descrição |
|---|---|---|
| `id` | `Int` | Identificador único |
| `nome` | `String` | Nome da solução |
| `c_eletrica` | `Decimal?` | Condutividade elétrica padrão (μS/cm) |
| `created_at` | `DateTime` | Data de criação |

**Relacionamentos:** `reservatorios[]`, `solucoes_contas[]`, `solucoes_fertilizantes_concentradas[]`

---

### Entidade: SolucaoConcentrada

Concentrado de fertilizante para preparação da solução.

| Campo | Tipo | Descrição |
|---|---|---|
| `id` | `Int` | Identificador único |
| `nome` | `String` | Nome do concentrado (ex: "Solução A", "Solução B") |
| `c_eletrica` | `Decimal?` | Condutividade elétrica |
| `volume` | `Decimal?` | Volume do concentrado |
| `fator_concentracao` | `Decimal?` | Fator de diluição |

**Relacionamentos:** `solucoes_fertilizantes_concentradas[]`

---

### Entidade: Fertilizante

Insumo de fertilizante.

| Campo | Tipo | Descrição |
|---|---|---|
| `id` | `Int` | Identificador único |
| `nome` | `String` | Nome do fertilizante |

**Relacionamentos:** `fertilizantes_nutrientes[]`

---

### Entidade: Nutriente

Nutriente presente em um fertilizante.

| Campo | Tipo | Descrição |
|---|---|---|
| `id` | `Int` | Identificador único |
| `nome` | `String` | Nome do nutriente (ex: "Nitrogênio") |
| `sigla` | `String` | Sigla química (ex: "N") |

---

### Entidade: FertilizanteNutriente

Composição nutricional de um fertilizante.

| Campo | Tipo | Descrição |
|---|---|---|
| `id` | `Int` | Identificador único |
| `quantidade` | `Decimal` | Teor do nutriente no fertilizante (%) |
| `teor_nutriente` | `Decimal?` | Teor nutricional |

**Relacionamentos:** `fertilizante`, `nutriente`

---

### Entidade: SolucaoFertilizanteConcentrada

Composição de uma solução nutritiva (quantidades de cada fertilizante concentrado).

| Campo | Tipo | Descrição |
|---|---|---|
| `id` | `Int` | Identificador único |
| `quantidade` | `Decimal` | Quantidade do fertilizante na fórmula |

**Relacionamentos:** `solucao_nutritiva`, `fertilizante`, `concentrada` (SolucaoConcentrada)

---

## Operações de Banco de Dados (GraphQL)

### Autenticação

| Operação | Tipo | Campos Enviados | Campos Retornados |
|---|---|---|---|
| `login` | Mutation | `email`, `senha`, `codigo?` | `token`, `usuario { id, nome, email, ativo, cod_acesso, acesso_externo, pessoa { id, nome }, contas { conta { id, nome, nivel }, cargo { id, cargo, permissoes { permissao { id, nome } } } } }` |

---

### Área de Cultivo

| Operação | Tipo | Campos Enviados | Retorno |
|---|---|---|---|
| `areas` | Query | `contaId` | `id, nome, descricao, tipo, imagem, localizacao { ... }, setores { id, nome, reservatorio { id, nome } }` |
| `createOneArea` | Mutation | `nome, descricao, tipo, contaId, localizacaoId?` | `id, nome, descricao, tipo, created_at, ...` |
| `alterarArea` | Mutation | `areaId, nome, descricao, tipo` | `id, nome, descricao, tipo` |
| `localizacaos` | Query | `contaId` | `id, endereco, numero, bairro, cidade, estado, areas { nome }` |
| `createOneLocalizacao` | Mutation | `cep, endereco, bairro, cidade, estado, pais, complemento?` | `id, cep, endereco, bairro, ...` |

---

### Setor

| Operação | Tipo | Campos Enviados | Retorno |
|---|---|---|---|
| `setors` | Query | `areaId, order, startDate?, endDate?` | `id, nome, descricao, created_at, area { id, nome }, reservatorio { id, nome, volume }, lotes { id, nome }` |
| `createOneSetor` | Mutation | `nome, descricao, areaId, reservatorioId?` | `id, nome, descricao, area { ... }, reservatorio { ... }` |
| `alterarSetor` | Mutation | `setorId, nome, descricao, reservatorioId?` | `id, nome, descricao` |

---

### Lote

| Operação | Tipo | Campos Enviados | Retorno |
|---|---|---|---|
| `lotes` (ativos) | Query | `setorId, order, startDate?, endDate?` | `id, nome, cultura { id, nome }, protocolo { id, nome }, registro_data, colheita_data, bandeijas_semeadas` |
| `lotes` (finalizados) | Query | `setoresId[]` | `id, nome, cultura { id, nome }, registro_data, colheita_data, bandeijas_semeadas` |
| `lote` (detalhes) | Query | `loteId` | `id, nome, setor { id, nome, area { id, nome }, reservatorio { id, nome } }, cultura { id, nome }, protocolo { id, nome }, reservatorio { id, nome }, ativo, registro_data, semeadura_data, transplantio_data, colheita_data, bandeijas_semeadas, mudas_transplantadas, plantas_colhidas, embalagens_produzidas` |
| `createOneLote` | Mutation | `nome, contaId, setorId, culturaId, protocoloId?, reservatorioId?, registroData, semeaduraData?, transplantioData?, colheitaData?` | Lote completo com relações |
| `updateLote` | Mutation | `loteId, loteNome, setorId, culturaId, reservatorioId?, bandeijaSemeadas?, mudasTransplantadas?, plantasColhidas?, embalagensProduzidas?, registroData, semeaduraData?, transplantioData?, colheitaData?` | Lote atualizado |
| `migrarLote` | Mutation | `loteId, setorId, novoReservatorioId?` | `id, nome, setor { ... }, reservatorio { ... }` |
| `finalizarLotes` | Mutation | `lotesId[], plantasColhidas[], embalagensProduzidas[]` | `count` (int) |
| `createOneCultura` | Mutation | `nome, contaId` | `id, nome, privado, created_at, conta { id, nome }` |

---

### Protocolo

| Operação | Tipo | Campos Enviados | Retorno |
|---|---|---|---|
| `protocolos` | Query | `contaId` | `id, nome, cultura { id, nome }, lotes { id, nome, cultura { id, nome } }, sistema_cultivo, tipo_cultura, implantacao, acoes { id, titulo, descricao, alerta, duracao_dias, fase { id, nome } }` |
| `culturas` | Query | `contaId` | `id, nome` (públicas + privadas da conta) |
| `fases` | Query | `contaId` | `id, nome, descricao, duracao_dias` |
| `registrarProtocolo` | Mutation | `nome, culturaId, contaId, sistemaCultivo?, tipoCultura?, implantacao?, acoes[]` | Protocolo completo |
| `atualizarProtocolo` | Mutation | `protocoloId, nome, culturaId, acoes[]` | Protocolo atualizado |
| `registrarFase` | Mutation | `nome, descricao, duracaoDias, contaId` | `id, nome, descricao, duracao_dias` |

---

### Agenda

| Operação | Tipo | Campos Enviados | Retorno |
|---|---|---|---|
| `agendas` | Query | `contaId, dataInicio?, dataFim?` | `id, titulo, descricao, data, ativo, alerta, finalizado, lote { id, nome }, usuario { id, nome }` |
| `agendasAbertasPorLoteId` | Query | `lotesId[]` | `id, titulo, descricao, ativo, alerta, finalizado, data, usuario { id, nome }, lote { id, nome }` |
| `softDeleteAgendaList` | Mutation | `agendasId[]` | `count` (int) |
| `finalizarAgendas` | Mutation | `agendasId[]` | `count` (int) |

---

### Reservatório

| Operação | Tipo | Campos Enviados | Retorno |
|---|---|---|---|
| `reservatorios` | Query | `contaId` | `id, nome, volume, lotes { id, nome }, solucao { id, nome }` |
| `reservatorio` (detalhes) | Query | `reservatorioId` | `id, nome, volume, created_at, lotes { id, nome, bandeijas_semeadas, setor { id, nome } }, solucao { id, nome, solucoes_fertilizantes_concentradas { ... } }` |
| `createOneReservatorio` | Mutation | `nome, volume, contaId, solucaoId?` | `id, nome, volume, created_at, conta { id, nome }, solucao { id, nome }` |
| `updateReservatorio` | Mutation | `reservatorioId, reservatorioNome, reservatorioVolume, contaId, solucaoId?` | `id, nome, volume, conta { ... }, solucao { ... }` |

---

### Soluções Nutritivas

| Operação | Tipo | Campos Enviados | Retorno |
|---|---|---|---|
| `sNutritivas` | Query | `contaId` | `id, nome, c_eletrica, reservatorios { id, nome }` |
| `sNutritiva` (detalhes) | Query | `solucaoId` | `id, nome, c_eletrica, solucoes_contas { conta { nome } }, solucoes_fertilizantes_concentradas { quantidade, fertilizante { nome, fertilizantes_nutrientes { teor_nutriente, nutriente { id, nome, sigla } } } }` |
| `createOneSolucao` | Mutation | `nome, c_eletrica, contaId, fertilizantes[]` | Solução completa |
| `createOneSolucaoConcentrada` | Mutation | `nome, c_eletrica, contaId, fertilizantes[]` | Solução concentrada completa |

---

### Caderno de Campo

| Operação | Tipo | Campos Enviados | Retorno |
|---|---|---|---|
| `lotesComAtividades` | Query | `contaId` | `id, nome, setor { id, nome, area { id, nome } }, lotes_atividades { atividade { id, nome }, usuario { id, nome } }` |
| `atividades` | Query | `contaId` | `id, nome, descricao` |
| `createOneLoteAtividade` | Mutation | `loteId, atividadeId, usuarioId, contaId` | `id, atividade { ... }, lote { ... }, usuario { ... }` |

---

### Gerenciar Equipe

| Operação | Tipo | Campos Enviados | Retorno |
|---|---|---|---|
| `usuarios` | Query | `contaId` | `id, nome, email, ativo, pessoa { nome }, cargo { cargo, permissoes { ... } }` |
| `createOneUsuario` | Mutation | `nome, email, senha, contaId, cargoId, pessoaId?` | Usuario completo com cargo e permissões |
| `updateUsuario` | Mutation | `usuarioId, nome, email, cargoId, ativo` | Usuario atualizado |
| `cargos` | Query | `contaId` | `id, cargo, permissoes { permissao { id, nome } }` |

---

### Ajustes

| Operação | Tipo | Campos Enviados | Retorno |
|---|---|---|---|
| `ajustes` | Query | `contaId, reservatorioId?` | Lista de ajustes com parâmetros de pH, CE, temperatura |
| `createOneAjuste` | Mutation | `contaId, reservatorioId, ph?, ce?, temperatura?` | Ajuste registrado |
| `resultadoAjuste` | Query | `ajusteId` | Resultado calculado do ajuste |

---

### Relatórios

| Operação | Tipo | Campos Enviados | Retorno |
|---|---|---|---|
| `relatorioProducao` | Query | `contaId, periodo?` | `{ title, subtitle, totalUnit, months[], monthlyData[], cultureData[] }` |
| `relatorioStatusLotes` | Query | `contaId` | `{ title, subtitle, statusData[] }` |
| `homeDashboard` | Query | `contaId` | `{ resumo { lotesAtivos, emAberto }, tarefas { total, finalizadas }, producao { total, colheitaPrevista }, culturas[] }` |

---

### Cadastro / Recuperação de Senha

| Operação | Tipo | Campos Enviados | Retorno |
|---|---|---|---|
| `registrarUsuario` | Mutation | `nome, email, senha, telefone?, cnpj?` | Usuario + Conta criados |
| `solicitarRecuperacao` | Mutation | `email` | `{ enviado: Boolean }` |
| `verificarCodigo` | Mutation | `email, codigo` | `{ valido: Boolean }` |
| `novaSenha` | Mutation | `email, codigo, novaSenha` | `{ atualizado: Boolean }` |

---

## Dados Coletados pelo Firebase Analytics

O app coleta eventos de comportamento de navegação para alimentar o sistema de interface adaptativa.

### Evento: `navigation_click`

Disparado a cada navegação explícita do usuário.

| Parâmetro | Tipo | Quando Presente | Descrição |
|---|---|---|---|
| `screen_name` | `String` | Sempre | Rota GetX da tela de destino (ex: `/lotePage`) |
| `hour` | `Int` | Sempre | Hora local do dispositivo (0–23) |
| `day_of_week` | `Int` | Sempre | Dia da semana (1=seg, 7=dom) |
| `user_id` | `String` | Sempre | ID do usuário autenticado no sistema OSI |
| `timestamp` | `String` | Sempre | ISO 8601 do momento da navegação |
| `resource_id` | `String` | Quando disponível | ID do recurso específico (ex: `"87"` para lote #87) |
| `resource_type` | `String` | Quando `resource_id` presente | Tipo: `"lote"`, `"reservatorio"`, `"caderno_campo"` |
| `resource_name` | `String` | Quando disponível | Nome legível do recurso (ex: `"Alface Crespa"`) |

### Evento: `smart_shortcut_click`

Disparado quando o usuário clica em um atalho inteligente na home.

| Parâmetro | Tipo | Descrição |
|---|---|---|
| `route` | `String` | Rota do atalho clicado |
| `confidence` | `Double` | Confiança da recomendação que gerou o atalho |

### Telas Excluídas da Análise

Os seguintes `screen_name` são excluídos das queries BigQuery para evitar viés:

```
/modulosPage, /splashPage, /loginPage, /homePage,
/cadastroPage, /recuperarSenha, /codigoSeguranca, /novaSenha,
/multiAccountsPage, /confirmsegurancaPage, /permissaoNegadaPage
```

---

## Dados Persistidos Localmente (Local Storage)

| Dado | Tipo | Quando Salvo | Quando Removido |
|---|---|---|---|
| `auth_token` | `String` | Após login bem-sucedido | Logout |
| `selected_conta_id` | `Int?` | Após seleção de conta em multi-conta | Logout / troca de conta |
| `user_data` | `JSON` | Após login (dados básicos do usuário) | Logout |

---

## Permissões do Sistema

O sistema implementa controle de acesso baseado em permissões (RBAC) via middlewares GetX. Cada página verifica as permissões do usuário autenticado antes de renderizar.

| Permissão | Cobertura | Páginas Protegidas |
|---|---|---|
| `N1_VIEW` | Visualizar Áreas | `AreaCultivoPage` |
| `N1_EDIT` | Editar/Criar Áreas | `CadastrarAreaCultivoPage` |
| `N2_VIEW` | Visualizar Setores | `SetorPage` |
| `N2_EDIT` | Editar/Criar Setores | `CadastrarSetorPage` |
| `N3_VIEW` | Visualizar Lotes | `LotePage`, `DetalhesLotePage` |
| `N3_EDIT` | Editar/Criar Lotes | `CadastrarLotePage` |
| `CADERNO_CAMPO_VIEW` | Visualizar Caderno | `CadernoCampoPage` |
| `CADERNO_CAMPO_EDIT` | Registrar Atividades | `CadastroCadernoCampoPage` |
| `EQUIPE_VIEW` | Visualizar Equipe | `GerenciarEquipePage` |
| `EQUIPE_EDIT` | Gerenciar Usuários | `CadastrarUsuarioPage`, `DetalhesUsuarioPage` |
| `RESERVATORIO_VIEW` | Visualizar Reservatórios | `ReservatoriosPage`, `DetalhesReservatorioPage` |
| `RESERVATORIO_EDIT` | Editar Reservatórios | `CadastrarReservatoriosPage` |

---

## Integrações Externas

| Serviço | Finalidade | Protocolo | Dados Trafegados |
|---|---|---|---|
| **Backend GraphQL** | Persistência de dados de negócio | HTTPS + JWT | Queries/Mutations de todos os módulos |
| **Firebase Authentication** | Autenticação do usuário | Firebase SDK | UID, email |
| **Firebase Analytics** | Telemetria de uso | Firebase SDK | Eventos de navegação (sem dados sensíveis) |
| **Firebase Cloud Functions** | Motor de recomendação ML | HTTPS Callable | `{ userId, hour }` → `{ dashboard, confidence, shortcuts[] }` |
| **Google BigQuery** | Data warehouse de analytics | Interno à Cloud Function | Export do Firebase Analytics (events_*) |
| **API de CEP** | Busca automática de endereço | HTTPS REST | CEP → `{ endereco, bairro, cidade, estado }` |

---

## Glossário

| Termo | Definição |
|---|---|
| **N1** | Primeiro nível da hierarquia de navegação — Área de Cultivo |
| **N2** | Segundo nível — Setor |
| **N3** | Terceiro nível — Lote |
| **Lote** | Unidade central de produção hidropônica; representa um ciclo de cultivo de uma cultura específica em um setor |
| **Cultura** | Tipo de planta cultivada (ex: Alface, Tomate). Pode ser pública (sistema) ou privada (da conta) |
| **Protocolo** | Template de cultivo com sequência de fases e ações a serem executadas |
| **Fase** | Etapa do protocolo (ex: Semeadura, Berçário, Produção) |
| **Ação** | Tarefa específica dentro de uma fase |
| **Agenda** | Tarefa programada para um lote, com data e responsável |
| **Caderno de Campo** | Registro de atividades realizadas em um lote |
| **Reservatório** | Tanque físico que contém a solução nutritiva usada em um ou mais lotes |
| **Solução Nutritiva** | Formulação de nutrientes dissolvidos em água para irrigação hidropônica |
| **Condutividade Elétrica (CE)** | Medida da concentração de sais na solução (μS/cm), indica nível de nutrição |
| **RBAC** | Role-Based Access Control — controle de acesso baseado em papéis/cargos |
| **Soft-delete** | Remoção lógica (campo `deleted_at` preenchido), o registro não é apagado do banco |
| **Multi-tenant** | Um usuário pode estar vinculado a múltiplas contas com diferentes cargos |
