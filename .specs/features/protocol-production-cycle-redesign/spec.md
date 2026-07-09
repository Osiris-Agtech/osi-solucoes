# Feature Specification: Protocol Production Cycle Redesign

Agent: spec-writer
Rules: AGENTS.md

## Context

The current protocol details screens present protocol metadata and activities as generic information lists/cards. The requested redesign should make protocols read as an operational production cycle: a compact summary of the protocol, a clear preview of the cycle, and a phase-based activity timeline showing all registered activities.

Relevant existing screens and patterns observed:

- `lib/features/presenter/views/protocolo/detelhes_protocolo.dart` is 345 lines and must not grow with more mixed responsibilities.
- `lib/features/presenter/views/area_cultivo/N3/components/cadastrar_page/protocolo_detalhes_page.dart` is near 300 lines and must be decomposed if touched.
- Protocol activity detail views already group actions by phase through `prepararListaDetalhesFase()` and `listaFaseDetalhes` in `ProtocoloStore` and `LoteStore`.
- Existing UI tokens/components include `Constants`, `AppPageHeaderSliver`, `AppModalSheet`, and `AppPrimaryButton`.

## Goals

- Redesign the protocol details page into an operational summary for production use.
- Redesign protocol activity details into a vertical production-cycle timeline grouped by phases.
- Represent all registered activities without changing APIs, stores, schemas, models, or routes unless implementation proves unavoidable.
- Reuse existing design system/tokens and common widgets.
- Keep the product tone restrained, clear, objective, and operational.
- Decompose components so large existing files do not accumulate additional responsibilities.

## Non-goals

- No API, GraphQL, database schema, model serialization, or route contract changes.
- No change to how protocols, phases, actions, alerts, or lots are persisted.
- No new design system, theme, typography system, test infrastructure, analytics, logging, or localization layer.
- No behavior changes for editing, deleting, linking, or unlinking protocols beyond navigation/CTA presentation.
- No refactor of stores or generated MobX files unless a real defect blocks the UI redesign.

## UX Requirements

### Protocol details operational summary

The protocol details page should show:

- Compact protocol identity and metadata:
  - protocol name from selected protocol;
  - culture;
  - cultivation system;
  - implantation/start method.
- Operational counts:
  - total phases;
  - total actions/activities;
  - total activities with alert enabled;
  - total production cycle duration in days.
- Cycle preview:
  - phase sequence in order currently produced by existing grouping logic;
  - each phase preview should communicate phase name, duration, and activity count;
  - preview should remain compact and not duplicate the full timeline.
- Prominent CTA to view production cycle activities:
  - label should be operational, e.g. `Ver ciclo de produção` or `Ver atividades do ciclo`;
  - must navigate to the existing protocol activities details route from protocol details;
  - should use `AppPrimaryButton` when page structure allows.
- Linked lots section:
  - keep existing linked lots data source;
  - improve empty state copy to explain that no lots/cultivations are linked to this protocol;
  - avoid inaccurate references such as “reservatório” if the section represents lots/cultivations.

### Protocol activities production-cycle timeline

The activity details page/sheet should show a vertical timeline grouped by phases:

- Each phase group shows:
  - phase name;
  - duration in days;
  - number of activities in that phase.
- Each activity item shows:
  - title;
  - day in phase from `Acao.duracao_dias`;
  - optional real cultivation day from `Acao.duracao_dias_real` only when present and different from `duracao_dias`;
  - alert indicator with icon and explicit text, not icon-only.
- Empty state:
  - explain that there are no activities registered for the protocol/cycle;
  - direct the user to edit the protocol and add phases/activities where that action is available;
  - do not imply data was lost.

## Accessibility Requirements

- Tap targets for primary CTA, activity cards, back/actions, and floating/scroll actions should be at least 48x48 logical pixels where interactive.
- Alert state must not rely on color alone; use icon plus text such as `Com alerta` / `Sem alerta`.
- Text must respect dynamic font scaling without clipping critical information.
- Timeline order and semantics should be readable top-to-bottom by assistive technologies.
- Empty states should use plain, actionable text and sufficient contrast via existing `Constants` colors.
- Avoid dense icon-only affordances unless they already exist as app-level actions with clear semantics.

## Technical Approach and Design Decisions

- Treat this as a UI-only redesign over existing loaded protocol data.
- Use existing phase grouping state when available:
  - protocol details route: `ProtocoloStore.protocoloSelecionado`, `prepararListaDetalhesFase()`, `listaFaseDetalhes`;
  - lot protocol details modal: `LoteStore.protocoloDetalhes`, `prepararListaDetalhesFase()`, `listaFaseDetalhes`.
- Derive summary counts locally in presentation/component helpers from currently available data:
  - phases: grouped phase list length;
  - activities: sum of grouped `fase.acao?.length` or fallback to raw action list length;
  - alerts: count actions where `alerta == true`;
  - duration: sum phase `duracao_dias`, treating null as zero for summary display.
- Keep data contracts unchanged. If ordering is not guaranteed by existing store logic, preserve current ordering rather than introducing sort semantics without product confirmation.
- Extract reusable presentation widgets/helpers instead of adding more UI to oversized files.
- Prefer stateless widgets and pure helper functions for formatting/counts.
- Keep copy in Portuguese to match current screens.

No separate decision record is warranted because this spec does not introduce a new architecture, schema, or API contract. The key decision is to keep the redesign presentation-only and use existing store/model data.

## Data Structures and Interfaces Involved

Existing model fields to consume:

- `Protocolo.nome`
- `Protocolo.cultura?.nome`
- `Protocolo.sistema_cultivo`
- `Protocolo.implantacao`
- `Protocolo.acao`
- `Protocolo.lotes`
- `Fase.id`
- `Fase.nome`
- `Fase.duracao_dias`
- `Fase.acao`
- `Acao.titulo`
- `Acao.duracao_dias`
- `Acao.duracao_dias_real`
- `Acao.alerta`

Expected component/helper interfaces may include, without requiring exact names:

- `ProtocolCycleSummary` / `ProtocoloResumoOperacional`: renders protocol metadata and aggregate counts.
- `ProtocolCyclePreview` / `ProtocoloCicloPreview`: renders compact phase sequence preview.
- `LinkedLotsSection` / `CultivosVinculadosSection`: renders linked lots and empty state.
- `ProductionCycleTimeline` / `LinhaDoTempoCicloProducao`: renders grouped phase timeline.
- `ProductionPhaseTimelineItem`: renders one phase header and its activity list.
- `ProductionActivityTimelineItem`: renders title, phase day, optional real cultivation day, and alert status.
- `ProtocolCycleMetrics`: simple immutable presentation data for counts, derived from existing models.

These should remain presentation-layer constructs. Do not add persistence fields.

## Edge Cases

- Selected protocol is null: show safe placeholders and avoid crashes.
- Protocol has no actions: show empty cycle/activity state and zero counts.
- Actions exist but some actions have null phase: do not crash; either exclude from grouped phase count and include in total activity count, or show a clearly labeled fallback group only if existing UX supports it.
- Phase duration is null: display `-- dias` or `0 dias` consistently; do not throw.
- Activity day is null: display `Dia não informado` rather than `nullº dia`.
- Real cultivation day equals phase day: hide the real-day row.
- Real cultivation day is null: hide the real-day row.
- Long protocol, phase, lot, or activity names: wrap or ellipsize according to available space without breaking layout.
- No linked lots: show improved empty state with operational copy.
- Many phases/activities: timeline remains scrollable and does not use nested unbounded scrollables incorrectly.

## Touched File Expectations

Expected files to modify during implementation:

- `lib/features/presenter/views/protocolo/detelhes_protocolo.dart`
  - reduce responsibility by delegating summary, preview, and linked lots rendering.
- `lib/features/presenter/views/protocolo/components/detalhes_page/detalhes_ativ.dart`
  - replace card list with production-cycle timeline using extracted widgets.
- `lib/features/presenter/views/area_cultivo/N3/components/cadastrar_page/protocolo_detalhes_page.dart`
  - align protocol details modal with operational summary and delegate large sections.
- `lib/features/presenter/views/area_cultivo/N3/components/cadastrar_page/protocolo_detalhes_atv.dart`
  - align modal activity details with production-cycle timeline.
- `lib/features/presenter/views/area_cultivo/N3/components/cadastrar_page/protocolo_atividadeItemDetalhes.dart`
  - either replace with the shared activity timeline item or adapt to alert text requirements.
- New component files under existing `components/detalhes_page/` or nearby protocol component folders, if needed, to keep files cohesive.

Files that should not be modified unless absolutely necessary:

- `*_store.dart`
- `*_store.g.dart`
- model files such as `protocolo_model.dart`, `fase_model.dart`, `acao_model.dart`
- route definitions
- datasources/repositories

## Implementation Tasks with Verification Criteria

1. Create presentation metrics/helpers for production-cycle counts.
   - Verification: counts for phases, activities, alerts, and duration can be derived from existing protocol/fase/action data without model/store changes.

2. Extract reusable operational summary components.
   - Verification: protocol details page and modal can render compact metadata, counts, CTA, cycle preview, and linked lots without duplicating large UI blocks.

3. Redesign protocol details page.
   - Verification: page shows compact info, counts, cycle preview, prominent CTA to existing activities route, and improved linked lots empty state.

4. Redesign protocol details modal used from lot/cultivation flow.
   - Verification: modal uses the same operational language and existing `AppModalSheet`/`AppPrimaryButton` behavior for link/unlink actions.

5. Extract and implement production-cycle timeline components.
   - Verification: timeline renders phases vertically with phase name, duration, activity count, and all activities in each phase.

6. Redesign protocol activities details page and modal timeline.
   - Verification: each activity shows title, day in phase, optional real cultivation day only when different/present, and alert icon plus text.

7. Improve empty states.
   - Verification: no-action and no-lot states show clear Portuguese operational copy and do not reference the wrong domain object.

8. Run validation commands.
   - Verification: commands complete successfully or failures are documented with file/line evidence.

Parallelization notes:

- Tasks 1 and 5 can be designed in parallel after confirming data access patterns.
- Tasks 3 and 4 depend on Task 2.
- Task 6 depends on Task 5.
- Task 8 depends on all implementation tasks.

## Acceptance Criteria

- AC1: Protocol details presents culture, cultivation system, and implantation in a compact operational summary.
- AC2: Protocol details presents correct counts for phases, activities, alert-enabled activities, and total cycle duration using existing loaded data.
- AC3: Protocol details includes a prominent CTA that navigates to the existing production-cycle/activity details screen.
- AC4: Protocol details shows a compact cycle preview grouped by phase.
- AC5: Linked lots section shows existing linked lots when present and an improved empty state when absent.
- AC6: Activity details page renders a vertical timeline grouped by phase.
- AC7: Every phase group shows phase name, duration, and activity count.
- AC8: Every activity shows title and day in phase.
- AC9: Real cultivation day appears only when `duracao_dias_real` is present and different from `duracao_dias`.
- AC10: Alert state is displayed with icon and explicit text.
- AC11: Empty activity state explains no registered activities and directs users to edit/add phases where possible.
- AC12: No API, schema, route, generated MobX, or persistence model change is introduced.
- AC13: Existing design tokens/common widgets are reused where applicable.
- AC14: Large files are decomposed; new UI responsibilities are placed in cohesive widgets/helpers rather than appended wholesale to existing oversized files.
- AC15: Flutter analyzer/typecheck passes, or any pre-existing unrelated failures are documented.

## Validation Commands

Run from repository root after implementation:

```bash
flutter analyze
flutter test
```

If tests are not present or fail due to unrelated existing issues, capture the command output and identify whether failures are related to this feature.

## Open Questions

- Should the cycle preview phase order follow the current API/store order exactly, or should phases be sorted by a business field? Current spec preserves existing order.
- What exact CTA label is preferred: `Ver ciclo de produção` or `Ver atividades do ciclo`?
- For actions with no phase, should they be hidden from the grouped timeline, counted only in totals, or shown in an `Sem fase` group?
- Should total duration be the sum of phase durations or the maximum real cultivation day when available? Current spec uses sum of phase durations.
