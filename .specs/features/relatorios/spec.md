# Relatórios — Especificação

**Feature:** Módulo de Relatórios
**Versão:** 1.0
**Data:** 2026-03-24
**Sistemas:** Flutter (osi-solucoes) + API GraphQL NestJS (isis)

---

## Problem Statement

O app possui dados ricos de ciclo de vida dos lotes (semeadura → transplantio → colheita), protocolos com durações previstas por fase, e múltiplas dimensões (cultura, setor, área). Hoje esses dados existem mas não são transformados em insights operacionais. Produtores não conseguem identificar quais culturas cronicamente atrasam, quais setores influenciam desvios, ou comparar performance real vs. planejada — forçando análises manuais fora do app ou decisões baseadas em feeling.

---

## Goals

- [ ] Adicionar aba de Relatórios na navegação principal com acesso centralizado a todos os relatórios
- [ ] Implementar Relatório de Ciclo de Produção por Cultura com cálculo de desvio real vs. previsto
- [ ] Destacar visualmente dados fora do padrão (atrasos e adiantamentos) com distinção positivo/negativo
- [ ] Habilitar exportação dos dados em CSV e PDF para uso externo

---

## Out of Scope

| Feature | Razão |
|---|---|
| Relatórios em tempo real (push/websocket) | Infraestrutura não disponível — relatórios são on-demand |
| Comparação entre fazendas/contas | Multi-conta é escopo separado |
| Machine learning / previsão de colheita | Fora do escopo de análise descritiva (possível V2) |
| Relatório de Qualidade / Nutrição | Próximos relatórios — não fazem parte desta entrega |
| Dashboard home existente | Não alterar os widgets da home, apenas adicionar aba |
| Relatórios relatorioProducao / relatorioStatusLotes existentes | Já implementados — integrar à nova aba sem reescrever |

---

## Contexto Técnico

### Dados disponíveis no Lote

```
semeadura_data    DateTime   — data de semeadura
transplantio_data DateTime   — data de transplantio
colheita_data     DateTime   — data de colheita (preenchida = ciclo encerrado)
cultura           Cultura    — nome da cultura
setor             Setor → Area
protocolo         Protocolo → Acoes[] → Fase
  Acao.duracao_dias   Int    — duração prevista por ação (dias)
  Fase.nome           String — nome da fase (ex: "Germinação", "Transplante")
```

### Cálculo de desvio

```
duração_real_total    = colheita_data - semeadura_data (dias)
duração_planejada     = sum(protocolo.acoes[].duracao_dias)
desvio_dias           = duração_real_total - duração_planejada
desvio_percentual     = (desvio_dias / duração_planejada) * 100

desvio > 0  → atraso   (destaque negativo — vermelho/laranja)
desvio < 0  → adiantado (destaque positivo — verde)
desvio == 0 → dentro do previsto
```

### Fases individuais

```
fase_semeadura_real    = transplantio_data - semeadura_data (dias)
fase_transplantio_real = colheita_data - transplantio_data (dias)
```

> **Nota:** A correlação entre fases do lote e acoes do protocolo por nome é complexa. A V1 trabalha com duração total do ciclo; breakdown por fase individual é V2.

---

## User Stories

### REL-01 · P1: Aba de Relatórios ⭐ MVP

**User Story:** Como produtor, quero acessar relatórios a partir da navegação principal para ter visibilidade analítica do meu negócio sem sair do app.

**Why P1:** Ponto de entrada de todo o módulo. Sem a aba, os relatórios não são acessíveis.

**Acceptance Criteria:**

1. WHEN o usuário abre o app THEN o sistema SHALL exibir uma aba "Relatórios" na barra de navegação inferior
2. WHEN o usuário toca em "Relatórios" THEN o sistema SHALL navegar para a tela de listagem de relatórios disponíveis
3. WHEN a tela de listagem carrega THEN o sistema SHALL exibir cards dos relatórios disponíveis (incluindo os já existentes: Produção, Status de Lotes, e o novo Ciclo por Cultura)
4. WHEN o usuário toca em um card de relatório THEN o sistema SHALL navegar para a tela daquele relatório

**Independent Test:** Abrir app → tocar aba Relatórios → ver lista com ao menos 3 relatórios.

---

### REL-02 · P1: Query API — Ciclo de Produção por Cultura ⭐ MVP

**User Story:** Como sistema, preciso de um endpoint GraphQL que retorne os dados agregados de ciclo de produção agrupados por cultura para alimentar o relatório.

**Why P1:** Sem o endpoint, o relatório não tem dados.

**Acceptance Criteria:**

1. WHEN a query `relatorioCircoCultura(contaId, filtros)` é chamada THEN a API SHALL retornar apenas lotes com `colheita_data` preenchida (ciclo completo)
2. WHEN calculando a duração planejada THEN o sistema SHALL somar `duracao_dias` de todas as `acoes` do protocolo associado ao lote; SE o lote não tiver protocolo, SHALL usar `null` para duração planejada
3. WHEN agrupando por cultura THEN o sistema SHALL calcular: total de lotes, duração real média (dias), duração planejada média (dias), desvio médio (dias e percentual), desvio máximo, desvio mínimo
4. WHEN retornando culturas THEN o sistema SHALL ordenar por `desvio_medio_percentual` ascendente (menor desvio = melhor performance = primeiro)
5. WHEN `filtros.periodo` é informado THEN o sistema SHALL filtrar por `colheita_data` dentro do intervalo
6. WHEN `filtros.culturaIds` é informado THEN o sistema SHALL filtrar somente as culturas informadas
7. WHEN `filtros.setorIds` é informado THEN o sistema SHALL filtrar lotes dos setores informados

**Independent Test:** Chamar a query no GraphQL Playground com `contaId` válido e verificar retorno com culturas agrupadas e métricas calculadas.

---

### REL-03 · P1: Tela do Relatório — Ciclo de Produção por Cultura ⭐ MVP

**User Story:** Como produtor, quero visualizar o relatório de ciclo de produção agrupado por cultura para identificar quais culturas performam melhor ou pior.

**Why P1:** É o core do relatório — a visualização que gera valor.

**Acceptance Criteria:**

1. WHEN o relatório carrega THEN o sistema SHALL exibir um ranking de culturas ordenado do menor para o maior desvio médio
2. WHEN exibindo cada cultura THEN o sistema SHALL mostrar: nome da cultura, total de lotes no período, duração real média (dias), duração planejada média (dias), desvio médio (dias e %)
3. WHEN o desvio de uma cultura for positivo (atraso) THEN o sistema SHALL aplicar destaque visual negativo (cor de alerta — laranja/vermelho)
4. WHEN o desvio de uma cultura for negativo (adiantado) THEN o sistema SHALL aplicar destaque visual positivo (cor de sucesso — verde)
5. WHEN o desvio for ≤ 5% (positivo ou negativo) THEN o sistema SHALL tratar como "dentro do previsto" (sem destaque de cor)
6. WHEN o usuário expandir uma cultura THEN o sistema SHALL exibir a lista individual de lotes daquela cultura com seus desvios individuais
7. WHEN um lote individual tiver desvio > 30% (positivo) THEN o sistema SHALL marcá-lo com badge de alerta
8. WHEN não houver lotes com ciclo completo no período THEN o sistema SHALL exibir estado vazio com mensagem explicativa

**Independent Test:** Abrir relatório com dados reais → verificar ranking de culturas → expandir uma cultura e ver lotes individuais com highlights corretos.

---

### REL-04 · P1: Filtros básicos ⭐ MVP

**User Story:** Como produtor, quero filtrar o relatório por período para analisar um intervalo específico de tempo.

**Why P1:** Sem filtro de período, o relatório traz histórico completo, que pode ser enorme e irrelevante.

**Acceptance Criteria:**

1. WHEN o relatório abre THEN o sistema SHALL aplicar filtro padrão de últimos 6 meses
2. WHEN o usuário toca em "Filtros" THEN o sistema SHALL exibir opções: período (data início / data fim), área, setor, cultura
3. WHEN o usuário altera o período e confirma THEN o sistema SHALL recarregar o relatório com o novo filtro
4. WHEN nenhum lote existe no período filtrado THEN o sistema SHALL exibir estado vazio

**Independent Test:** Alterar período para intervalo sem dados → ver estado vazio. Alterar para período com dados → ver relatório.

---

### REL-05 · P2: Exportação CSV

**User Story:** Como produtor, quero exportar os dados do relatório em CSV para análise em planilhas externas.

**Why P2:** Útil mas não bloqueia o uso do relatório no app.

**Acceptance Criteria:**

1. WHEN o usuário toca em "Exportar CSV" THEN o sistema SHALL gerar um arquivo `.csv` com os dados do relatório atualmente exibido
2. WHEN o CSV é gerado THEN o sistema SHALL incluir as colunas: cultura, total_lotes, duracao_real_media_dias, duracao_planejada_media_dias, desvio_medio_dias, desvio_medio_percentual
3. WHEN o arquivo é gerado THEN o sistema SHALL abrir o seletor de compartilhamento nativo do sistema operacional
4. WHEN ocorrer erro na geração THEN o sistema SHALL exibir snackbar de erro com mensagem

**Independent Test:** Tocar em Exportar CSV → arquivo gerado → compartilhar.

---

### REL-06 · P2: Seção de insights / destaques

**User Story:** Como produtor, quero ver um resumo dos principais insights do relatório (pior cultura, melhor cultura, tendência geral) para ter um diagnóstico rápido sem ler todas as linhas.

**Why P2:** Aumenta muito o valor percebido do relatório mas não é bloqueante.

**Acceptance Criteria:**

1. WHEN o relatório carrega THEN o sistema SHALL exibir uma seção "Destaques" no topo com: cultura com maior atraso médio, cultura com melhor performance, desvio médio geral da conta no período
2. WHEN o desvio médio geral > 10% THEN o sistema SHALL exibir alerta "Produção com atrasos recorrentes"
3. WHEN o desvio médio geral < -5% THEN o sistema SHALL exibir destaque positivo "Produção adiantada no período"

**Independent Test:** Verificar que a seção de destaques aparece no topo com as 3 métricas.

---

### REL-07 · P3: Exportação PDF

**User Story:** Como produtor, quero exportar o relatório em PDF formatado para compartilhar com parceiros ou arquivar.

**Why P3:** Nice-to-have — CSV cobre a maioria dos casos de uso de exportação.

**Acceptance Criteria:**

1. WHEN o usuário toca em "Exportar PDF" THEN o sistema SHALL gerar PDF com logo, título, período, tabela de culturas e destaques
2. WHEN o PDF é gerado THEN o sistema SHALL abrir o seletor de compartilhamento nativo

---

### REL-08 · P3: Análise por setor/área

**User Story:** Como produtor, quero ver se existe correlação entre setor/área e os desvios para identificar fatores ambientais.

**Why P3:** Insight valioso mas requer UI mais complexa e está além do MVP do relatório.

**Acceptance Criteria:**

1. WHEN o usuário ativa o agrupamento por setor THEN o sistema SHALL reagrupar os dados exibindo desvio médio por setor dentro de cada cultura

---

## Edge Cases

- WHEN um lote não tem `protocolo` associado THEN o sistema SHALL exibir duração planejada como "—" e excluir do cálculo de desvio
- WHEN um lote tem `semeadura_data` mas não tem `transplantio_data` ou `colheita_data` THEN o sistema SHALL excluir do relatório (ciclo incompleto)
- WHEN `transplantio_data < semeadura_data` (dado inválido) THEN o sistema SHALL excluir o lote e logar o ID como dado corrompido
- WHEN uma cultura tem apenas 1 lote THEN o sistema SHALL exibir os dados normalmente (média = valor único) com indicação "(1 lote)"
- WHEN o filtro de período é muito abrangente (>2 anos) THEN o sistema SHALL avisar sobre volume de dados e recomendar período menor
- WHEN a API retorna erro THEN o sistema SHALL exibir estado de erro com botão "Tentar novamente"
- WHEN o usuário não tem permissão de conta THEN a API SHALL retornar erro de autenticação

---

---

## Relatório 2 — Produtividade por Setor/Área

> **Contexto:** Cruzando `bandejas_semeadas`, `mudas_transplantadas`, `plantas_colhidas` e `embalagens_produzidas` com setor e área, calcula-se taxas de conversão em cada etapa do ciclo. Expõe gargalos físicos específicos de cada área de cultivo.

### Dados utilizados por Lote

```
bandejas_semeadas       Int   — quantidade de bandejas semeadas
mudas_transplantadas    Int   — quantidade de mudas transplantadas
plantas_colhidas        Int   — quantidade de plantas colhidas
embalagens_produzidas   Int   — quantidade de embalagens produzidas
setor                   Setor → Area
```

### Cálculo das taxas de conversão

```
taxa_germinacao     = mudas_transplantadas / bandejas_semeadas
                      (mudas por bandeja — ex: 48 mudas / 12 bandejas = 4.0)

taxa_transplantio   = plantas_colhidas / mudas_transplantadas * 100
                      (% das mudas que chegam à colheita)

taxa_embalagem      = embalagens_produzidas / plantas_colhidas * 100
                      (% das plantas que viram embalagem)

taxa_global         = embalagens_produzidas / bandejas_semeadas
                      (embalagens por bandeja — indicador síntese)
```

**Query base:** lotes finalizados (`colheita_data` não nulo), filtrados por `setoresId[]`.

---

### PROD-01 · P1: Query API — Produtividade por Setor/Área ⭐ MVP

**User Story:** Como sistema, preciso de um endpoint GraphQL que retorne as taxas de conversão por etapa, agrupadas por setor e área, para alimentar o relatório de produtividade.

**Why P1:** Sem o endpoint, o relatório não tem dados.

**Acceptance Criteria:**

1. WHEN a query `relatorioProdutividadeSetor(contaId, filtros)` é chamada THEN a API SHALL retornar apenas lotes com `colheita_data` preenchida (ciclo completo)
2. WHEN agrupando THEN o sistema SHALL agrupar por `setor → area` calculando: totalLotes, soma de cada campo produtivo, e as 4 taxas de conversão
3. WHEN retornando setores THEN o sistema SHALL ordenar por `taxa_global` descendente (maior conversão = melhor = primeiro)
4. WHEN `filtros.setorIds` é informado THEN o sistema SHALL filtrar somente os setores informados
5. WHEN campos produtivos de um lote forem zero ou nulos THEN o sistema SHALL tratar como zero (sem divisão por zero)
6. WHEN `filtros.periodo` é informado THEN o sistema SHALL filtrar por `colheita_data` dentro do intervalo

**Independent Test:** Chamar a query no GraphQL Playground e verificar retorno com setores agrupados, taxas calculadas e ordenação correta.

---

### PROD-02 · P1: Tela do Relatório — Produtividade por Setor/Área ⭐ MVP

**User Story:** Como produtor, quero visualizar as taxas de conversão por etapa em cada setor/área para identificar onde estão os gargalos físicos da minha produção.

**Why P1:** Core do relatório — a visualização que gera valor operacional.

**Acceptance Criteria:**

1. WHEN o relatório carrega THEN o sistema SHALL exibir uma lista de setores ordenada por `taxa_global` descendente (mais eficiente primeiro)
2. WHEN exibindo cada setor THEN o sistema SHALL mostrar: nome do setor, área, total de lotes, e as 4 taxas de conversão com indicadores visuais
3. WHEN `taxa_transplantio < 70%` THEN o sistema SHALL aplicar destaque visual de alerta (laranja)
4. WHEN `taxa_transplantio < 50%` THEN o sistema SHALL aplicar destaque crítico (vermelho)
5. WHEN `taxa_transplantio ≥ 85%` THEN o sistema SHALL aplicar destaque positivo (verde)
6. WHEN o usuário expandir um setor THEN o sistema SHALL exibir áreas individuais daquele setor com suas taxas
7. WHEN não houver lotes com ciclo completo no período THEN o sistema SHALL exibir estado vazio com mensagem explicativa

**Independent Test:** Abrir relatório com dados → ver ranking de setores → expandir setor e ver áreas com highlights de cor corretos.

---

### PROD-03 · P1: Filtros básicos produtividade ⭐ MVP

**User Story:** Como produtor, quero filtrar o relatório por período, setor e área para analisar intervalos específicos.

**Why P1:** Sem filtro, o relatório traz histórico completo e irrelevante.

**Acceptance Criteria:**

1. WHEN o relatório abre THEN o sistema SHALL aplicar filtro padrão de últimos 6 meses
2. WHEN o usuário toca em "Filtros" THEN o sistema SHALL exibir opções: período (data início/fim), setor, área, cultura
3. WHEN o usuário altera o período e confirma THEN o sistema SHALL recarregar com o novo filtro
4. WHEN nenhum lote existe no período filtrado THEN o sistema SHALL exibir estado vazio

**Independent Test:** Alterar período → ver dados atualizados. Filtrar por setor → ver apenas aquele setor.

---

### PROD-04 · P2: Destaques / Gargalo identificado

**User Story:** Como produtor, quero ver um banner de diagnóstico rápido indicando o principal gargalo do período para tomar ação sem ler todos os números.

**Why P2:** Aumenta muito o valor percebido, mas não bloqueia o uso do relatório.

**Acceptance Criteria:**

1. WHEN o relatório carrega THEN o sistema SHALL exibir seção "Destaques" com: setor mais eficiente (maior taxa_global), setor menos eficiente, e etapa gargalo geral (a etapa com menor taxa média)
2. WHEN `taxa_transplantio_media < 70%` para a conta THEN o sistema SHALL exibir "Gargalo em Transplantio: X% das mudas chegam à colheita"
3. WHEN `taxa_embalagem_media < 80%` THEN o sistema SHALL exibir "Perda no Empacotamento: apenas X% das plantas viram embalagem"
4. WHEN todas as taxas ≥ thresholds THEN o sistema SHALL exibir "Produção dentro dos parâmetros"

**Independent Test:** Verificar que a seção de destaques aparece com gargalo identificado corretamente.

---

### PROD-05 · P2: Exportação CSV

**User Story:** Como produtor, quero exportar os dados de produtividade em CSV para análise externa.

**Why P2:** Útil mas não bloqueia o uso no app.

**Acceptance Criteria:**

1. WHEN o usuário toca "Exportar CSV" THEN o sistema SHALL gerar CSV com: setor, area, total_lotes, bandejas_semeadas, mudas_transplantadas, plantas_colhidas, embalagens_produzidas, taxa_germinacao, taxa_transplantio, taxa_embalagem, taxa_global
2. WHEN gerado THEN o sistema SHALL abrir o seletor de compartilhamento nativo

**Independent Test:** Tocar exportar → arquivo gerado → abre em planilha com dados corretos.

---

### PROD-06 · P3: Comparação entre períodos (Deferred)

**User Story:** Como produtor, quero comparar as taxas de conversão entre dois períodos para identificar tendências.

**Why P3:** Nice-to-have — análise descritiva já cobre o uso principal.

---

---

---

## Relatório 3 — Desempenho da Equipe

> **Contexto:** A entidade `Lotes_Atividades` registra quem executou cada atividade em qual lote. Combinada com a `Agenda` (que tem `finalizado`, `data` e `usuario`), é possível gerar um painel de produtividade por usuário: total de atividades registradas no caderno de campo, tarefas de agenda cumpridas no prazo e taxa de conclusão por período. Visível apenas para gestores com permissão `EQUIPE_VIEW`.

### Dados utilizados

```
Lotes_Atividades:
  fk_usuarios_id   Int   — quem executou a atividade
  fk_atividades_id Int   — qual atividade foi executada (Atividade.nome)
  fk_lotes_id      Int   — em qual lote → Lote.semeadura_data (usado para filtro por período)
  fk_contas_id     Int   — escopo da conta

⚠️ Limitação: Lotes_Atividades não possui created_at. O filtro por período
   é aplicado via Lote.semeadura_data (data de início do lote no período).

Agenda:
  fk_usuarios_id   Int       — responsável pela tarefa
  finalizado       Boolean   — true = tarefa concluída
  data             DateTime  — data/hora prevista (prazo)
  updated_at       DateTime  — usado como proxy de quando foi finalizada
  deleted_at       DateTime  — soft delete
```

### Cálculo das métricas por usuário

```
totalAtividades    = COUNT(Lotes_Atividades)
                     WHERE lote.semeadura_data IN período AND usuario = X

totalAgendas       = COUNT(Agenda)
                     WHERE data IN período AND deleted_at IS NULL AND usuario = X

agendasFinalizadas = COUNT(Agenda)
                     WHERE data IN período AND finalizado = true
                           AND deleted_at IS NULL AND usuario = X

agendasNoPrazo     = COUNT(Agenda)
                     WHERE data IN período AND finalizado = true
                           AND updated_at <= data AND deleted_at IS NULL AND usuario = X
                     ⚠️ Premissa: updated_at reflete quando finalizado foi marcado true

taxaConclusao      = agendasFinalizadas / totalAgendas * 100
                     (% das tarefas do período que foram concluídas)

taxaPrazo          = agendasNoPrazo / agendasFinalizadas * 100
                     (% das concluídas que foram no prazo)
```

---

### EQP-01 · P1: Query API — Desempenho da Equipe ⭐ MVP

**User Story:** Como sistema, preciso de um endpoint GraphQL que retorne as métricas de produtividade por usuário no período para alimentar o relatório de desempenho da equipe.

**Why P1:** Sem o endpoint, o relatório não tem dados.

**Acceptance Criteria:**

1. WHEN a query `relatorioDesempenhoEquipe(contaId, filtros)` é chamada THEN a API SHALL retornar apenas usuários ativos (`ativo = true`) da conta com ao menos uma atividade ou agenda no período
2. WHEN calculando `totalAtividades` THEN o sistema SHALL contar registros em `Lotes_Atividades` onde o lote vinculado tem `semeadura_data` dentro do período
3. WHEN calculando métricas de agenda THEN o sistema SHALL filtrar por `Agenda.data` dentro do período e `deleted_at IS NULL`
4. WHEN calculando `agendasNoPrazo` THEN o sistema SHALL contar agendas onde `finalizado = true` AND `updated_at <= data`
5. WHEN retornando usuários THEN o sistema SHALL ordenar por `totalAtividades` descendente (mais ativo primeiro)
6. WHEN `filtros.periodo` é informado THEN o sistema SHALL usar o intervalo fornecido; SENÃO SHALL aplicar padrão de últimos 6 meses
7. WHEN `filtros.usuarioIds` é informado THEN o sistema SHALL filtrar somente os usuários informados
8. WHEN um usuário não tem nenhuma atividade nem agenda no período THEN o sistema SHALL omiti-lo do resultado

**Independent Test:** Chamar a query no GraphQL Playground com `contaId` válido e verificar retorno com usuários, contagens e taxas corretas.

---

### EQP-02 · P1: Tela do Relatório — Desempenho da Equipe ⭐ MVP

**User Story:** Como gestor com permissão `EQUIPE_VIEW`, quero visualizar o desempenho de cada membro da equipe no período para identificar quem está mais ativo e quem precisa de suporte.

**Why P1:** Core do relatório — a visualização que gera valor gerencial.

**Acceptance Criteria:**

1. WHEN o relatório carrega THEN o sistema SHALL verificar que o usuário possui permissão `EQUIPE_VIEW`; SE não tiver SHALL exibir mensagem de acesso negado
2. WHEN o relatório carrega com dados THEN o sistema SHALL exibir um ranking de usuários ordenado por `totalAtividades` descendente
3. WHEN exibindo cada usuário THEN o sistema SHALL mostrar: nome, total de atividades (caderno de campo), total de agendas no período, agendas finalizadas, taxa de conclusão (%) e taxa no prazo (%)
4. WHEN `taxaConclusao < 50%` THEN o sistema SHALL aplicar destaque de alerta (vermelho)
5. WHEN `taxaConclusao >= 50%` E `< 80%` THEN o sistema SHALL aplicar destaque de atenção (laranja)
6. WHEN `taxaConclusao >= 80%` THEN o sistema SHALL aplicar destaque positivo (verde)
7. WHEN `taxaPrazo < 70%` THEN o sistema SHALL exibir badge "⚠ Atrasos" junto ao nome do usuário
8. WHEN não houver dados no período THEN o sistema SHALL exibir estado vazio com mensagem explicativa
9. WHEN o usuário expandir um membro THEN o sistema SHALL exibir o detalhamento: lista das últimas atividades registradas e agendas pendentes/vencidas

**Independent Test:** Abrir relatório com gestor que tem EQUIPE_VIEW → ver ranking de equipe → expandir membro e ver detalhes. Testar com usuário sem EQUIPE_VIEW → ver bloqueio.

---

### EQP-03 · P1: Filtros básicos e guard de permissão ⭐ MVP

**User Story:** Como gestor, quero filtrar o relatório por período e por membro específico para análises pontuais.

**Why P1:** Filtro de período é essencial; guard de permissão é requisito de segurança não negociável.

**Acceptance Criteria:**

1. WHEN o relatório abre THEN o sistema SHALL aplicar filtro padrão de últimos 6 meses
2. WHEN o usuário toca em "Filtros" THEN o sistema SHALL exibir opções: período (data início/fim) e seleção de membros
3. WHEN o usuário altera o período e confirma THEN o sistema SHALL recarregar com o novo filtro
4. WHEN nenhum dado existe no período filtrado THEN o sistema SHALL exibir estado vazio
5. WHEN o usuário logado não possui permissão `EQUIPE_VIEW` THEN a tela SHALL exibir bloqueio antes de qualquer chamada à API
6. WHEN a API recebe a query sem autenticação válida ou sem permissão THEN SHALL retornar erro de autorização (não dados)

**Independent Test:** Alterar período → ver dados atualizados. Logar com usuário sem EQUIPE_VIEW → ver bloqueio de acesso.

---

### EQP-04 · P2: Seção de destaques da equipe

**User Story:** Como gestor, quero ver um resumo rápido com o membro mais produtivo e os alertas do período para tomar decisão sem ler todos os dados.

**Why P2:** Aumenta muito o valor percebido, mas não bloqueia o uso do relatório.

**Acceptance Criteria:**

1. WHEN o relatório carrega THEN o sistema SHALL exibir seção "Destaques" com: membro com mais atividades, membro com maior taxa de conclusão e média geral de taxa de conclusão da equipe
2. WHEN `taxaConclusaoMedia < 60%` THEN o sistema SHALL exibir alerta "Equipe com baixa taxa de conclusão no período"
3. WHEN algum membro tiver `taxaPrazo < 50%` THEN o sistema SHALL exibir "Membros com atrasos recorrentes: [nomes]"
4. WHEN todas as taxas estiverem dentro dos parâmetros THEN o sistema SHALL exibir "Equipe dentro dos parâmetros no período"

**Independent Test:** Verificar que a seção de destaques aparece com as métricas e alertas corretos conforme os dados.

---

### EQP-05 · P2: Exportação CSV

**User Story:** Como gestor, quero exportar os dados de desempenho em CSV para análise externa ou compartilhamento com RH.

**Why P2:** Útil mas não bloqueia o uso no app.

**Acceptance Criteria:**

1. WHEN o usuário toca "Exportar CSV" THEN o sistema SHALL gerar CSV com: usuario_nome, total_atividades, total_agendas, agendas_finalizadas, agendas_no_prazo, taxa_conclusao_pct, taxa_prazo_pct
2. WHEN gerado THEN o sistema SHALL abrir o seletor de compartilhamento nativo

**Independent Test:** Tocar exportar → arquivo gerado com colunas corretas → abre em planilha.

---

### EQP-06 · P3: Breakdown por tipo de atividade (Deferred)

**User Story:** Como gestor, quero ver quais tipos de atividades cada membro executa mais para entender especialização da equipe.

**Why P3:** Nice-to-have — análise descritiva básica por usuário já cobre o uso principal.

---

---

## Relatório 4 — Agenda e Tarefas Pendentes

> **Contexto:** A entidade `Agenda` registra tarefas com data de início (`dataInicio`), data de fim (`dataFim`), flag de conclusão (`finalizado`), alerta (`alerta`) e vínculo com lote e usuário. Um relatório de tarefas vencidas (não finalizadas com prazo já ultrapassado), tarefas por vencer nos próximos N dias, e taxa de conclusão por lote ativo é de alto valor operacional para o dia a dia — permite antecipar problemas e acompanhar compliance de atividades planejadas.

### Dados utilizados

```
Agenda:
  id               Int       — identificador
  fk_usuarios_id   Int       — responsável pela tarefa
  fk_lotes_id      Int       — lote vinculado (nullable — tarefas gerais)
  fk_contas_id     Int       — escopo da conta
  finalizado       Boolean   — true = tarefa concluída
  dataInicio       DateTime  — data/hora de início prevista
  dataFim          DateTime  — data/hora de fim prevista (prazo)
  alerta           Boolean   — flag de alerta ativo
  deleted_at       DateTime  — soft delete (excluir de todos os cálculos)
  updated_at       DateTime  — proxy de quando foi finalizada

Lote (vinculado via Agenda.fk_lotes_id):
  id               Int
  nome             String
  colheita_data    DateTime  — nulo = lote ativo
  setor            Setor → Area
```

### Cálculo das métricas

```
hoje = DateTime.now()

--- Tarefas vencidas (backlog crítico) ---
vencidas = Agenda WHERE finalizado = false
                   AND dataFim < hoje
                   AND deleted_at IS NULL

--- Tarefas a vencer em N dias ---
proximaData = hoje + N dias
aVencer     = Agenda WHERE finalizado = false
                      AND dataFim >= hoje
                      AND dataFim <= proximaData
                      AND deleted_at IS NULL

--- Taxa de conclusão por lote ativo ---
lotesAtivos = lotes WHERE colheita_data IS NULL

Para cada lote ativo:
  totalTarefas     = COUNT(Agenda WHERE fk_lotes_id = lote.id AND deleted_at IS NULL)
  tarefasConcluidas = COUNT(Agenda WHERE fk_lotes_id = lote.id AND finalizado = true AND deleted_at IS NULL)
  taxaConclusao    = tarefasConcluidas / totalTarefas * 100

  tarefasVencidas  = COUNT(Agenda WHERE fk_lotes_id = lote.id
                                   AND finalizado = false
                                   AND dataFim < hoje
                                   AND deleted_at IS NULL)
```

**Query base:** `agendas` filtradas por `contaId`, `deleted_at IS NULL`. Parâmetro `N` (dias à frente) configurável pelo usuário — padrão: 7 dias.

---

### AGN-01 · P1: Query API — Agenda e Tarefas Pendentes ⭐ MVP

**User Story:** Como sistema, preciso de um endpoint GraphQL que retorne o resumo de tarefas vencidas, a vencer em N dias, e a taxa de conclusão por lote ativo para alimentar o relatório de agenda.

**Why P1:** Sem o endpoint, o relatório não tem dados.

**Acceptance Criteria:**

1. WHEN a query `relatorioAgendaTarefas(contaId, filtros)` é chamada THEN a API SHALL retornar três seções: `tarefasVencidas[]`, `tarefasAVencer[]` e `lotesComTaxaConclusao[]`
2. WHEN calculando `tarefasVencidas` THEN o sistema SHALL retornar agendas com `finalizado = false` AND `dataFim < now()` AND `deleted_at IS NULL`
3. WHEN calculando `tarefasAVencer` THEN o sistema SHALL retornar agendas com `finalizado = false` AND `dataFim >= now()` AND `dataFim <= now() + filtros.diasAVencer` (padrão: 7 dias)
4. WHEN retornando tarefas THEN cada item SHALL incluir: `id`, `titulo` (ou descrição resumida), `dataFim`, `dataInicio`, `alerta`, `usuario.nome`, `lote.nome` (nullable), `setor.nome` (nullable via lote)
5. WHEN calculando taxa de conclusão THEN o sistema SHALL considerar apenas lotes com `colheita_data IS NULL` (lotes ativos)
6. WHEN um lote ativo não tiver nenhuma agenda THEN o sistema SHALL omiti-lo de `lotesComTaxaConclusao`
7. WHEN retornando `lotesComTaxaConclusao` THEN o sistema SHALL ordenar por `tarefasVencidas` descendente (maior número de vencidas = mais crítico = primeiro)
8. WHEN `filtros.usuarioIds` é informado THEN o sistema SHALL filtrar tarefas apenas desses usuários
9. WHEN `filtros.loteIds` é informado THEN o sistema SHALL filtrar tarefas apenas dos lotes informados
10. WHEN `filtros.apenasComAlerta` é `true` THEN o sistema SHALL retornar apenas tarefas onde `alerta = true`

**Independent Test:** Chamar a query no GraphQL Playground com `contaId` válido e verificar retorno com as três seções: vencidas, a vencer e taxas por lote ativo.

---

### AGN-02 · P1: Tela do Relatório — Agenda e Tarefas Pendentes ⭐ MVP

**User Story:** Como produtor/gestor, quero visualizar o painel de agenda com tarefas vencidas, próximas e a taxa de conclusão por lote ativo para antecipar problemas e priorizar meu dia.

**Why P1:** Core do relatório — a visualização operacional que gera valor imediato.

**Acceptance Criteria:**

1. WHEN o relatório carrega THEN o sistema SHALL exibir três seções distintas: "Vencidas", "A Vencer em N dias" e "Conclusão por Lote"
2. WHEN a seção "Vencidas" é exibida THEN o sistema SHALL mostrar contagem total de vencidas e a lista de tarefas ordenada por `dataFim` ascendente (mais antiga = mais urgente = primeiro)
3. WHEN exibindo cada tarefa vencida THEN o sistema SHALL mostrar: título/descrição, prazo (`dataFim`), quantos dias em atraso, responsável e lote vinculado (se houver)
4. WHEN uma tarefa vencida tiver `alerta = true` THEN o sistema SHALL exibir ícone de alerta destacado junto ao item
5. WHEN a seção "A Vencer" é exibida THEN o sistema SHALL listar tarefas ordenadas por `dataFim` ascendente com badge indicando dias restantes (ex: "em 2 dias", "hoje", "amanhã")
6. WHEN uma tarefa a vencer tem prazo ≤ 1 dia THEN o sistema SHALL aplicar destaque urgente (vermelho)
7. WHEN uma tarefa a vencer tem prazo entre 2 e 3 dias THEN o sistema SHALL aplicar destaque de atenção (laranja)
8. WHEN uma tarefa a vencer tem prazo ≥ 4 dias THEN o sistema SHALL exibir sem destaque de cor adicional
9. WHEN a seção "Conclusão por Lote" é exibida THEN o sistema SHALL mostrar lista de lotes ativos com: nome do lote, setor, total de tarefas, concluídas, vencidas e taxa de conclusão (%)
10. WHEN `taxaConclusao < 50%` de um lote THEN o sistema SHALL aplicar destaque crítico (vermelho)
11. WHEN `taxaConclusao >= 50%` E `< 80%` THEN o sistema SHALL aplicar destaque de atenção (laranja)
12. WHEN `taxaConclusao >= 80%` THEN o sistema SHALL aplicar destaque positivo (verde)
13. WHEN um lote tiver tarefasVencidas > 0 THEN o sistema SHALL exibir badge "X vencidas" em vermelho junto ao nome do lote
14. WHEN não houver tarefas vencidas THEN a seção "Vencidas" SHALL exibir estado vazio positivo ("Nenhuma tarefa vencida")
15. WHEN não houver dados em nenhuma seção THEN o sistema SHALL exibir estado vazio geral com mensagem explicativa

**Independent Test:** Abrir relatório com dados reais → ver as três seções → verificar highlights de cor conforme thresholds → confirmar ordenação por urgência.

---

### AGN-03 · P1: Filtros básicos — N dias e responsável ⭐ MVP

**User Story:** Como produtor, quero configurar o horizonte de "a vencer" (N dias) e filtrar por responsável para adaptar o relatório ao meu fluxo diário.

**Why P1:** O parâmetro N é central para o valor do relatório — diferentes operações têm horizontes diferentes (ex: 3 dias vs. 14 dias).

**Acceptance Criteria:**

1. WHEN o relatório abre THEN o sistema SHALL aplicar N = 7 dias como padrão para a seção "A Vencer"
2. WHEN o usuário toca em "Filtros" THEN o sistema SHALL exibir opções: N dias à frente (slider ou campo numérico, range 1–30), seleção de responsáveis, seleção de lotes, filtro "Apenas com alerta"
3. WHEN o usuário altera N e confirma THEN o sistema SHALL recarregar a seção "A Vencer" com o novo horizonte
4. WHEN o usuário seleciona um responsável THEN o sistema SHALL filtrar todas as seções apenas para tarefas daquele usuário
5. WHEN o usuário ativa "Apenas com alerta" THEN o sistema SHALL filtrar somente tarefas com `alerta = true` em todas as seções
6. WHEN nenhuma tarefa existe com os filtros aplicados THEN o sistema SHALL exibir estado vazio por seção

**Independent Test:** Alterar N para 3 dias → ver apenas tarefas com prazo em até 3 dias. Filtrar por responsável → ver apenas tarefas daquele usuário.

---

### AGN-04 · P2: Seção de destaques / diagnóstico rápido

**User Story:** Como gestor, quero ver um resumo de diagnóstico do painel de agenda para ter o estado operacional em segundos sem ler todas as listas.

**Why P2:** Aumenta muito o valor percebido, mas não bloqueia o uso do relatório.

**Acceptance Criteria:**

1. WHEN o relatório carrega THEN o sistema SHALL exibir seção "Destaques" no topo com: total de tarefas vencidas na conta, lote com maior número de tarefas vencidas, usuário com mais tarefas vencidas sob sua responsabilidade
2. WHEN `totalVencidas > 0` THEN o sistema SHALL exibir banner de alerta: "X tarefas vencidas — ação necessária"
3. WHEN `totalVencidas = 0` E `tarefasAVencer > 0` THEN o sistema SHALL exibir banner neutro: "X tarefas a vencer nos próximos N dias"
4. WHEN `totalVencidas = 0` E `tarefasAVencer = 0` THEN o sistema SHALL exibir banner positivo: "Agenda em dia — nenhuma tarefa pendente crítica"
5. WHEN algum lote ativo tiver `taxaConclusao < 50%` THEN o sistema SHALL listar esses lotes como "Lotes com baixa conclusão de tarefas"

**Independent Test:** Verificar que a seção de destaques aparece com o banner correto conforme os dados reais.

---

### AGN-05 · P2: Exportação CSV

**User Story:** Como gestor, quero exportar o painel de agenda em CSV para compartilhar com a equipe ou registrar em ferramentas externas.

**Why P2:** Útil para operações que usam planilhas para acompanhamento diário, mas não bloqueia o uso no app.

**Acceptance Criteria:**

1. WHEN o usuário toca "Exportar CSV" THEN o sistema SHALL gerar dois sheets (ou dois arquivos): um com as tarefas (vencidas + a vencer) e outro com a taxa de conclusão por lote
2. WHEN gerando o CSV de tarefas THEN o sistema SHALL incluir colunas: status (vencida/a_vencer), titulo, data_fim, dias_atraso_ou_restantes, alerta, usuario_nome, lote_nome, setor_nome
3. WHEN gerando o CSV de lotes THEN o sistema SHALL incluir colunas: lote_nome, setor_nome, total_tarefas, tarefas_concluidas, tarefas_vencidas, taxa_conclusao_pct
4. WHEN gerado THEN o sistema SHALL abrir o seletor de compartilhamento nativo

**Independent Test:** Tocar exportar → arquivo gerado com colunas corretas → abre em planilha.

---

### AGN-06 · P3: Notificação push para tarefas vencidas (Deferred)

**User Story:** Como produtor, quero receber notificação push quando uma tarefa vencer para não precisar abrir o relatório manualmente.

**Why P3:** Requer infraestrutura de jobs/schedulers no backend. Fora do escopo desta entrega.

---

### AGN-07 · P3: Histórico de conclusão por lote (Deferred)

**User Story:** Como gestor, quero ver o histórico de taxa de conclusão de tarefas por lote ao longo do ciclo (não só o estado atual) para identificar padrões de descumprimento.

**Why P3:** Análise temporal — a V1 cobre apenas o estado atual (snapshot).

---

## Requirement Traceability

| Requirement ID | Story | Sistema | Status |
|---|---|---|---|
| REL-01 | P1: Aba de Relatórios | Flutter | Pending |
| REL-02 | P1: Query API Ciclo por Cultura | ISIS API | Pending |
| REL-03 | P1: Tela do Relatório | Flutter | Pending |
| REL-04 | P1: Filtros básicos | Flutter + API | Pending |
| REL-05 | P2: Exportação CSV | Flutter | Pending |
| REL-06 | P2: Destaques/Insights | Flutter | Pending |
| REL-07 | P3: Exportação PDF | Flutter | Pending |
| REL-08 | P3: Análise por setor | Flutter + API | Superseded → PROD-XX |
| PROD-01 | P1: Query API Produtividade por Setor | ISIS API | Pending |
| PROD-02 | P1: Tela do Relatório de Produtividade | Flutter | Pending |
| PROD-03 | P1: Filtros básicos produtividade | Flutter + API | Pending |
| PROD-04 | P2: Destaques / gargalo identificado | Flutter | Pending |
| PROD-05 | P2: Exportação CSV produtividade | Flutter | Pending |
| PROD-06 | P3: Comparação entre períodos | Flutter + API | Deferred |
| EQP-01 | P1: Query API Desempenho da Equipe | ISIS API | Pending |
| EQP-02 | P1: Tela do Relatório de Equipe | Flutter | Pending |
| EQP-03 | P1: Filtros básicos + guard EQUIPE_VIEW | Flutter + API | Pending |
| EQP-04 | P2: Destaques da equipe | Flutter | Pending |
| EQP-05 | P2: Exportação CSV equipe | Flutter | Pending |
| EQP-06 | P3: Breakdown por tipo de atividade | Flutter + API | Deferred |
| AGN-01 | P1: Query API Agenda e Tarefas Pendentes | ISIS API | Pending |
| AGN-02 | P1: Tela do Relatório de Agenda | Flutter | Pending |
| AGN-03 | P1: Filtros básicos N dias e responsável | Flutter + API | Pending |
| AGN-04 | P2: Destaques / diagnóstico rápido | Flutter | Pending |
| AGN-05 | P2: Exportação CSV agenda | Flutter | Pending |
| AGN-06 | P3: Notificação push para tarefas vencidas | Flutter + API | Deferred |
| AGN-07 | P3: Histórico de conclusão por lote | Flutter + API | Deferred |

**Coverage:** 27 total, 8 REL (Ciclo por Cultura), 6 PROD (Produtividade Setor), 6 EQP (Desempenho Equipe), 7 AGN (Agenda e Tarefas Pendentes) ✅

---

## Success Criteria

- [ ] Produtor consegue acessar a aba Relatórios em ≤ 2 toques a partir de qualquer tela
- [ ] Relatório de Ciclo por Cultura carrega em < 3s para até 200 lotes
- [ ] Culturas com desvio > 5% são visualmente distinguíveis sem leitura dos números
- [ ] Exportação CSV funciona em Android e iOS com arquivo válido para Excel/Sheets
- [ ] Zero crashes ao abrir relatório com dados vazios ou parcialmente nulos
- [ ] Relatório de Desempenho da Equipe não é acessível sem permissão EQUIPE_VIEW
- [ ] Taxas de conclusão com destaque visual aplicado conforme thresholds
- [ ] Relatório de Agenda exibe tarefas vencidas com destaque vermelho e dias de atraso corretos
- [ ] Parâmetro N dias configurável de 1 a 30 com recarga automática do relatório
- [ ] Lotes com tarefas vencidas exibem badge de alerta com contagem correta
