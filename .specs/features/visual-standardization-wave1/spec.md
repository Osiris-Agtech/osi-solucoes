# Visual Standardization — Wave 1

## Feature Overview

Standardize three recurring UI patterns across the cultivation management app: unify form headers to use `AppFormHeader`, replace ad-hoc bottom sheet invocations with `AppModalSheet`, and extract a reusable `AppStepWizard` component from the duplicated CarouselSlider + step navigation pattern. All three workstreams are structurally independent — they share no files and can be implemented and validated in any order.

---

## Requirements

### Workstream A — Form Headers Standardization (FH)

| ID | Requirement | Verification |
|----|------------|-------------|
| **FH-1** | Inline `AppFormHeader` usage in `Scaffold.appBar` — remove the separate `appBar()` method from every affected cadastro page. The `AppFormHeader` must be passed directly to `Scaffold(appBar: AppFormHeader(...))`. | No `appBar()` method (method definition + call via `appBar: appBar()`) remains in any of the affected files after refactoring. |
| **FH-2** | Preserve all existing `AppFormHeader` constructor arguments (`onBack`, `title`, `actions`) exactly as they appear in the current `appBar()` method or inline usage. Do not add or remove arguments unless a title is explicitly missing (see FH-3). | `git diff` shows only structural relocation of `AppFormHeader` instantiation — no added/changed/removed properties. |
| **FH-3** | For `cadastrar_lote_page.dart` (which already inlines `AppFormHeader` without a title), evaluate whether a `title` property should be added based on the existing page heading text (`'Criando Novo Lote'` / `'Alterando Lote'`). If added, move the heading text into `AppFormHeader.title`. | Either a `title` is added to the inline `AppFormHeader`, or a spec decision record explains why it was intentionally omitted. |
| **FH-4** | For pages that currently have a custom `appBar()` method returning `AppFormHeader(onBack: () => Get.back())` *without* a title, and also have a standalone `titulo()`/heading widget below it (e.g., `cadastrar_area_cultivo_page.dart`, `cadastrar_setor_page.dart`), the heading text should be moved into `AppFormHeader.title` and the standalone heading widget should be removed if no longer referenced elsewhere. | The page heading text appears exactly once — either in `AppFormHeader.title` or retained as a standalone widget if the widget is reused elsewhere on the page. No duplicated heading text in both header and body. |
| **FH-5** | Remove the `appBar()` method definition entirely from each affected file once its logic has been inlined. | File no longer contains a method named `appBar`. |

#### Affected Files — Workstream A

| # | File | Lines | Current Pattern | Notes |
|---|------|-------|----------------|-------|
| 1 | `lib/features/presenter/views/area_cultivo/N1/cadastrar_area_cultivo_page.dart` | 302 | Method `AppFormHeader appBar()` at line 172, called at line 59 via `appBar: appBar()`. No title set. Standalone `titulo()` widget (`'Criando Nova Área de Cultivo'`) at line ~158. | Move heading into `AppFormHeader(title: 'Criando Nova Área de Cultivo')`, remove standalone `titulo()` if unused elsewhere. |
| 2 | `lib/features/presenter/views/area_cultivo/N2/cadastrar_setor_page.dart` | 362 | Method `AppFormHeader appBar()` at line 236, called at line 59 via `appBar: appBar()`. No title set. Standalone `titulo()` widget (`'Criando Novo Setor'`) at line ~225. | Same pattern as N1. |
| 3 | `lib/features/presenter/views/area_cultivo/N3/cadastrar_lote_page.dart` | 183 | Already has inline `AppFormHeader(onBack: ...)` at line 66 — no `appBar()` method. No title set. Page heading is `Text('Criando Novo Lote')` at line ~83. | Already inline. Only requires FH-3 evaluation. |
| 4 | `lib/features/presenter/views/reservatorio/cadastrar_reservatorio/cadastrar_resevatorio_page.dart` | 271 | Method `AppFormHeader appBar()` at line 148, called at line 51 via `appBar: appBar()`. No title set. Standalone `titulo()` widget (`'Novo Reservatório'`) at line ~138. | Same pattern as N1. |
| 5 | `lib/features/presenter/views/solucao/cadastrar_solucao_concentrada_page.dart` | 876 | Method `AppFormHeader appBar()` at line 126, called at line 54 via `appBar: appBar()`. No title set. Standalone heading (`'Nova Solução Nutritiva'`) at line ~116. | Same pattern as N1. |
| 6 | `lib/features/presenter/views/solucao/cadastrar_solucao_page.dart` | 609 | Method `AppFormHeader appBar()` at line 517, called at line 68 via `appBar: appBar()`. No title set. Standalone heading (`'Nova Solução Nutritiva'`) at line ~508. | Same pattern as N1. |

---

### Workstream B — AppStepWizard Creation (SW)

| ID | Requirement | Verification |
|----|------------|-------------|
| **SW-1** | Create a new shared component `AppStepWizard` in `lib/features/presenter/widgets/common/app_step_wizard.dart`. | File exists at the specified path. |
| **SW-2** | The component must encapsulate the three-part pattern: (a) a step progress indicator (bar + labels), (b) a `CarouselSlider` body area with non-scrollable, non-infinite pages, and (c) a navigation footer with back/step-counter/next-or-submit controls. | Widget tree contains a progress indicator at the top, a `CarouselSlider` in the middle, and a navigation bar at the bottom. |
| **SW-3** | The existing `StepProgressBar` (`lib/features/presenter/views/area_cultivo/N3/components/cadastrar_page/step_progress_bar.dart`) and `StepNavigationFooter` (`step_navigation_footer.dart`) in the `cadastrar_lote_page` directory must be reused — either by delegation or by inlining — rather than reimplemented from scratch. | The final `AppStepWizard` references `StepProgressBar` and/or `StepNavigationFooter`, or these files are removed and their logic is moved into `AppStepWizard` (with an ADR noting the decision). |
| **SW-4** | The component must accept a list of step widgets (`List<Widget> steps`), store the current step index internally via a `ValueNotifier<int>` or a supplied store/controller, and expose `onSubmit` for the final step. | Constructor includes `required List<Widget> steps` and `required VoidCallback onSubmit`. Step navigation (next/back) is handled internally. |
| **SW-5** | The `CarouselSlider` controller must be internal to the component — callers should not need to pass or manage a `CarouselSliderController`. | No `CarouselSliderController` parameter in the public constructor. |
| **SW-6** | Visual output must be identical to the existing per-page implementations when used with the same step content. | Screenshot comparison or visual inspection shows no layout, color, font, or spacing differences between old and new wizard on any step. |
| **SW-7** | The component must not introduce any new dependencies beyond those already used by the existing wizard pages (`carousel_slider`, `flutter/material.dart`, existing constants). | `pubspec.yaml` is unchanged. |

#### Affected Files — Workstream B

| # | File | Action | Notes |
|---|------|--------|-------|
| 1 | `lib/features/presenter/widgets/common/app_step_wizard.dart` | **Create** | New shared component. |
| 2 | `lib/features/presenter/views/area_cultivo/N3/components/cadastrar_page/step_progress_bar.dart` | **Reuse** | Existing widget; may be delegated-to or inlined into the new component. |
| 3 | `lib/features/presenter/views/area_cultivo/N3/components/cadastrar_page/step_navigation_footer.dart` | **Reuse** | Existing widget; may be delegated-to or inlined into the new component. |

> **Note:** Migration of existing pages to use `AppStepWizard` is **not** in scope for Wave 1. Only the component itself is being created. Adoption in the existing cadastro pages is deferred to a follow-up wave.

---

### Workstream C — Bottom Sheet Refactoring (BW)

| ID | Requirement | Verification |
|----|------------|-------------|
| **BW-1** | Replace every direct `showModalBottomSheet(...)` call in the affected bottom sheet files with `AppModalSheet.show(...)`. The visual result must be identical. | No remaining `showModalBottomSheet` calls in any of the affected files. |
| **BW-2** | When migrating, preserve the `barrierColor`, `isScrollControlled`, and border radius implicitly via `AppModalSheet` defaults. Do not re-specify these values — they are already correct in `AppModalSheet.show()`. | The diff shows removal of `shape:` / `barrierColor:` / `isScrollControlled:` configuration — these are not re-declared. |
| **BW-3** | Provide a meaningful `title` string to `AppModalSheet.show()` for each bottom sheet. Derive the title from the existing page/step context (e.g., `'Nova Área de Cultivo'`, `'Novo Setor'`, `'Novo Reservatório'`). If the bottom sheet contains multiple steps (CarouselSlider), use a generic title like the registration object name or the first step's context. | Every `AppModalSheet.show()` call has a non-empty `title` argument. |
| **BW-4** | For bottom sheets that use `CarouselSlider` with step pages, the `CarouselSlider` widget must be passed as the `body:` parameter of `AppModalSheet.show()`. Do not alter the CarouselSlider configuration itself. | The CarouselSlider options (height, viewportFraction, scrollPhysics, enableInfiniteScroll) are untouched. |
| **BW-5** | Preserve every constructor parameter of the `bottomSheet()` function — the callers (cadastro pages) must not need to change their invocation. The refactoring must be backwards-compatible at the call site. | Caller files (cadastro pages) show zero changes in `git diff`. |
| **BW-6** | For `agenda/components/detalhes_bottomSheet.dart`: the `DetalhesBottomSheet` is a `StatefulWidget` opened via `getBottomSheet()` rather than `showModalBottomSheet`. Do not refactor this file in Wave 1 — it does not use `showModalBottomSheet` and does not follow the same pattern as the other bottom sheets. | `detalhes_bottomSheet.dart` is excluded from Wave 1 changes. |
| **BW-7** | Remove unused imports (e.g., `package:flutter/material.dart` if no longer needed after removing `showModalBottomSheet`, `package:carousel_slider` if CarouselSlider is still used in `body`). | Post-refactoring `dart analyze` shows no unused import warnings for the affected files. |

#### Affected Files — Workstream C

| # | File | Lines | Pattern | Notes |
|---|------|-------|---------|-------|
| 1 | `lib/features/presenter/views/area_cultivo/N1/components/bottomSheet.dart` | 45 | `showModalBottomSheet` + `CarouselSlider` (2 items) | Replace manual sheet with `AppModalSheet.show(title: 'Nova Área de Cultivo', body: CarouselSlider(...))`. |
| 2 | `lib/features/presenter/views/area_cultivo/N2/components/bottomSheet.dart` | 42 | `showModalBottomSheet` + `CarouselSlider` (1 item) | Same as above. |
| 3 | `lib/features/presenter/views/area_cultivo/N3/components/finalizar_page/bottomSheet.dart` | 41 | `showModalBottomSheet` + `CarouselSlider` (1 item) | Same as above. |
| 4 | `lib/features/presenter/views/solucao/components/bottomSheet.dart` | 42 | `showModalBottomSheet` + `CarouselSlider` (1 item) | Same as above. |
| 5 | `lib/features/presenter/views/reservatorio/cadastrar_reservatorio/components/bottomSheet.dart` | 45 | `showModalBottomSheet` + `CarouselSlider` (2 items) | Same as above. |
| 6 | `lib/features/presenter/views/caderno_campo/components/bottomSheet.dart` | 43 | `showModalBottomSheet` + `CarouselSlider` (1 item) | Same as above. |
| 7 | `lib/features/presenter/views/agenda/components/detalhes_bottomSheet.dart` | 771 | `Get.bottomSheet` via `getBottomSheet()` with `StatefulWidget` | **Explicitly excluded** from Wave 1 (BW-6). |

---

## Boundaries — What NOT to Change

1. **No business logic or store behavior.** The store calls (`store.buscarX()`, `store.limparTudo()`, etc.) must remain identical — same invocations, same order, same conditional guards.

2. **No visual properties.** Do not add, remove, or modify any `Color`, `EdgeInsets`, `BorderRadius`, `BoxShadow`, `FontSize`, `FontWeight`, or `TextStyle` values. The shared components (`AppFormHeader`, `AppModalSheet`) already encode the correct design tokens.

3. **No shared component modifications.** The files in `lib/features/presenter/widgets/common/` are off-limits — do not edit `AppFormHeader`, `AppModalSheet`, `AppPrimaryButton`, or any other existing shared component. Only `app_step_wizard.dart` is new.

4. **No caller-side changes (Workstream C).** The function signatures of `bottomSheet()` in each workstream-C file must remain backwards-compatible — the cadastro pages that call `bottomSheet(context, carouselController, controlerPages, store)` must not need edits.

5. **No dependency additions.** `pubspec.yaml` must remain unchanged. The `app_step_wizard.dart` component must use only packages already declared in the project (`carousel_slider`, `flutter`, existing constants/theme).

6. **No refactoring beyond Wave 1 scope.** Do not adopt `AppStepWizard` in any existing page (deferred). Do not refactor bottom sheets outside the 6 listed files (e.g., `protocolo/`, `relatorios/`, `solucao/detalhes_solucao.dart` are out of scope). Do not refactor the `caderno_campo/cadastrar_caderno_campo_page.dart` or `cadastrar_protocolo_page.dart` headers even though they follow the same `AppFormHeader appBar()` pattern — they are not in the Wave 1 file list.

7. **No changes to `get_bottom_sheet.dart`.** The shared utility function must stay as-is.

---

## Validation Criteria

### Workstream A — Form Headers

1. **`git diff --stat`** confirms all 6 listed files are changed (no extras, no omissions).
2. **Per-file scan**: each file's `build()` method uses `appBar: AppFormHeader(...)` directly (no `appBar()` method call), and no `appBar()` method definition exists in the file.
3. **Title audit**: each page heading text appears exactly once — either in `AppFormHeader.title` or as a standalone widget (if reused outside the header area). No duplicated text.
4. **`dart analyze lib/features/presenter/views/`** — zero errors, zero warnings.
5. **Visual comparison** — each affected page renders identically before and after (same back button, same title, same layout below the header).

### Workstream B — AppStepWizard

1. **File exists** at `lib/features/presenter/widgets/common/app_step_wizard.dart`.
2. **API surface** includes:
   - `required List<Widget> steps`
   - `required VoidCallback onSubmit`
   - Internal step index tracking (no external controller required)
   - Back navigation disabled on first step; next/submit disabled on last step until per-step validation passes (if applicable)
3. **`dart analyze lib/features/presenter/widgets/common/app_step_wizard.dart`** — zero errors, zero warnings.
4. **No new dependencies** — `pubspec.yaml` unchanged.
5. **Reuses** `StepProgressBar` and/or `StepNavigationFooter` (delegation or inlining) with an ADR documenting which approach was chosen and why.

### Workstream C — Bottom Sheets

1. **`git diff --stat`** confirms exactly the 6 listed bottom sheet files are changed (agenda `detalhes_bottomSheet.dart` excluded).
2. **No `showModalBottomSheet`** calls remain in any of the 6 changed files.
3. **Each changed file** calls `AppModalSheet.show(title: ..., body: ...)`.
4. **Imports cleaned** — `package:flutter/material.dart` removed if unused after the change; `package:carousel_slider` retained if still used inside `body`.
5. **Caller files unchanged** — `git diff` shows zero modifications in N1/cadastrar_area_cultivo_page.dart, N2/cadastrar_setor_page.dart, etc.
6. **`dart analyze lib/features/presenter/views/`** — zero errors, zero warnings.

---

## Open Questions

1. **FH-3 (cadastrar_lote_page.dart):** The page already uses inline `AppFormHeader` without a title, and has a separate `Text('Criando Novo Lote')` heading. Should the title be added now, or left for a follow-up wave that standardizes heading text in all forms? **Recommendation:** Add the title now — `AppFormHeader(title: 'Criando Novo Lote', ...)` — and remove the duplicate heading text, as this is a trivial change and brings the page fully in line with the pattern.

2. **SW-3 (Reuse strategy):** Should `AppStepWizard` delegate to the existing `StepProgressBar` and `StepNavigationFooter` (keeping those files) or inline their logic and delete them? **Recommendation:** Delegate — keep the existing files, compose them inside `AppStepWizard`. This minimizes diff and allows the components to evolve independently later.

3. **Bottom sheet titles (BW-3):** Several cadastro bottom sheets contain a `CarouselSlider` with multiple step pages that change context. What single title is appropriate for each? Suggested mapping:
   - N1 area: `'Nova Área de Cultivo'`
   - N2 setor: `'Novo Setor'`
   - N3 finalizar lote: `'Finalizar Lote'`
   - Solução: `'Nova Solução Nutritiva'`
   - Reservatório: `'Novo Reservatório'`
   - Caderno campo: `'Novo Caderno de Campo'`
   
   These match the entity names used in the page headings and should be confirmed with the team before implementation.
