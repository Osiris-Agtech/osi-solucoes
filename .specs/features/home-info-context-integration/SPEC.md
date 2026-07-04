# SDD — Home Info Context Integration

**Feature ID:** `home-info-context-integration`
**Status:** Draft
**Author:** AI Architect
**Date:** 2026-07-02

---

## 1. Overview

Integrate the Flutter app `osi-solucoes` with the new `infoContext` field from the ISIS `homeDashboard` GraphQL query and the `infoRecommendation` field from the `getAdaptiveInterface` Cloud Function. The Home page will display four ordered sections: **greeting → shortcuts → info card → modules**, where the info card content varies dynamically based on adaptive mode and available data.

---

## 2. Context & Current State

### 2.1 Existing Architecture

- **Home Dashboard** (`homeDashboard` query via GraphQL) returns `resumo`, `tarefas`, `producao`, `culturas`, `equipe`, `alertasCritico`. No `infoContext` field exists yet.
- **Adaptive Interface** (`getAdaptiveInterface` Cloud Function) returns dashboard recommendations and shortcuts. In `INSTANT` mode, `getInstantAdaptiveInterface` also returns `InstantAdaptiveHomeViewData` (nextStep, focusBanner, recommendedActions, etc.), but **no `infoRecommendation` field**.
- **Home layout** (`HomeDailyPanelContent`) currently renders: header → todayCultivationPanel → productionSummary → recommendedActions → modules (in that order). No dedicated info card exists.
- **Metrics** are tracked via `MetricsTrackingService` for shortcuts, nextStep, adaptation, but no `info_card_shown`/`info_card_clicked` events.

### 2.2 Key Files (to be modified or created)

| File | Responsibility | Change Type |
|------|---------------|-------------|
| `lib/features/data/datasources/homeDashboard/home_dashboard_datasource.dart` | GraphQL query | Modify |
| `lib/features/presenter/models/homeDashboard/home_dashboard_model.dart` | Dart models for `infoContext` | Modify |
| `lib/features/presenter/views/home/models/home_panel_view_data.dart` | View data classes | Modify |
| `lib/features/presenter/views/home/models/home_panel_mapper.dart` | Mapping dashboard → view data | Modify |
| `lib/features/presenter/views/home/components/home_daily_panel_content.dart` | Home layout | Modify |
| `lib/features/presenter/views/home/components/home_daily_panel_sections.dart` | Barrel exports | Modify |
| `lib/features/presenter/views/home/components/recommended_actions_section.dart` | Shortcuts section | Modify (possibly minor) |
| `lib/features/presenter/views/home/components/home_modules_section.dart` | Modules section | No change expected |
| `lib/features/presenter/views/home/adaptive/instant_adaptive_home_view_data.dart` | `InfoRecommendationViewData` | Modify |
| `lib/features/presenter/views/home/adaptive/instant_adaptive_home_mapper.dart` | Parse `infoRecommendation` | Modify |
| `lib/features/presenter/views/home/adaptive/instant_operational_context_mapper.dart` | Sanitized operational context | Modify |
| `lib/features/presenter/views/home/adaptive/client_capabilities_mapper.dart` | Client capabilities payload | Modify |
| `lib/core/services/adaptive_interface_service.dart` | Service for adaptive interface | Modify |
| `lib/core/services/metrics_tracking_service.dart` | Tracking events | Modify |
| `lib/features/presenter/views/home/components/home_info_card.dart` | **New** — Info card widget | Create |
| `lib/features/presenter/views/home/components/home_info_mapper.dart` | **New** — Resolves which info to show | Create |
| `lib/features/presenter/views/home/components/home_info_view_data.dart` | **New** — View data for info card | Create |
| `lib/features/presenter/views/home/components/home_info_data_source.dart` | **New** — Local basic_tip data | Create |

---

## 3. Requirements

### 3.1 Functional Requirements

| ID | Description | Priority |
|----|-------------|----------|
| FR1 | `homeDashboard` must query `infoContext` with all sub-fields (todayCultivation, reservoirReport, dayProgress, fieldNotesSummary) | High |
| FR2 | `homeDashboard` model must parse `infoContext` into typed Dart classes | High |
| FR3 | `getAdaptiveInterface` must return `infoRecommendation` in its response | High |
| FR4 | `InstantAdaptiveHomeViewData` must include `InfoRecommendationViewData` | High |
| FR5 | Home must render 4 sections in order: greeting → shortcuts → info → modules | High |
| FR6 | In `STATIC` mode, info card shows local basic_tips (general category) | High |
| FR7 | In `INSTANT` mode, info card shows the type recommended by `infoRecommendation` | High |
| FR8 | Fallback chain for info content: recommendation type → data availability → basic_tip | High |
| FR9 | `day_progress` must NOT display time spent (API lacks reliable duration) | Medium |
| FR10 | `day_progress` must NOT use progress bar, stepper, or checklist | Medium |
| FR11 | Payload sent to Gemini/getAdaptiveInterface must not contain PII or free text from ISIS | High |
| FR12 | Test sequence signals must use canonical names for the backend | High |
| FR13 | Metrics `info_card_shown` and `info_card_clicked` must work without sensitive data | Medium |
| FR14 | If any API fails, visual fallback is `basic_tip` | High |
| FR15 | If `infoContext` is null, app must not break | High |

### 3.2 Acceptance Criteria

1. **homeDashboard query** includes `infoContext` with all four sub-objects; parsing succeeds and null-safe.
2. **getAdaptiveInterface** (INSTANT) returns `infoRecommendation` with `type`, `source`, `priority`, `title`, `reason`, `ctaRoute`, `category`.
3. **Home layout** renders: HomeDayHeader → RecommendedActionsSection (or Instant actions) → HomeInfoCard → HomeModulesSection.
4. **STATIC mode**: HomeInfoCard shows general tips from local data.
5. **INSTANT mode**: HomeInfoCard shows content matching `infoRecommendation.type`:
   - `today_cultivation` → data from `infoContext.todayCultivation`
   - `reservoir_report` → data from `infoContext.reservoirReport`
   - `day_progress` → data from `infoContext.dayProgress` (no time spent, no bar)
   - `field_notes_summary` → data from `infoContext.fieldNotesSummary`
   - `basic_tip` → local tips filtered by `category`
6. **Fallback**: If recommended type has no data, next available type is shown; last resort is `basic_tip`.
7. **Sanitization**: Payloads sent to `getAdaptiveInterface` exclude lot names, user names, note titles, descriptions, and free-text `reason`.
8. **Canonical signal names**: `generatedActivitiesSeen`, `nutritionAdjustmentExecuted`, `fieldNotebookChecked`, `agendaActivitiesCompleted`, `finalHomeChecked` are used in payload to backend.
9. **Metrics**: `info_card_shown` and `info_card_clicked` log only `info_type`, `source`, `mode`, `session_id`, `target_route`.
10. **Model generation**: `home_dashboard_model.g.dart` regenerated after model changes.

---

## 4. Design

### 4.1 Home Layout Order (FR5)

The new layout of `HomeDailyPanelContent`:

```
┌─────────────────────────────┐
│  HomeDayHeader (greeting)   │  ← já existe, mantido
├─────────────────────────────┤
│  Shortcuts section          │  ← STATIC: viewData.actions / INSTANT: instantViewData.recommendedActions
├─────────────────────────────┤
│  HomeInfoCard               │  ← NOVO
├─────────────────────────────┤
│  HomeModulesSection         │  ← já existe, mantido
└─────────────────────────────┘
```

- Remove `TodayCultivationPanel` and `HomeProductionSummary` as separate top-level blocks.
- `TodayCultivationViewData` becomes optional; its data may be absorbed into the `today_cultivation` variant of `HomeInfoCard`.
- `ProductionSummaryViewData` logic remains in mapper for backward compatibility but is no longer rendered in the default layout (or rendered inside info card when no adaptive data).

### 4.2 Info Card Architecture

#### 4.2.1 Enum for info types

```dart
enum HomeInfoType {
  todayCultivation,
  reservoirReport,
  dayProgress,
  fieldNotesSummary,
  basicTip,
}
```

#### 4.2.2 ViewData classes (new file: `home_info_view_data.dart`)

```dart
class HomeInfoViewData {
  final HomeInfoType type;
  final String title;
  final String? subtitle;
  final List<HomeInfoMetric> metrics;     // key-value pairs like "Tarefas hoje: 5"
  final List<HomeInfoListItem> items;     // tasks, alerts, notes
  final String? ctaLabel;
  final String? ctaRoute;
  final String? sourceCategory;           // for basic_tip category
}

class HomeInfoMetric {
  final String label;
  final String value;
  final HomeInfoMetricTone tone;
}

enum HomeInfoMetricTone { neutral, positive, warning, danger }

class HomeInfoListItem {
  final String title;
  final String? subtitle;
  final String? lotName;
  final String? date;
  final String? userName;
  final HomeInfoItemTone tone;
}

enum HomeInfoItemTone { neutral, warning, danger }
```

#### 4.2.3 Mapper (new file: `home_info_mapper.dart`)

```dart
class HomeInfoMapper {
  static HomeInfoViewData resolve({
    required HomeDashboard? dashboard,
    required InfoRecommendationViewData? infoRecommendation,
    required String adaptiveMode,
    required String? infoCategory,
  }) {
    // 1. If INSTANT and infoRecommendation exists, use its type
    // 2. If type has insufficient data, try fallback types
    // 3. If STATIC or all fallbacks fail, return basic_tip
  }
}
```

### 4.3 Data Flow — INSTANT Mode (FR7)

```
User opens Home
       │
       ▼
loadInstantAdaptiveInterface()
       │
       ├── InstantOperationalContextMapper.map()  → sanitized context
       ├── ClientCapabilitiesMapper.map()          → supported components/info types
       │
       ▼
getAdaptiveInterface (Cloud Function)
       │
       ▼
Response includes:
  - infoRecommendation: { type, source, priority, title, reason, ctaRoute, category }
  - shortcuts
  - nextStep, focusBanner, etc.
       │
       ▼
InstantAdaptiveHomeMapper.parse() → InfoRecommendationViewData
       │
       ▼
HomeInfoMapper.resolve()
  - reads dashboard.infoContext
  - reads infoRecommendation
  - returns HomeInfoViewData
       │
       ▼
HomeInfoCard renders based on type
```

### 4.4 Data Loader for basic_tip (new file: `home_info_data_source.dart`)

Dart static data source for basic tips, grouped by category:

```dart
class HomeBasicTipSource {
  static const Map<String, List<String>> tips = {
    'geral': [
      'Mantenha o caderno de campo atualizado para rastreabilidade.',
      'Acompanhe a previsão do tempo para planejar irrigações.',
      // ...
    ],
    'agenda': [
      'Organize as tarefas por prioridade para otimizar o dia.',
      // ...
    ],
    'lote': [
      'Monitore o EC da solução nutritiva semanalmente.',
      // ...
    ],
    'protocolo': [ /* ... */ ],
    'solucao': [ /* ... */ ],
    'reservatorio': [ /* ... */ ],
    'caderno_campo': [ /* ... */ ],
    'cultivo': [ /* ... */ ],
  };
}
```

---

## 5. API Contracts

### 5.1 GraphQL — homeDashboard (FR1)

Add `infoContext` to existing query:

```graphql
query HomeDashboard($contaId: Int!) {
  homeDashboard(contaId: $contaId) {
    # ... existing fields (resumo, tarefas, producao, etc.)
    
    infoContext {
      todayCultivation {
        tasksToday
        overdueTasks
        activeLots
        upcomingHarvests
        alerts {
          type
          message
          lotId
          lotName
          severity
          date
        }
        nextTasks {
          id
          title
          description
          lotId
          lotName
          date
          overdue
        }
      }
      reservoirReport {
        totalReservoirs
        totalVolume
        reservoirsWithSolution
        reservoirsWithoutSolution
        activeLotsLinked
        highlightedReservoirs {
          id
          name
          volume
          solutionName
          electricalConductivity
          linkedLotsCount
        }
      }
      dayProgress {
        totalTasksToday
        completedTasksToday
        pendingTasksToday
        overdueTasks
        completionLabel
        nextTask {
          id
          title
          description
          lotId
          lotName
          date
          overdue
        }
      }
      fieldNotesSummary {
        totalRecentNotes
        latestNotes {
          id
          title
          description
          lotId
          lotName
          userName
          createdAt
        }
      }
    }
  }
}
```

### 5.2 getAdaptiveInterface — infoRecommendation (FR3)

New field in the Cloud Function response:

```json
{
  "infoRecommendation": {
    "type": "today_cultivation",
    "source": "operational_context",
    "priority": "high",
    "title": "Hoje no cultivo",
    "reason": "Você tem tarefas pendentes no cultivo",
    "ctaRoute": "/agendaPage",
    "category": "agenda"
  }
}
```

**Valid `type` values**: `today_cultivation`, `reservoir_report`, `day_progress`, `field_notes_summary`, `basic_tip`

### 5.3 Client Capabilities Payload (FR11)

Updated `ClientCapabilitiesMapper.map()`:

```json
{
  "supportedComponents": [
    "NextStepCard",
    "AdaptiveFocusBanner",
    "AdaptiveReasonChip",
    "AdaptiveRecommendedActionTile",
    "HomeInfoCard"
  ],
  "supportedInfoTypes": [
    "today_cultivation",
    "reservoir_report",
    "day_progress",
    "field_notes_summary",
    "basic_tip"
  ],
  "supportsInfoIconExplanation": true,
  "supportsHighlightFrame": true,
  "maxShortcuts": 4,
  "maxSectionAdaptations": 4,
  "forbiddenComponents": [
    "WorkflowProgressBar",
    "TestProgressBar",
    "ProgressStepper",
    "ProgressBar",
    "Stepper",
    "Checklist"
  ]
}
```

### 5.4 Sanitized Operational Context (FR11)

#### reservoirState (new)

```json
{
  "reservoirState": {
    "hasReservoirs": true,
    "totalCount": 3,
    "lowLevelCount": 0,
    "criticalLevelCount": 0,
    "currentLevel": "unknown"
  }
}
```

Mapped from `infoContext.reservoirReport`:
- `hasReservoirs`: `totalReservoirs > 0`
- `totalCount`: `totalReservoirs`
- `lowLevelCount`: `0` (ISIS não fornece)
- `criticalLevelCount`: `0` (ISIS não fornece)
- `currentLevel`: `"unknown"`

#### fieldNotebookState (updated)

```json
{
  "fieldNotebookState": {
    "hasRecentNutritionAdjustmentRecord": true,
    "hasRecentFieldNotes": true,
    "uncheckedNotesCount": 0,
    "latestRecordType": "nutrition_adjustment"
  }
}
```

Mapped from `infoContext.fieldNotesSummary`:
- `hasRecentFieldNotes`: `totalRecentNotes > 0`
- `uncheckedNotesCount`: `0` (ISIS não fornece)
- `latestRecordType`: inferred safely:
  - If local source detects recent nutrition adjustment: `"nutrition_adjustment"`
  - Else if has notes: `"field_note"`
  - Else: `null`

#### infoContextState (new)

```json
{
  "infoContextState": {
    "lastShownType": "day_progress",
    "lastShownCategory": "agenda",
    "dismissedTodayCount": 0,
    "hasSeenInfoToday": false
  }
}
```

Can start simple:
- `lastShownType`: last card type shown in session (if stored)
- `lastShownCategory`: last category shown
- `dismissedTodayCount`: `0` if no dismiss tracking
- `hasSeenInfoToday`: `false` if no persistence

### 5.5 Test Sequence Signals — Canonical Names (FR12)

Updated mapping in `InstantOperationalContextMapper`:

| Old (internal) | New (payload toJson) |
|----------------|---------------------|
| `generatedAgendaActivitiesChecked` | `generatedActivitiesSeen` |
| `nutritionalAdjustmentExecuted` | `nutritionAdjustmentExecuted` |
| `automaticAdjustmentRecordChecked` | `fieldNotebookChecked` |
| `finalHomeStateChecked` | `finalHomeChecked` |
| `lotWithProtocolCreated` | `lotWithProtocolCreated` (kept) |
| `agendaActivitiesCompleted` | `agendaActivitiesCompleted` (kept) |

Internal signal names in `InstantSequenceSignalsStore` and `InstantSequenceEventType` can stay unchanged; the mapping happens ONLY in `TestSequenceSignals.toJson()`.

---

## 6. Component Specification — HomeInfoCard

### 6.1 Widget Contract

```dart
class HomeInfoCard extends StatelessWidget {
  final HomeInfoViewData data;
  final VoidCallback? onCtaTap;
  final VoidCallback? onDismiss;
}
```

### 6.2 Visual Variants

#### basic_tip
- Icon: lightbulb/tip icon
- Title: "Dica do dia" or themed by category
- Body: single tip text, from local source filtered by `sourceCategory`
- CTA: none (dismiss optional)
- If INSTANT: choose tip by `infoRecommendation.category`
- If STATIC: show 3-4 general tips (rotating or fixed)

#### today_cultivation
- Icon: eco/leaf icon
- Metrics: tasks today, overdue, active lots, upcoming harvests
- Items: up to 2 next tasks or alerts
- CTA: "Ver na agenda" → `/agendaPage`

#### reservoir_report
- Icon: water drop icon
- Metrics: total reservoirs, total volume, with/without solution, active lots linked
- Items: up to 2 highlighted reservoirs (name, volume, solution, EC)
- CTA: "Ver reservatórios" → `/reservatoriosPage`

#### field_notes_summary
- Icon: note/field book icon
- Metrics: total recent notes
- Items: up to 2 latest notes (lot, date, user)
- CTA: "Ver caderno de campo" → `/cadernoCampoPage`

#### day_progress
- Icon: checkmark/calendar icon
- Metrics: completionLabel (e.g., "4/5 tarefas concluídas"), pending, overdue
- Items: next task info
- **No time spent displayed**
- **No progress bar, stepper, or checklist**
- CTA: "Ver agenda" → `/agendaPage`

### 6.3 Resolution Logic (HomeInfoMapper)

```
Se modo INSTANT e infoRecommendation existe:
  tipo = infoRecommendation.type
  Se tipo == 'basic_tip' → retorna basic_tip
  Se tipo == 'today_cultivation' e todayCultivation tem dados → retorna today_cultivation
  Se tipo == 'reservoir_report' e reservoirReport tem dados → retorna reservoir_report
  Se tipo == 'day_progress' e dayProgress tem dados → retorna day_progress
  Se tipo == 'field_notes_summary' e fieldNotesSummary tem dados → retorna field_notes_summary

Fallback (tentar tipos com dados disponíveis):
  - day_progress (se dayProgress.totalTasksToday > 0)
  - today_cultivation (se tarefas/lotes/alertas)
  - reservoir_report (se reservatórios)
  - field_notes_summary (se anotações)
  - basic_tip (sempre disponível)

Se modo STATIC:
  → basic_tip (categoria geral)
```

---

## 7. Metrics (FR13)

Add to `MetricsTrackingService`:

```dart
Future<void> trackInfoCardShown({
  required String infoType,
  required String source,
  required String mode,
  String? sessionId,
});

Future<void> trackInfoCardClicked({
  required String infoType,
  required String targetRoute,
  required String mode,
  String? sessionId,
});
```

**Events**: `info_card_shown`, `info_card_clicked`

**Allowed parameters** (no PII):
- `info_type`: the type from HomeInfoType enum
- `source`: "local", "isis", "adaptive"
- `mode`: "STATIC", "INSTANT"
- `session_id`
- `target_route` (only on click)

**Prohibited** (must not be sent):
- Lot names
- User names
- Note titles/descriptions
- Free-text `reason`

---

## 8. Shortcuts Behavior (FR5 / Section 7 of user request)

### STATIC mode
- Use `viewData.actions` (from `home_panel_mapper.dart`) which defaults to: Agenda, Lotes, Reservatórios, Caderno de Campo or Soluções.
- Same rendering as existing `RecommendedActionsSection`.

### INSTANT mode
- Use `instantViewData.recommendedActions` (from Cloud Function response).
- If empty, fallback to `viewData.actions`.
- Always appear below greeting header, above info card.

---

## 9. Dependencies & Risks

### 9.1 Backend Rule Mapping (FRN)

The user notes a potential mismatch between frontend expectation and current backend rules:

| Desired flow | Backend rule (current) | Concern |
|-------------|----------------------|---------|
| Create lot/protocol → basic_tip | RULE-002 → day_progress | Frontend must render as received; backend should map rules correctly |
| Agenda → today_cultivation | RULE-003 → today_cultivation | Already correct? |
| Adjustment solution → reservoir_report | RULE-003 currently maps? | Verify |

**Risk**: The frontend renders based on `infoRecommendation.type` as received. If the backend sends wrong types, the frontend will still render them (correctly). The flow correctness depends on backend rule configuration. This is a **backend dependency** requiring coordination.

### 9.2 ISIS Data Availability

- Some `infoContext` fields may be `null` or empty (e.g., no reservoirs, no field notes).
- The fallback chain handles this gracefully.
- `dayProgress` does not provide reliable time tracking → must not display time.

### 9.3 Coupling Risks

- `home_dashboard_model.dart` is already 436 lines; adding `infoContext` models will push it close to/over 500 lines → **recommend extracting `infoContext` models to a separate file** (`home_dashboard_info_context_model.dart`) to keep files manageable.
- `home_daily_panel_content.dart` is 309 lines; refactoring the layout may push it larger → consider extracting sections into smaller components.

---

## 10. Implementation Plan

### Phase 1 — Backend Contracts

1. **Update GraphQL query** in `home_dashboard_datasource.dart` to include `infoContext`.
2. **Create models** in `home_dashboard_info_context_model.dart` (new file):
   - `HomeInfoContext` (wrapping 4 sub-objects)
   - `HomeTodayCultivationInfo`
   - `HomeReservoirReport`
   - `HomeReservoirSummary`
   - `HomeDayProgress`
   - `HomeFieldNotesSummary`
   - `HomeFieldNoteSummary`
   - `HomeInfoTask`
   - `HomeInfoAlert`
3. **Add `infoContext` field** to `HomeDashboard` model and regenerate `.g.dart`.

### Phase 2 — Adaptive Interface Contracts

4. **Add `InfoRecommendationViewData`** class to `instant_adaptive_home_view_data.dart`.
5. **Update `InstantAdaptiveHomeMapper`** to parse `infoRecommendation` from the Cloud Function response.
6. **Add `infoRecommendation`** field to `InstantAdaptiveHomeViewData`.
7. **Preserve `infoRecommendation`** in `AdaptiveInterfaceService.getInstantAdaptiveInterface`.

### Phase 3 — Payload & Sanitization

8. **Update `ClientCapabilitiesMapper`** to include `supportedInfoTypes` and updated component list.
9. **Update `InstantOperationalContextMapper`**:
   - Add `reservoirState`, `fieldNotebookState`, `infoContextState` to payload.
   - Map canonical signal names in `TestSequenceSignals.toJson()`.
   - Ensure no PII/free text is sent.

### Phase 4 — Info Card Component

10. **Create `HomeInfoViewData`** (new file).
11. **Create `HomeInfoMapper`** (new file) with resolution logic.
12. **Create `HomeBasicTipSource`** (new file) with local Dart data.
13. **Create `HomeInfoCard`** widget with all five visual variants.

### Phase 5 — Home Layout

14. **Update `HomeDailyPanelContent`**:
    - Reorder: header → shortcuts → info → modules.
    - Remove TodayCultivationPanel and ProductionSummary from direct layout.
    - Integrate HomeInfoCard.
15. **Update `home_daily_panel_sections.dart`** barrel exports.
16. **Update `HomePanelMapper`** if needed for STATIC shortcuts.

### Phase 6 — Metrics

17. **Add `trackInfoCardShown` and `trackInfoCardClicked`** to `MetricsTrackingService`.
18. **Integrate tracking calls** in `HomeInfoCard`.

### Phase 7 — Validation

19. **Regenerate** `home_dashboard_model.g.dart`.
20. **Run** `flutter analyze` and `flutter test`.
21. **Verify** that:
    - Models parse with null infoContext.
    - InfoCard renders all five types correctly.
    - No PII in payloads.
    - Layout renders in correct order.

---

## 11. Validation Commands

```bash
# After model changes
cd /home/joao/Documentos/personal/mestras/osi-solucoes
dart run build_runner build --delete-conflicting-outputs

# After implementation
flutter analyze
flutter test
```

---

## 12. Decision Records

| Decision | Rationale |
|----------|-----------|
| Extract infoContext models to separate file | home_dashboard_model.dart is 436 lines; mixing types would exceed 500+ |
| Info card replaces TodayCultivationPanel as primary section | Eliminates duplicate data sources (ISIS infoContext replaces aggregated tarefas/resumo) |
| basic_tip uses static Dart data, not API | Always available; no network dependency for offline fallback; consistent with STATIC mode |
| Canonical signal names mapped only in toJson | Avoids refactoring internal stores; minimal diff |
| No progress bar in day_progress | User explicitly prohibited; API lacks reliable task duration data |
