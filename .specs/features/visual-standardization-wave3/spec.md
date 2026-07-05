# Visual Standardization — Wave 3

## Feature Overview

Eliminate the remaining duplicated manual wizard pattern in 5 cadastro bottom sheets by replacing their ad-hoc `SizedBox` + `DotsIndicator` + `CarouselSlider` + `NextStepButton` structure with the shared `AppStepWizard` component created in Wave 1.

Wave 1 created `AppStepWizard` and refactored the outer bottom sheet wrappers to use `AppModalSheet`. Wave 2 adopted `AppStepWizard` in `cadastrar_lote_page.dart`. **Wave 3 converts the 5 `pagesNovoX` functions that still duplicate the inner wizard pattern manually.**

This is Workstream H: the last remaining standardization of the wizard/carousel pattern across the app.

---

## Requirements

### Workstream H — Inner Wizard Adoption (IW)

**Prerequisite:** `AppStepWizard` already exists at `lib/features/presenter/widgets/common/app_step_wizard.dart` and encapsulates `StepProgressBar` + `CarouselSlider` + `StepNavigationFooter`. The 5 target functions currently duplicate this pattern inline with `SizedBox`, `DotsIndicator`, `CarouselSlider`, and a custom `NextStepButton` class.

| ID | Requirement | Verification |
|----|------------|-------------|
| **IW-1** | Replace the entire `SizedBox` + `Column` body of each `pagesNovoX` function with a single `AppStepWizard` widget. Remove the close button (top-left `IconButton` with `Icons.close`), the `DotsIndicator`, the inner `CarouselSlider` with step pages, and the back button + `NextStepButton` navigation footer. The new function returns `Widget` (not `SizedBox`). | File diff shows removal of `DotsIndicator`, `CarouselSlider`, `NextStepButton` class, and manual `store.dotIndicator` navigation logic; replacement by a single `AppStepWizard` component. |
| **IW-2** | The `steps` list must contain the same step page widgets in the same order as currently passed to the inner `CarouselSlider.items`. Each step page must be passed with the same arguments as before (`context`, `store`, plus any additional params). The step pages themselves must not be modified. | The `steps` list for each file matches the current `items` list content exactly (same widgets, same arguments, same order). |
| **IW-3** | The `stepLabels` must match the mapping below. | `stepLabels` list is exactly as specified in the table. |
| **IW-4** | The `onSubmit` callback must close the bottom sheet (`Navigator.pop(context)` or `Get.back()`) for all files EXCEPT N1 (area cultivo) and reservatório. For N1 and reservatório, `onSubmit` must call `controlerPages.nextPage()` to advance the outer CarouselSlider (see IW-7). | `onSubmit` closure calls the correct navigation method per file. |
| **IW-5** | Remove the `NextStepButton` `StatefulWidget` class (and its `State`) from each file. Remove the `DotsIndicator` import (`dots_indicator`). Remove the `store.dotIndicator` read/write calls (the store field remains — it is NOT removed — but the wizard no longer reads it). | File diff shows removal of the `NextStepButton` class. No references to `DotsIndicator`, `DotsDecorator`, or `dots_indicator` remain. |
| **IW-6** | Remove unused function parameters: `CarouselSliderController carouselController` and `CarouselSliderController controlerPages` — these are no longer needed since `AppStepWizard` manages its own internal controller. Exception: for N1 (area cultivo) and reservatório, `controlerPages` is still needed for the outer CarouselSlider (see IW-7). | The function signature for each file no longer includes the inner `carouselController` parameter. N1 and reservatório retain `controlerPages`. N2, solução, and caderno campo retain neither. |
| **IW-7** | **Bottom sheet wrapper simplification** — For N2, solução, and caderno campo (the 3 bottom sheets whose outer `CarouselSlider` has exactly 1 item), remove the outer `CarouselSlider` entirely and pass the `pagesNovoX` result directly as `AppModalSheet`'s `body`. For N1 and reservatório (whose outer `CarouselSlider` has 2 items: the wizard + an external page), retain the outer `CarouselSlider` and its `controlerPages` controller, but simplify the wizard item to just the new `pagesNovoX` result. | **N2, solução, caderno campo:** `body` parameter is the direct return value of `pagesNovoX(...)`, not a `CarouselSlider` wrapping it. **N1, reservatório:** `body` is still a `CarouselSlider` but with simplified items where the first item is the new `pagesNovoX` result. |
| **IW-8** | **Caller page cleanup** — Remove the now-unused `CarouselSliderController` field declarations from each caller page's state class. Remove the unused `import 'package:carousel_slider/...'` from each caller page. Update the `bottomSheet(...)` call to match the new function signature (fewer arguments). | Each caller page's state class no longer has `CarouselSliderController carouselController` or `controlerPages` fields (except N1 and reservatório callers which retain `controlerPages`). Unused `carousel_slider` imports are removed. |
| **IW-9** | Remove unused imports from bottom sheet wrapper files: `import 'package:carousel_slider/...'` is removed for N2, solução, and caderno campo wrappers (since the outer `CarouselSlider` is removed). N1 and reservatório wrappers retain the import. | `dart analyze` shows no unused import warnings in any modified file. |
| **IW-10** | **Submit button label change** — The `StepNavigationFooter` inside `AppStepWizard` renders `'Salvar'` on the last step. Existing manual wizards show `'Avançar'` (N2, solução, reservatório, caderno campo) or `'Novo'` (N1) on the last step. This is an **accepted minor label change**. The `submitLabel` parameter of `AppStepWizard` is reserved for future customization and is NOT changed in this wave. | Documented in Open Questions. |

#### Step Labels Mapping

| # | File | Steps | Step Labels | Step Count |
|---|------|-------|-------------|------------|
| 1 | `pagesNovoSetor.dart` (N2) | `nomePage`, `reservatorioPage` | `['Nome', 'Reservatório']` | 2 |
| 2 | `pagesNovaAreaCultivo.dart` (N1) | `nomePage`, `localizacaoPage` | `['Nome', 'Localização']` | 2 |
| 3 | `pagesNovaSolucao.dart` | `nomePage`, `fertilizantePage` | `['Nome', 'Fertilizantes']` | 2 |
| 4 | `pagesNovoReservatorio.dart` | `nomePage`, `volumePage`, `receitaPage` | `['Nome', 'Volume', 'Receita']` | 3 |
| 5 | `pagesNovoCadernoCampo.dart` | `atividadePage`, `autorPage`, `lotePage` | `['Autor', 'Lote', 'Atividade']` | 3 |

#### Affected Files

**Workstream H1 — pagesNovoX files (5 files)**

| # | File | Current Return | New Return | Controllers Removed |
|---|------|---------------|------------|-------------------|
| 1 | `lib/features/presenter/views/area_cultivo/N2/components/pagesNovoSetor.dart` | `SizedBox` with manual wizard | `Widget` returning `AppStepWizard` | `carouselController`, `controlerPages` |
| 2 | `lib/features/presenter/views/area_cultivo/N1/components/pagesNovaAreaCultivo.dart` | `SizedBox` with manual wizard | `Widget` returning `AppStepWizard` | `carouselController` (keeps `controlerPages`) |
| 3 | `lib/features/presenter/views/solucao/components/pagesNovaSolucao.dart` | `SizedBox` with manual wizard | `Widget` returning `AppStepWizard` | `carouselController`, `controlerPages` |
| 4 | `lib/features/presenter/views/reservatorio/cadastrar_reservatorio/components/pagesNovoReservatorio.dart` | `SizedBox` with manual wizard | `Widget` returning `AppStepWizard` | `carouselController` (keeps `controlerPages`) |
| 5 | `lib/features/presenter/views/caderno_campo/components/pagesNovoCadernoCampo.dart` | `SizedBox` with manual wizard | `Widget` returning `AppStepWizard` | `carouselController`, `controlerPages` |

**Workstream H2 — Bottom sheet wrappers (5 files)**

| # | File | Outer Items | Action | Controller Change |
|---|------|-------------|--------|------------------|
| 1 | `lib/features/presenter/views/area_cultivo/N2/components/bottomSheet.dart` | 1 | Remove outer `CarouselSlider` | Remove both params from function sig |
| 2 | `lib/features/presenter/views/area_cultivo/N1/components/bottomSheet.dart` | 2 | Keep outer `CarouselSlider` (simplify items) | Remove `carouselController` param |
| 3 | `lib/features/presenter/views/solucao/components/bottomSheet.dart` | 1 | Remove outer `CarouselSlider` | Remove both params from function sig |
| 4 | `lib/features/presenter/views/reservatorio/cadastrar_reservatorio/components/bottomSheet.dart` | 2 | Keep outer `CarouselSlider` (simplify items) | Remove `carouselController` param |
| 5 | `lib/features/presenter/views/caderno_campo/components/bottomSheet.dart` | 1 | Remove outer `CarouselSlider` | Remove both params from function sig |

**Workstream H3 — Caller pages (5 files)**

| # | File | Fields Removed | Import Change |
|---|------|---------------|--------------|
| 1 | `lib/features/presenter/views/area_cultivo/N2/cadastrar_setor_page.dart` | `carouselController`, `controlerPages` | Remove `carousel_slider` import |
| 2 | `lib/features/presenter/views/area_cultivo/N1/cadastrar_area_cultivo_page.dart` | `carouselController` (keep `controlerPages`) | Remove `carousel_slider` import (but ensure no compilation error — `novaLocalizacaoPage` still uses `carousel_slider` but that file keeps its own import) |
| 3 | `lib/features/presenter/views/solucao/cadastrar_solucao_page.dart` | `carouselController`, `controlerPages` | Remove `carousel_slider` import |
| 4 | `lib/features/presenter/views/reservatorio/cadastrar_reservatorio/cadastrar_resevatorio_page.dart` | `carouselController` (keep `controlerPages`) | Remove `carousel_slider` import |
| 5 | `lib/features/presenter/views/caderno_campo/cadastrar_caderno_campo_page.dart` | `carouselController`, `controlerPages` | Remove `carousel_controller` import |

---

## Design Decisions

### Decision 1: Bottom sheet categorization (simple vs. complex)

The 5 bottom sheets fall into two categories based on their outer `CarouselSlider` item count:

**Simple (3 files) — outer CarouselSlider has 1 item:**
- `N2/bottomSheet.dart` — items: `[pagesNovoSetor(...)]`
- `solucao/bottomSheet.dart` — items: `[pagesNovaSolucao(...)]`
- `caderno_campo/bottomSheet.dart` — items: `[pagesNovoCadernoCampo(...)]`

These are simplified by removing the outer `CarouselSlider` entirely and passing the `AppStepWizard` directly as `body` to `AppModalSheet`.

**Complex (2 files) — outer CarouselSlider has 2 items:**
- `N1/bottomSheet.dart` — items: `[pagesNovaAreaCultivo(...), novaLocalizacaoPage(...)]`
- `reservatorio/bottomSheet.dart` — items: `[pagesNewReservatorio(...), receitaDetalhe(...)]`

These retain the outer `CarouselSlider` because the external pages (`novaLocalizacaoPage`, `receitaDetalhe`, `receitaPage`) use `controlerPages` for cross-slider navigation (`controlerPages.nextPage()` / `controlerPages.previousPage()`). The inner wizard is still replaced with `AppStepWizard`, but the outer `CarouselSlider` structure is preserved.

### Decision 2: fertilizantePage's unused `controlerPages` parameter

The `fertilizantePage` function in `solucao` currently accepts `CarouselSliderController controlerPages` as a parameter but never uses it. After refactoring, there is no outer `CarouselSlider` to provide a meaningful `controlerPages`. Since the parameter goes unused inside the page, pass a no-op `CarouselSliderController()` instance to satisfy the function signature. The step page component itself is not modified.

### Decision 3: Submit button label change

The existing manual wizards show varying last-step button labels: `'Novo'` (N1), `'Avançar'` (all others). `AppStepWizard`'s `StepNavigationFooter` hardcodes `'Salvar'` on the last step. This is an accepted visual difference — the shared component's label is `'Salvar'` and changing it would require modifying `StepNavigationFooter` or adding `submitLabel` plumbing (out of scope). This change is functionally neutral (the button still calls `onSubmit`).

### Decision 4: Store `dotIndicator` field is preserved

The `store.dotIndicator` field exists in each store class and is used for manual step tracking in the current implementation. After refactoring, `AppStepWizard` manages step index internally via `_currentStep`. The store field is NOT removed (it may be used elsewhere or retained for backward compatibility). The wizard simply stops reading/writing it.

---

## Architecture

### Before (per file pattern)

```
bottomSheet (caller page)
  └── CarouselSlider (outer, 1 or 2 items)
       ├── pagesNovoX
       │    └── SizedBox
       │         ├── Close IconButton
       │         ├── DotsIndicator ← store.dotIndicator
       │         ├── CarouselSlider (inner) ← carouselController
       │         │    ├── nomePage(context, store)
       │         │    └── localizacaoPage(context, store)
       │         ├── Back TextButton
       │         └── NextStepButton ← store.dotIndicator
       └── [novaLocalizacaoPage / receitaDetalhe] (2-item cases only)
```

### After — Simple (N2, solução, caderno campo)

```
bottomSheet (caller page)
  └── pagesNovoX
       └── AppStepWizard
            ├── StepProgressBar
            ├── CarouselSlider ← internal controller
            │    ├── nomePage(context, store)
            │    └── localizacaoPage(context, store)
            └── StepNavigationFooter
```

### After — Complex (N1, reservatório)

```
bottomSheet (caller page)
  └── CarouselSlider (outer) ← controlerPages (retained)
       ├── pagesNovoX
       │    └── AppStepWizard
       │         ├── StepProgressBar
       │         ├── CarouselSlider ← internal controller
       │         │    ├── nomePage(context, store)
       │         │    └── localizacaoPage(context, store)
       │         └── StepNavigationFooter
       │              └── onSubmit → controlerPages.nextPage()
       └── [novaLocalizacaoPage / receitaDetalhe] ← controlerPages
```

### API surface change

Before:
```dart
// Each pagesNovoX returns SizedBox with full wizard
SizedBox pagesNovoX(
  BuildContext context,
  SomeStore store,
  CarouselSliderController carouselController,
  CarouselSliderController controlerPages,
);
```

After:
```dart
Widget pagesNovoX(
  BuildContext context,
  SomeStore store,
  [CarouselSliderController? controlerPages], // N1 and reservatório only
);
```

---

## Boundaries — What NOT to Change

1. **No step page component changes.** Do not modify the internal implementation, signature, or behavior of `nomePage`, `localizacaoPage`, `reservatorioPage`, `fertilizantePage`, `volumePage`, `receitaPage`, `atividadePage`, `autorPage`, `lotePage`, `novaLocalizacaoPage`, or `receitaDetalhe`. Only the call site in `pagesNovoX` may change (e.g., passing a dummy controller).

2. **No store logic changes.** Do not modify any store field, method, or MobX action. The `store.dotIndicator` field is preserved (it is simply no longer read by the wizard).

3. **No shared component modifications.** Do not modify `AppStepWizard`, `StepProgressBar`, `StepNavigationFooter`, `AppModalSheet`, or any other widget in `lib/features/presenter/widgets/common/`.

4. **No visual property changes.** Do not add, remove, or modify any `Color`, `EdgeInsets`, `BorderRadius`, `BoxShadow`, `FontSize`, `FontWeight`, or `TextStyle` values.

5. **No dependency additions or removals.** `pubspec.yaml` is unchanged. The `dots_indicator` import is removed from each `pagesNovoX` file (it becomes unused), but the package remains in `pubspec.yaml` (other files may still use it). The `carousel_slider` import is removed from caller pages and simple bottom sheets.

6. **No refactoring beyond Workstream H.** The `N3/finalizar_page/bottomSheet.dart` (uses `pagesFinalizacaoLote`), `protocolo/` files, and `get_bottom_sheet.dart` are out of scope.

7. **No changes to `StepNavigationFooter`'s `submitLabel`.** The button label on the last step remains `'Salvar'` even though some existing wizards show `'Novo'` or `'Avançar'`. This is an accepted variation.

---

## Validation Criteria

### Workstream H — Inner Wizard Adoption

1. **`git diff --stat`** confirms exactly the 15 files listed in the affected-files tables are changed (5 pagesNovoX + 5 bottom sheets + 5 caller pages). No extras, no omissions.

2. **Per-pagesNovoX scan:**
   - Function returns `Widget` (not `SizedBox`)
   - No `DotsIndicator`, `DotsDecorator`, or `dots_indicator` import in file
   - No `NextStepButton` class in file
   - No `store.dotIndicator` reads in the widget tree (the field may still appear in imports but wizard no longer references it)
   - Single `AppStepWizard` component in the return statement
   - `steps` list contains the same step page widgets as before

3. **Per-bottom-sheet scan:**
   - **Simple (N2, solução, caderno campo):** `body:` parameter is a direct widget reference (not a `CarouselSlider`). No `carousel_slider` import.
   - **Complex (N1, reservatório):** `body:` is a `CarouselSlider` with 2 items. `carousel_slider` import retained. `carouselController: controlerPages` retained.

4. **Per-caller scan:**
   - No `CarouselSliderController carouselController` field declaration
   - No `CarouselSliderController controlerPages` field declaration (except N1 and reservatório callers, which retain `controlerPages`)
   - No `import 'package:carousel_slider/...'` line
   - `bottomSheet(...)` call has the correct (reduced) argument list

5. **`dart analyze lib/features/presenter/views/`** — zero errors, zero warnings.

6. **Visual comparison** — each bottom sheet renders identically in structure except:
   - The step indicator has changed from dot-based (`DotsIndicator`) to bar-based (`StepProgressBar`)
   - The close button has moved from inside the wizard to `AppModalSheet`'s own header (already done in Wave 1)
   - The back/submit button labels and layout match `StepNavigationFooter`'s styling
   - The last step submit button reads `'Salvar'` instead of `'Novo'` or `'Avançar'`

7. **Navigation behavior preserved:**
   - **N2, solução, caderno campo:** press submit on last step → bottom sheet closes (`Navigator.pop`)
   - **N1:** press submit on last step → outer `CarouselSlider` advances to `novaLocalizacaoPage`
   - **Reservatório:** press submit on last step → bottom sheet closes; `receitaPage`'s internal button still advances outer `CarouselSlider` to `receitaDetalhe`

8. **No dead CarouselSliderController fields** remain in caller pages (verified by grep).

---

## Open Questions

1. **IW-10 (Submit button label).** The `StepNavigationFooter` inside `AppStepWizard` renders `'Salvar'` on the last step. The existing manual wizards show `'Avançar'` (N2, solução, reservatório, caderno campo) or `'Novo'` (N1) on the last step. This creates a label inconsistency. Two options:
   - **(Recommended) Accept the change.** The label `'Salvar'` is arguably more accurate for the submit action. The `submitLabel` parameter exists on `AppStepWizard` but `StepNavigationFooter` ignores it (hardcoded `'Salvar'`). Fixing this requires changing `StepNavigationFooter` (a shared component) — deferred to a follow-up wave if needed.
   - Add plumbing so that `AppStepWizard.submitLabel` actually flows to `StepNavigationFooter`. This changes a shared component (see Boundaries).

2. **N1 bottom sheet ("Novo" button → "Salvar").** In N1's current implementation, the inner wizard's last step shows `'Novo'` with an `Icons.add` icon, and pressing it advances to `novaLocalizacaoPage`. After refactoring, the last step shows `'Salvar'` and pressing it also advances to `novaLocalizacaoPage` (via `onSubmit`). The label changes from `'Novo'` to `'Salvar'` and the icon changes from `Icons.add` + `Icons.chevron_right` to `Icons.chevron_right` only. This is an accepted visual difference. Confirm with the team.

3. **fertilizantePage's unused `controlerPages` parameter.** The function signature `fertilizantePage(BuildContext context, CarouselSliderController controlerPages)` accepts a controller that is never used. After refactoring, we pass a dummy `CarouselSliderController()` to satisfy the signature. Should we instead make the parameter optional or remove it? **Recommendation:** Leave as-is — pass a dummy controller. Changing the function signature would modify a step page component (boundary violation). The dummy controller is harmless since it's never used.

4. **Reservatório outer slider behavior.** In the reservatório flow, `receitaPage` (inner step 2) has an internal button that calls `controlerPages.nextPage()` to advance to `receitaDetalhe`. The outer `CarouselSlider` is preserved, so `controlerPages` remains functional. The `AppStepWizard`'s `onSubmit` pops the sheet (matching the current inline "Avançar" button on the last step). This dual-path behavior (internal button → receitaDetalhe, submit → pop) is preserved from the existing implementation. Confirm that this matches the intended UX.

5. **N3 finalizar_page bottom sheet.** The file `N3/components/finalizar_page/bottomSheet.dart` also follows the same pattern (outer `CarouselSlider` with 1 item wrapping a wizard function). However, it uses `pagesFinalizacaoLote` which is NOT one of the 5 `pagesNovoX` files listed in this wave. Is `finalizar_page/bottomSheet.dart` intentionally left for a future wave, or should it be included in this one? **Recommendation:** Exclude for now — it was also excluded from Wave 1 and appears to follow a different flow.

6. **Remove unused carousel_slider from bottom sheets.** For the 3 simplified bottom sheets, the `carousel_slider` import is removed. For the 2 complex ones (N1, reservatório), the import is retained because the outer `CarouselSlider` remains. Verify that no other references to `CarouselSlider` or `CarouselSliderController` remain in the simplified files after the removal.
