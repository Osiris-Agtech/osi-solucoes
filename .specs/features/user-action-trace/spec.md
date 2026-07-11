# UserActionTrace — Rastro de Ações do Usuário

## ID: FEAT-UAT-001

## Problema

O payload enviado à API de adaptação (`getAdaptiveInterface`) contém apenas o **estado atual** do sistema (dashboard, agenda, produção, etc.), mas não informa **quais ações o usuário executou recentemente**. A única exceção é `lastAgendaInteraction`, que cobre exclusivamente interações com a Agenda.

Isso limita a capacidade da API de inferir o próximo passo: sem saber o que o usuário acabou de fazer (criar lote, editar reservatório, anotar caderno de campo...), a adaptação fica dependente apenas do estado estático.

## Objetivo

Criar um mecanismo leve para que **todas as stores do frontend** registrem as ações do usuário (criação, edição, exclusão, conclusão) em um trace centralizado. Esse trace é consumido pelo `InstantOperationalContextMapper` e enviado no payload da API de adaptação como `recentUserActions`.

## Requisitos

### REQ-01: Serviço UserActionTrace
- `lib/core/services/user_action_trace.dart`
- Classe `UserActionTrace` com método `record(UserAction action)`
- Mantém lista dos últimos N eventos (N=5)
- Método `consume()` retorna lista de mapas serializáveis e limpa o trace
- Registrado como `LazySingleton` no GetIt

### REQ-02: Modelo UserAction
- `entityType` (String) — `'lot'`, `'reservoir'`, `'field_note'`, `'protocol'`, `'nutritional_solution'`, `'cultivation_area'`, `'sector'`, `'team_member'`, `'agenda_activity'`
- `action` (String) — `'created'`, `'edited'`, `'deleted'`, `'completed'`
- `entityId` (int?) — ID da entidade
- `entityName` (String?) — Nome legível da entidade
- `timestamp` (DateTime) — momento da ação

### REQ-03: Stores registram ações
Cada store deve chamar `GetIt.I<UserActionTrace>().record(...)` após mutações bem-sucedidas:

| Store | Ações | entityType |
|---|---|---|
| `agenda_store.dart` | created, edited, deleted, completed | `agenda_activity` |
| `lote_store.dart` | created, edited, deleted | `lot` |
| `caderno_campo_store.dart` | created, edited, deleted | `field_note` |
| `reservatorios_store.dart` | created, edited, deleted | `reservoir` |
| `protocolo_store.dart` | created, edited, deleted | `protocol` |
| `solucao_store.dart` | created, edited, deleted | `nutritional_solution` |
| `area_cultivo_store.dart` | created, edited, deleted | `cultivation_area` |
| `setor_store.dart` | created, edited, deleted | `sector` |
| `gerenciar_equipe_store.dart` | created, edited, deleted | `team_member` |

### REQ-04: Mapper consome trace
- `InstantOperationalContextMapper` obtém `UserActionTrace` do GetIt
- Chama `trace.consume()` antes de montar o `OperationalContext`
- Adiciona campo `recentUserActions` no JSON final

### REQ-05: Migrar pendingActivity*
- `HomeStore.pendingActivityTitle`, `pendingActivityDescription`, `pendingActivityInteractionType` são removidos (substituídos pelo `UserActionTrace`)
- `AgendaStore` para de setar `homeStore.pendingActivity*` e passa a usar `UserActionTrace`
- `consumePendingActivityContext()` removido do `HomeStore`

### REQ-06: Payload da API
O payload final deve conter:
```json
{
  "operationalContext": {
    "...": "...",
    "recentUserActions": [
      {
        "entityType": "lot",
        "action": "created",
        "entityId": 42,
        "entityName": "Lote A12",
        "timestamp": "2026-07-10T15:13:59.000Z"
      }
    ]
  }
}
```

## Não-escopo
- Persistência de ações entre sessões (apenas em memória)
- Histórico completo de navegação (apenas mutações CRUD)
- Testes automatizados (implementação mínima, sem infra de teste)

## Critérios de aceitação
1. `UserActionTrace` registra e consome ações corretamente
2. Pelo menos 5 stores registram ações após mutações
3. `recentUserActions` aparece no payload da API de adaptação
4. Código compila sem erros (Flutter analyze)
