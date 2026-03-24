# TDD — Sistema de Interface Adaptativa (Home)

| Campo           | Valor                                         |
| --------------- | --------------------------------------------- |
| Tech Lead       | @jvdan                                        |
| Produto         | OSI Soluções — Gestão Hidropônica             |
| Escopo          | Home Screen — Atalhos Inteligentes + Dashboard Adaptativo |
| Status          | Aprovado / Em Implementação                   |
| Criado          | 2026-03-22                                    |
| Última atualização | 2026-03-22                               |

---

## Contexto

O app OSI Soluções é uma plataforma mobile de gestão de produção hidropônica. Operadores e gestores navegam diariamente por múltiplos módulos — Lotes, Agenda, Reservatórios, Protocolos, Histórico, entre outros — dependendo da sua função e da etapa do ciclo produtivo em que se encontram.

A tela inicial (HomePage) serve como ponto de entrada único após o login. Originalmente, ela exibe atalhos fixos e um carousel de dashboard com 4 cards estáticos. Essa abordagem ignora o padrão de uso individual de cada usuário: um operador de campo acessa Lotes pela manhã, enquanto um gestor tende a acessar Histórico e Relatórios à tarde.

O Sistema de Interface Adaptativa foi projetado para personalizar dinamicamente a HomePage com base no histórico real de navegação de cada usuário, usando dados de comportamento coletados pelo Firebase Analytics e processados via BigQuery no GCP.

**Stakeholders:** Usuários finais (operadores e gestores), time de produto, time de engenharia.

---

## Definição do Problema

### Problemas Resolvidos

- **Atalhos fixos ignoram padrões individuais de uso**: Todos os usuários veem os mesmos 4 atalhos (Gerenciar Equipe, Histórico, Agenda, Protocolos), independente de quais módulos realmente utilizam mais.
  - Impacto: Usuários precisam navegar manualmente por 2–4 telas para chegar ao módulo que usarão, acrescentando fricção no fluxo diário.

- **Dashboard estático não reflete prioridade contextual**: O carousel de dashboard sempre inicia no card "Lotes em Produção", mesmo que o usuário trabalhe primariamente com Tarefas ou Produção.
  - Impacto: O card mais relevante não está visível na abertura do app, exigindo swipe manual do usuário.

- **Sem personalização temporal**: O comportamento de uso varia por horário do dia (manhã vs. tarde vs. noite). Um sistema estático não captura essa variação.

### Por Que Agora

- Firebase Analytics já está integrado ao app, produzindo dados de navegação ricos que não estavam sendo utilizados.
- BigQuery export do Firebase Analytics está disponível como feature nativa sem custo adicional de infraestrutura.
- O volume de módulos do app cresceu — personalização passa a ter impacto mensurável na produtividade dos usuários.

### Impacto de Não Resolver

- **UX**: Fricção diária continuada; usuários avançados aprendem a ignorar os atalhos da home.
- **Produto**: Oportunidade de diferenciação perdida — apps SaaS B2B modernos oferecem personalização contextual como feature padrão.

---

## Escopo

### ✅ Em Escopo (V1 — Implementado)

- Coleta de eventos `navigation_click` com parâmetros de contexto (hora, dia, userId, resourceId, resourceType, resourceName)
- Cloud Function `getAdaptiveInterface` que consulta BigQuery e retorna recomendações
- Recomendação de dashboard: qual card do carousel exibir automaticamente ao abrir a home
- Recomendação de atalhos: até 4 telas mais prováveis para o usuário naquele horário
- Suporte a atalhos de recurso específico (ex: "Lote: Alface Crespa")
- Threshold de confiança para aplicação do dashboard (> 0.5)
- Fallback gracioso: se sem dados ou Firebase indisponível → atalhos padrão, sem erro para o usuário
- Completação automática para garantir mínimo de 4 atalhos

### ❌ Fora de Escopo (V1)

- Modelo de ML treinado offline (ex: collaborative filtering, redes neurais) — algoritmo atual é estatístico baseado em frequência
- Personalização por dia da semana (coletado, mas não usado na query)
- Atalhos para mais de 4 itens
- A/B testing de recomendações
- Feedback explícito do usuário (ex: fixar/remover atalho)
- Cache local de recomendações entre sessões
- Dashboard em tempo real (dados do BigQuery têm latência de ~24h pelo export do Analytics)

### 🔮 Considerações Futuras (V2+)

- Modelo ML com collaborative filtering: recomendar baseado em usuários similares
- Cache local: persistir última recomendação para reduzir latência de cold start
- Feedback do usuário: permitir fixar ou ocultar atalhos
- Personalização por dia da semana
- Métricas de eficácia dos atalhos (taxa de clique vs. não clique)

---

## Solução Técnica

### Visão Geral da Arquitetura

O sistema opera em dois fluxos complementares:

1. **Fluxo de Coleta** (write path): a cada navegação no app, um evento é enviado ao Firebase Analytics com metadados de contexto.
2. **Fluxo de Recomendação** (read path): ao abrir a home, o app consulta uma Cloud Function que analisa o histórico no BigQuery e retorna recomendações personalizadas.

```
┌─────────────────────────────────────────────────────────────────┐
│                         FLUTTER APP                             │
│                                                                 │
│  NavigationAnalytics ──→ Firebase Analytics ──────────────────┐ │
│         (write)                                               │ │
│                                                               │ │
│  HomePage                                                     │ │
│    └─ HomeStore                                               │ │
│         └─ AdaptiveInterfaceService ──→ Cloud Function        │ │
│                    (read)                  getAdaptiveInterface│ │
└───────────────────────────────────────────────────────────────┼─┘
                                                                │
                         GCP / Firebase                         │
                                                                │
         Firebase Analytics ──(export diário)──→ BigQuery      │
                                                     ↑          │
                                     Cloud Function queries ────┘
                                     └─ Dashboard Query (com/sem hora)
                                     └─ Shortcuts Query (userId + hora)
```

### Componentes

| Componente | Localização | Responsabilidade |
|---|---|---|
| `NavigationAnalytics` | `lib/core/services/navigation_analytics.dart` | Emite eventos `navigation_click` ao Firebase Analytics |
| `AdaptiveInterfaceService` | `lib/core/services/adaptive_interface_service.dart` | Orquestra chamada à Cloud Function, parseia resposta em `ShortcutModel` |
| `HomeStore` (MobX) | `lib/features/presenter/viewmodels/home_store.dart` | Gerencia estado da interface adaptativa, garante mínimo de 4 atalhos |
| `HomePage` | `lib/features/presenter/views/home/home_page.dart` | Exibe atalhos recomendados, aplica dashboard adaptativo no carousel |
| `ShortcutModel` | `lib/features/presenter/models/shortcut/shortcut_model.dart` | Modelo de dados de um atalho (route, title, icon, confidence, resourceId…) |
| `getAdaptiveInterface` | `firebase-cloud-function/index.js` | Cloud Function que executa queries BigQuery e retorna recomendações |
| **Firebase Analytics** | GCP | Coleta e armazena eventos de navegação |
| **BigQuery** | GCP | Armazena export do Analytics; responde às queries da Cloud Function |

### Fluxo de Coleta de Dados

A cada ação de navegação do usuário, o app registra um evento no Firebase Analytics:

**Evento:** `navigation_click`

| Parâmetro | Tipo | Obrigatório | Descrição |
|---|---|---|---|
| `screen_name` | `string` | Sim | Rota GetX da tela de destino (ex: `/lotePage`) |
| `hour` | `int` | Sim | Hora local do dispositivo (0–23) |
| `day_of_week` | `int` | Sim | Dia da semana (1=segunda, 7=domingo) |
| `user_id` | `string` | Sim | ID do usuário autenticado |
| `timestamp` | `string` | Sim | ISO 8601 |
| `resource_id` | `string` | Não | ID do recurso específico navegado (ex: `"87"`) |
| `resource_type` | `string` | Não | Tipo do recurso: `"lote"`, `"reservatorio"`, `"caderno_campo"` |
| `resource_name` | `string` | Não | Nome legível do recurso (ex: `"Alface Crespa"`) |

O Firebase Analytics exporta esses dados automaticamente ao BigQuery, particionados por data em tabelas `events_YYYYMMDD`.

### Fluxo de Recomendação

```
1. HomePage.initState()
   └─ HomeStore.loadAdaptiveInterface()
       └─ AdaptiveInterfaceService.getAdaptiveInterface()
           ├─ Verifica Firebase inicializado → senão retorna defaults
           ├─ Obtém userId via AuthController
           ├─ Obtém hora atual do dispositivo
           └─ Chama Cloud Function: { userId, hour }
               ↓
           Cloud Function getAdaptiveInterface
               ├─ Valida userId (vazio → retorna vazio)
               ├─ Sanitiza hora (inválida → usa hora do servidor)
               ├─ BigQuery Query 1: Dashboard (userId + hour, últimos 30 dias)
               │   └─ Sem resultados → Query 3: Dashboard (userId, sem hora)
               │   └─ Erro → retorna { dashboard: null, confidence: 0.0 }
               └─ BigQuery Query 2: Shortcuts (userId + hour, últimos 30 dias)
                   └─ Erro → retorna shortcuts: []
               ↓
           Retorna: { dashboard, confidence, shortcuts[] }
               ↓
           AdaptiveInterfaceService parseia response:
               └─ Mapeia cada shortcut para ShortcutModel
               └─ confidence > 0.7 → context = "frequente"
               ↓
           HomeStore recebe AdaptiveInterfaceResponse:
               └─ _ensureMinimumShortcuts() → garante 4 atalhos
               └─ Seta: recommendedShortcuts, adaptiveDashboard, dashboardConfidence
               ↓
           HomePage._applyAdaptiveDashboard():
               └─ Se dashboard != null && confidence > 0.5
                   → PageController.animateToPage(dashboardIndex)
```

### Contrato da Cloud Function

**Input** (via `functions.httpsCallable('getAdaptiveInterface')`):

```json
{
  "userId": "42",
  "hour": 14
}
```

**Output:**

```json
{
  "dashboard": "Lotes em Produção",
  "confidence": 0.73,
  "shortcuts": [
    {
      "route": "/lotePage",
      "confidence": 0.42,
      "resourceId": "87",
      "resourceType": "lote",
      "resourceName": "Alface Crespa"
    },
    {
      "route": "/agendaPage",
      "confidence": 0.28
    }
  ]
}
```

**Valores possíveis para `dashboard`:**

| Valor | Rotas que inferem |
|---|---|
| `"Lotes em Produção"` | `/lotePage`, `/setorPage` |
| `"Tarefas Pendentes"` | `/agendaPage`, `/gerenciarEquipePage` |
| `"Produção Total"` | `/solucaoPage`, `/reservatoriosPage`, `/historicoPage` |
| `"Top Culturas"` | `/protocoloPage`, `/cadernoCampoPage` |

### Lógica de Recomendação no BigQuery

**Query de Dashboard** analisa os `navigation_click` dos últimos 30 dias filtrados por `userId` e `hour`. Mapeia cada rota para uma categoria de dashboard via `CASE WHEN` e retorna a categoria mais frequente com sua proporção de acesso (confidence).

Estratégia de fallback:
1. Com filtro de hora → sem resultados → sem filtro de hora (comportamento geral do usuário)
2. Erro no BigQuery → retorna `{ dashboard: null, confidence: 0.0 }`

**Query de Atalhos** agrupa os eventos por (`target_screen`, `resource_id`, `resource_type`, `resource_name`) — tratando acessos a recursos específicos como atalhos distintos. Calcula a probabilidade de cada combinação como `count / total` e retorna as 4 combinações com probabilidade > 0.1, ordenadas de forma decrescente.

Telas de sistema são excluídas das análises (login, splash, home, etc.) para evitar viés nos resultados.

### Modelo de Dados — ShortcutModel

| Campo | Tipo | Descrição |
|---|---|---|
| `route` | `String` | Rota GetX de destino |
| `title` | `String` | Label base do atalho |
| `icon` | `String` | Caminho do asset SVG |
| `colorHex` | `String` | Cor de destaque em hex (`#RRGGBB`) |
| `confidence` | `double` | Probabilidade do atalho (0.0–1.0) |
| `context` | `String?` | Label contextual — `"frequente"` se confidence > 0.7 |
| `resourceId` | `String?` | ID do recurso específico |
| `resourceType` | `String?` | Tipo: `"lote"`, `"reservatorio"`, `"caderno_campo"` |
| `resourceName` | `String?` | Nome para exibição: `"Lote: Alface Crespa"` |

### Regras de Negócio

| Regra | Valor | Onde aplicado |
|---|---|---|
| Janela de análise | 30 dias | BigQuery (`_TABLE_SUFFIX >= DATE_SUB`) |
| Mínimo de atalhos exibidos | 4 | `HomeStore._ensureMinimumShortcuts()` |
| Máximo de atalhos retornados pela CF | 4 | Cloud Function `.slice(0, 4)` |
| Threshold de probabilidade mínima (atalhos) | > 0.1 | BigQuery `WHERE prob > 0.1` |
| Threshold de confiança para aplicar dashboard | > 0.5 | `HomePage._applyAdaptiveDashboard()` |
| Threshold para label "frequente" | > 0.7 | `AdaptiveInterfaceService._createShortcutFromRoute()` |

---

## Ferramentas GCP Utilizadas

### Firebase Analytics

**Papel:** Ponto de coleta de todos os eventos de comportamento do usuário.

- SDK: `firebase_analytics` (Flutter)
- Eventos emitidos pelo app: `navigation_click`, `smart_shortcut_click`
- Dados coletados por evento: parâmetros de contexto temporais (hora, dia da semana), identificação do usuário, tela de destino, metadados de recurso

**Consideração importante:** O Firebase Analytics não disponibiliza os dados em tempo real para consulta programática. Os eventos são exportados ao BigQuery com latência de ~24h. Portanto, as recomendações refletem o comportamento do usuário até o dia anterior.

### BigQuery

**Papel:** Data warehouse onde o Firebase Analytics exporta os dados. A Cloud Function executa queries SQL diretamente aqui.

- Dataset: `analytics_<APP_ID>` (configurado via variável de ambiente)
- Tabelas: `events_YYYYMMDD` (particionadas por data)
- Queries: 2 queries executadas em paralelo via `Promise.all()` a cada chamada
- Localização: `US`
- Otimização: filtro `_TABLE_SUFFIX >= FORMAT_DATE(...)` limita a leitura às partições dos últimos 30 dias, evitando full table scan

**Permissões necessárias na Service Account da Cloud Function:**
- `BigQuery Data Viewer` no dataset de analytics

### Firebase Cloud Functions

**Papel:** Camada de processamento serverless que orquestra as queries BigQuery e expõe a recomendação ao app via chamada autenticada.

- Runtime: Node.js 22
- Tipo: `onCall` (HTTPS Callable — autenticação gerenciada pelo Firebase SDK)
- Dependências: `firebase-functions`, `firebase-admin`, `@google-cloud/bigquery`
- Variáveis de ambiente: `BIGQUERY_PROJECT_ID`, `BIGQUERY_ANALYTICS_DATASET`

**Fluxo de autenticação:** O SDK do Flutter (`firebase_functions`) envia automaticamente o Firebase Auth token do usuário no header da requisição. A Cloud Function verifica esse token via `context.auth`. O `userId` pode vir do payload ou do `context.auth.uid`.

---

## Considerações de Segurança

### Autenticação e Autorização

- A Cloud Function usa o tipo `onCall` do Firebase Functions, que exige que o chamador esteja autenticado via Firebase Authentication. Requisições não autenticadas são rejeitadas automaticamente pelo SDK.
- O `userId` usado nas queries é sanitizado (`String.trim()`) e validado (vazio → retorna resposta vazia, sem execução de query).
- As queries BigQuery são parametrizadas (`params: { userId, hour }`), eliminando risco de SQL injection.

### Privacidade dos Dados

- Os dados analisados (rotas navegadas, horário, recurso acessado) são **dados comportamentais de uso**, não PII sensível.
- O `userId` no BigQuery é o ID interno do sistema OSI Soluções, não um identificador pessoal como CPF ou e-mail.
- Não são coletados: localização, dados biométricos, dados financeiros, senhas.

### Secrets e Configuração

- As variáveis `BIGQUERY_PROJECT_ID` e `BIGQUERY_ANALYTICS_DATASET` são injetadas via Firebase Functions config (não commitadas no código).
- As credenciais GCP são gerenciadas pela Service Account da Cloud Function, sem chaves expostas no código do app.

### Dados Enviados pelo App à Cloud Function

O app envia apenas `{ userId, hour }` — sem dados sensíveis. O `userId` é o ID do usuário autenticado no sistema OSI, obtido via `AuthController`.

---

## Estratégia de Testes

| Tipo | Escopo | Cenários Críticos |
|---|---|---|
| **Testes Unitários** | `AdaptiveInterfaceService`, `HomeStore`, `ShortcutModel` | Parse correto do response; `displayTitle` com e sem resource; `_ensureMinimumShortcuts` com 0, 2 e 4+ atalhos |
| **Testes de Integração** | Chamada real à Cloud Function (emulador local) | Resposta válida com dados; fallback com userId inválido; fallback com hora inválida |
| **Testes de Widget** | `HomePage` | Atalhos aparecem após carregamento; dashboard animado quando confidence > 0.5; fallback para atalhos padrão em erro |
| **Testes da Cloud Function** | `index.js` com BigQuery mockado | Dashboard retornado quando há dados; fallback sem hora; retorno vazio quando sem dados |

**Cenários de fallback obrigatórios a testar:**
- Firebase não inicializado → atalhos padrão, sem crash
- Cloud Function indisponível → atalhos padrão, sem crash
- BigQuery sem resultados para userId+hora → fallback para query sem hora
- Dashboard com confidence ≤ 0.5 → carousel não animado
- Response com 0 shortcuts → 4 atalhos padrão exibidos
- Response com 2 shortcuts → 2 recomendados + 2 padrão (sem duplicatas)

---

## Monitoramento e Observabilidade

### Logs do App (Flutter)

O sistema emite logs prefixados para facilitar o rastreamento:

| Prefixo | Componente |
|---|---|
| `[ANALYTICS]` | `NavigationAnalytics` |
| `[ADAPTIVE]` | `AdaptiveInterfaceService` |
| `[HOME_STORE]` | `HomeStore` |
| `[HOME_PAGE]` | `HomePage` |

Informações logadas em cada chamada:
- userId e hora enviados à Cloud Function
- Tempo de resposta da Cloud Function (ms)
- Dashboard recomendado e sua confiança
- Quantidade e lista de atalhos recebidos vs. atalhos finais exibidos
- Motivo de fallback quando ativado

### Logs da Cloud Function (GCP Cloud Logging)

| Log | Situação |
|---|---|
| `[CF] Buscando interface adaptativa — userId="X" hour=N` | Início de cada invocação |
| `[CF] Dashboard: "X" (73.0%)` | Resultado do dashboard |
| `[CF] Sem dados para hora N, usando fallback sem hora` | Fallback de hora ativado |
| `[CF] N atalho(s) recomendado(s)` | Resultado dos atalhos |
| `[CF] Erro ao buscar dashboard: ...` | Falha na query (não quebra o fluxo) |
| `[CF] Variáveis de ambiente obrigatórias não configuradas` | Misconfiguration — requer ação imediata |

### Métricas a Monitorar (GCP)

| Métrica | Fonte | Alerta Sugerido |
|---|---|---|
| Invocações da Cloud Function | Cloud Functions Metrics | Pico anormal (> 10x média) |
| Erros da Cloud Function | Cloud Functions Metrics | Taxa de erro > 5% em 10 min |
| Latência da Cloud Function | Cloud Functions Metrics | p95 > 3s |
| Leituras BigQuery (bytes processados) | BigQuery Metrics | Pico > 10x média diária |
| Erros de autenticação Firebase | Firebase Console | Qualquer spike |

### Rastreabilidade dos Dados

- Cada evento `navigation_click` no BigQuery está associado ao `userId` e ao timestamp.
- É possível auditar o histórico de navegação de um usuário específico com uma query simples no BigQuery filtrando por `userId`.

---

## Plano de Rollback

### Estratégia de Degradação Graciosa

O sistema foi projetado com fallback em todas as camadas — **não existe "ponto único de falha"** que cause erro para o usuário:

| Falha | Comportamento | Visível ao usuário? |
|---|---|---|
| Firebase não inicializado no app | Atalhos padrão exibidos | Não |
| Cloud Function retorna erro HTTP | Atalhos padrão exibidos | Não |
| BigQuery sem dados para o usuário | Dashboard null, shortcuts padrão | Não |
| BigQuery com erro de query | Fallback interno na CF, retorno vazio | Não |
| Confidence do dashboard ≤ 0.5 | Carousel não animado, permanece no índice 0 | Não |
| Menos de 4 atalhos recomendados | Completado com atalhos padrão | Não |

### Rollback da Cloud Function

Se uma nova versão da Cloud Function causar regressão:

1. Fazer re-deploy da versão anterior via Firebase CLI
2. A Cloud Function é stateless — não há necessidade de rollback de dados
3. O app Flutter continua funcionando com atalhos padrão enquanto a função está indisponível

### Rollback do App (se necessário desativar a feature)

A feature pode ser desabilitada no app sem novo deploy alterando o `AdaptiveInterfaceService` para retornar diretamente os atalhos padrão, ou adicionando um feature flag verificado antes de chamar a Cloud Function.

### Triggers para Investigação

- Spike de erros no prefixo `[ADAPTIVE]` nos logs do Firebase Crashlytics
- Cloud Function com taxa de erro > 10% em Cloud Monitoring
- Relatórios de usuários sobre atalhos incorretos ou tela inicial em posição errada

---

## Plano de Implementação

| Fase | Tarefa | Status |
|---|---|---|
| **1 — Coleta** | `NavigationAnalytics.logNavigation()` com parâmetros de contexto | ✅ Concluído |
| **1 — Coleta** | Integração do `logNavigation` nos pontos de navegação do app | ✅ Concluído |
| **1 — Coleta** | `logShortcutClick` para rastrear uso dos atalhos recomendados | ✅ Concluído |
| **2 — Backend** | Cloud Function `getAdaptiveInterface` com queries BigQuery | ✅ Concluído |
| **2 — Backend** | Fallback de dashboard (com hora → sem hora) | ✅ Concluído |
| **2 — Backend** | Suporte a atalhos de recurso específico (resourceId/Type/Name) | ✅ Concluído |
| **3 — App** | `AdaptiveInterfaceService` + `ShortcutModel` | ✅ Concluído |
| **3 — App** | `HomeStore.loadAdaptiveInterface()` com MobX | ✅ Concluído |
| **3 — App** | `HomePage._applyAdaptiveDashboard()` + exibição de atalhos adaptativos | ✅ Concluído |
| **4 — Bug Fix** | Navegação de atalhos de lote específico (loteSelecionado não preparado) | 🔴 Pendente |
| **5 — Qualidade** | Testes unitários e de widget | ⏳ Pendente |
| **5 — Qualidade** | Monitoramento de métricas em produção | ⏳ Pendente |

> **Bug conhecido (Fase 4):** Atalhos do tipo `resourceType = "lote"` que navegam para `detalhesLotePage` falham pois o `loteStore.loteSelecionado` não é preparado antes da navegação. Fix documentado em `.specs/features/smart-shortcut-navigation/spec.md` — requer adicionar `buscarLotePorId(int id)` no `LoteStore`.

---

## Alternativas Consideradas

| Opção | Prós | Contras | Por Que Não Escolhida |
|---|---|---|---|
| **Frequência simples no app (escolhida)** | Sem infraestrutura extra; dados já existentes no Firebase Analytics; sem modelo a treinar | Latência dos dados (~24h); sem colaboração entre usuários | ✅ Escolhida — melhor custo-benefício para V1 |
| Modelo ML treinado (ex: TensorFlow Lite on-device) | Predição em tempo real; sem latência de dados | Requer dataset rotulado; modelo a treinar e versionar; tamanho do app aumenta | Complexidade desproporcional para V1 |
| Collaborative Filtering via API externa | Aprende de padrões coletivos de usuários | Depende de volume de usuários; latência de API; custo | Prematura para o estágio atual do produto |
| Personalização manual (usuário configura atalhos) | Controle total do usuário; sem dependência de dados | Atrito de configuração; maioria dos usuários não configura | Não resolve o problema de forma automática |

---

## Glossário

| Termo | Definição |
|---|---|
| **Interface Adaptativa** | Sistema que personaliza a UI da home com base no comportamento histórico do usuário |
| **Atalho Inteligente** | Shortcut na home gerado por recomendação de ML/estatística, em oposição a atalhos fixos |
| **Atalho de Recurso** | Atalho que aponta para um recurso específico (ex: "Lote: Alface Crespa") além da tela genérica |
| **Dashboard Adaptativo** | Card do carousel de resumo que é exibido automaticamente com base na categoria de uso do usuário |
| **Confidence** | Proporção de acessos a uma categoria/tela em relação ao total de navegações do usuário no período |
| **Threshold** | Valor mínimo de confiança para que uma recomendação seja aplicada automaticamente |
| **Fallback** | Comportamento padrão ativado quando não há dados suficientes ou ocorre erro |
| **navigation_click** | Nome do evento Firebase Analytics que representa toda navegação explícita do usuário |
| **events_*** | Padrão de nomenclatura das tabelas particionadas por data no BigQuery |
| **onCall** | Tipo de Cloud Function com autenticação Firebase integrada, invocável diretamente pelo SDK mobile |

---

## Questões em Aberto

| # | Questão | Status |
|---|---|---|
| 1 | Cache local da última recomendação para evitar cold start na abertura do app | 🔴 Aberta (V2) |
| 2 | Como medir eficácia dos atalhos recomendados vs. não clicados? | 🔴 Aberta |
| 3 | Threshold de confiança de 0.5 para dashboard é o valor ideal? Necessita validação com dados reais | 🟡 Em investigação |
| 4 | Fix de navegação de atalhos de lote específico | 🔴 Em desenvolvimento — spec em `.specs/features/smart-shortcut-navigation/spec.md` |
| 5 | Latência de ~24h dos dados é aceitável para todos os casos de uso? | 🟡 Aceito para V1 |
