# Spec de Feature: CRUD de Fertilizantes Tenant-Aware (UX + Fluxo App)

- **Repo:** `osi-solucoes`
- **Path:** `.specs/features/fertilizantes-crud-tenant/spec.md`
- **Status:** Proposta
- **Última atualização:** 2026-04-26
- **Responsáveis:** Frontend/App

---

## 1) Contexto (por que esta feature existe)

O app já consome `fertilizantesCatalogo(contaId)` e já exibe badge “Sistema”.  
Falta completar experiência de CRUD de fertilizantes custom no app, garantindo regras de domínio:
- usuário gerencia apenas itens custom do próprio tenant
- itens de sistema são visíveis mas não editáveis/excluíveis
- `origin` precisa ser corretamente desserializado (risco atual de `null` em model gerado)

Sem isso, há risco de ações indevidas na UI e inconsistência entre backend e experiência do usuário.

---

## 2) Goals e Non-Goals

### Goals
1. Disponibilizar fluxo completo de criação, edição e exclusão de fertilizantes custom no app.
2. Aplicar regra visual e funcional para `SYSTEM` vs `CUSTOM`.
3. Corrigir alinhamento de serialização/desserialização para `origin` no modelo gerado.
4. Tratar estados de erro de escopo/permissão vindos da API.
5. Preservar consistência visual quando fertilizantes históricos estiverem deletados.

### Non-Goals
1. Redesenho completo da tela de soluções.
2. Mudança de arquitetura de estado global além do necessário para esta feature.
3. Criação de novas capacidades administrativas multi-tenant.
4. Alteração de semântica de negócio definida no backend.

---

## 3) Escopo funcional (UX/fluxo)

### RF-UI-01 — Listagem de catálogo
- Exibir fertilizantes retornados pelo catálogo com distinção clara de origem.
- Badge “Sistema” para `origin=SYSTEM`.
- Itens `CUSTOM` distinguíveis e elegíveis a ações de edição/exclusão.

### RF-UI-02 — Criar fertilizante custom
- Disponibilizar ação de “Novo fertilizante”.
- Validar campos obrigatórios no cliente (sem substituir validação do backend).
- Após sucesso, atualizar lista sem exigir reinício de tela.

### RF-UI-03 — Editar fertilizante custom
- Ação visível apenas para `CUSTOM`.
- Ao salvar, refletir alteração imediatamente no estado de tela.
- Tratar erros com feedback claro ao usuário.

### RF-UI-04 — Excluir (soft delete) fertilizante custom
- Ação visível apenas para `CUSTOM`.
- Confirmar exclusão antes de executar.
- Ao sucesso, remover item da listagem operacional.

### RF-UI-05 — Bloqueio de ações em SYSTEM
- Para itens `SYSTEM`, não renderizar ou desabilitar ações destrutivas.
- Se backend retornar erro por tentativa indevida, UI deve exibir mensagem coerente.

### RF-UI-06 — Contrato de `origin` confiável no app
- Modelo serializado deve mapear `origin` corretamente.
- `origin` não pode ser tratado como sempre `null` em fluxo normal.
- Caso payload venha inconsistente, UI deve entrar em fallback seguro (sem liberar ações perigosas).

### RF-UI-07 — Compatibilidade com histórico
- Quando histórico de solução incluir fertilizante deletado, app deve renderizar estado legível (ex.: “Removido”/“Inativo”) sem quebrar tela.

---

## 4) Abordagem técnica e decisões de design

1. **Feature-gating por `origin`**
   - Ações de editar/excluir condicionadas estritamente a `origin=CUSTOM`.

2. **Fonte da verdade no backend**
   - UI nunca infere permissão apenas por layout; erros de API devem ser tratados.
   - Mesmo com botão oculto, resposta de erro de domínio deve ser suportada.

3. **Modelo tipado alinhado ao contrato**
   - Regenerar/ajustar model para garantir mapeamento de enum `origin`.
   - Evitar default permissivo quando `origin` for desconhecido/nulo.

4. **Atualização de estado previsível**
   - Após create/update/delete, invalidar/recarregar catálogo do tenant ou atualizar store local de forma consistente.
   - Evitar itens fantasmas (stale cache) após delete.

5. **Fallback seguro para dados legados**
   - Se `origin` vier ausente, item deve ser tratado como não editável até correção de dados.

---

## 5) Estruturas de dados / interfaces envolvidas

### 5.1 Modelo de domínio no app (conceitual)
- `FertilizanteModel`
  - `id`
  - campos funcionais já existentes no app
  - `origin: SYSTEM | CUSTOM` (esperado)
  - metadados opcionais de estado (ex.: deletado/inativo em histórico)

### 5.2 Contrato GraphQL consumido
- Query catálogo tenant-aware com `origin`.
- Mutations de create/update/softDelete custom.
- Erros de domínio/autorização convertidos para mensagens de UX.

### 5.3 Estado de tela (conceitual)
- `catalogoLoading`
- `catalogoData`
- `catalogoError`
- `mutationState` (submit em andamento, sucesso, erro)

---

## 6) Critérios de aceite (WHEN/THEN)

1. **WHEN** usuário abre tela de fertilizantes  
   **THEN** visualiza catálogo com badge “Sistema” nos itens `SYSTEM`.

2. **WHEN** item é `SYSTEM`  
   **THEN** ações de editar/excluir não ficam disponíveis (ou ficam desabilitadas sem execução).

3. **WHEN** usuário cria fertilizante válido  
   **THEN** item aparece como `CUSTOM` na listagem do tenant após sucesso.

4. **WHEN** usuário edita fertilizante `CUSTOM`  
   **THEN** alteração é refletida na lista sem inconsistência de estado.

5. **WHEN** usuário exclui fertilizante `CUSTOM` e confirma ação  
   **THEN** item sai da listagem operacional.

6. **WHEN** backend retorna erro de escopo/permissão em mutation  
   **THEN** UI mostra feedback de erro e não aplica mudança local incorreta.

7. **WHEN** payload de catálogo chega com `origin` válido  
   **THEN** app desserializa corretamente e aplica regras de ação por origem.

8. **WHEN** payload chega sem `origin` (cenário legado/anômalo)  
   **THEN** app entra em fallback seguro: não habilita edição/exclusão para o item.

9. **WHEN** histórico de solução inclui fertilizante deletado  
   **THEN** tela renderiza registro histórico sem crash, com indicação de item inativo/removido.

---

## 7) Edge cases

1. Usuário dispara múltiplos submits de create/update rapidamente.
2. Delete concluído no backend, mas lista local não atualizada por cache stale.
3. `origin` inesperado (valor fora do enum) vindo da API.
4. Falha de rede entre confirmação de delete e refresh da lista.
5. Item removido em outra sessão/dispositivo durante edição local.
6. Erro de autorização retornado mesmo com botão oculto (defesa em profundidade).

---

## 8) Open questions (precisam de clarificação)

1. Qual padrão de mensagem UX para erros de domínio (`SYSTEM_FERTILIZER_IMMUTABLE`, escopo, não encontrado)?
2. A tela deve agrupar visualmente por origem (Sistema vs Personalizados) ou apenas usar badge?
3. Em histórico, qual label oficial para fertilizante deletado: “Removido”, “Inativo” ou outro?
4. Estratégia final de sincronização após mutation: refetch completo ou atualização otimista com rollback?
5. Existe convenção de telemetria já ativa para registrar falhas de mutation dessa tela?

---

## 9) Rastreabilidade de requisitos

| ID | Requisito | Gap de origem | Camada | Critério de aceite relacionado |
|---|---|---|---|---|
| RF-UI-01 | Listagem com origem visível | CRUD incompleto | Tela catálogo | CA-1 |
| RF-UI-02 | Create custom | CRUD incompleto | Form + mutation | CA-3 |
| RF-UI-03 | Update custom | CRUD incompleto | Form + mutation | CA-4 |
| RF-UI-04 | Delete custom | CRUD incompleto | Ação + mutation | CA-5 |
| RF-UI-05 | Bloqueio em SYSTEM | Regra domínio | UI permissões | CA-2, CA-6 |
| RF-UI-06 | `origin` alinhado no model | Gap `g.dart` | Serialização/modelo | CA-7, CA-8 |
| RF-UI-07 | Histórico robusto | Gap histórico | Tela histórico | CA-9 |

---

## 10) Dependências e impacto

- Dependente do backend retornar `origin` de forma consistente no catálogo/histórico relevante.
- Dependente de padronização de erros de domínio para mensagens previsíveis na UI.
- Pode exigir ajuste de testes de widget/integration da jornada CRUD.
