# Implementation Plan - Cadastrar Lote Refactor

## Overview
Unificar o fluxo de criação de lote eliminando a dualidade summary view + bottom sheet wizard, substituindo por um stepper inline com progresso textual, validação por etapa, e uso consistente do design system.

## Workstreams and Dependencies

```
Phase 1 (parallel, independent)
├── WS-A: Store changes (lote_store.dart)
├── WS-B: Step progress bar (step_progress_bar.dart) [NEW]
├── WS-C: Step navigation footer (step_navigation_footer.dart) [NEW]
└── WS-D: Detail pages (reservatorio_detalhes_page.dart + protocolo_detalhes_page.dart)

Phase 2 (parallel, depend on WS-A for validation methods)
├── WS-E: setor_step.dart (from setor_item.dart)
├── WS-F: lote_step.dart + cultura_step.dart (from lote_item.dart + cultura_item.dart)
├── WS-G: reservatorio_step.dart (from reservatorio_item.dart)
├── WS-H: protocolo_step.dart + protocolo_item_card.dart (from protocolo_page.dart + protocoloItemLote.dart)

Phase 3 (depends on Phase 2 component signatures)
└── WS-I: cadastrar_lote_page.dart (complete rewrite)
```

## Validation Commands (run after all phases)
```bash
cd /home/joao/Documentos/personal/mestras/osi-solucoes
flutter analyze --no-fatal-infos --no-fatal-warnings
dart format lib/features/presenter/views/area_cultivo/N3/ --set-exit-if-changed
```

## File Boundaries
- No implementer may edit a file assigned to another implementer
- No implementer may import from a file that hasn't been created yet in their phase
- Each step component file MUST export a single widget function/class with a clean signature
- The main page (Phase 3) MUST NOT contain inline step content — only compose step widgets

## Coupling Risks
- `lote_store.dart` is 1193 lines — only modify the specific observables/methods listed in spec
- `cadastrar_lote_page.dart` is 596 lines — rewrite entirely, keep it under 300 lines
- Step components must not import `cadastrar_lote_page.dart` (circular dependency risk)
- Remove `dotIndicator` from store only after ensuring no remaining references
