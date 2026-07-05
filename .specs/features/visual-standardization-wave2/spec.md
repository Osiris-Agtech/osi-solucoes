# Visual Standardization — Wave 2

## Feature Overview

Continue the UI standardization effort from Wave 1 by addressing three remaining patterns: (1) adopt the `AppStepWizard` component created in Wave 1 on the first eligible page, (2) extract a shared inline form validation component to replace duplicated inline error `Text` widgets, and (3) extract a shared delete-confirmation dialog to replace 5 duplicated `_confirmarDelecao` implementations. All three workstreams are structurally independent, touching separate files.

---

## Requirements

### Workstream D — AppStepWizard Adoption (AD)

**Prerequisite:** The `AppStepWizard` component already exists at `lib/features/presenter/widgets/common/app_step_wizard.dart` (created in Wave 1) and encapsulates `StepProgressBar` + `CarouselSlider` + `StepNavigationFooter`. This workstream adopts it in a page that currently wires those three pieces manually.

| ID | Requirement | Verification |
|----|------------|-------------|
| **AD-1** | Replace the manual step management in `cadastrar_lote_page.dart` — field variables `currentStep`, `completedSteps`, `totalSteps`, `stepLabels` — plus the widget tree `StepProgressBar`, `AnimatedSwitcher` (with `_buildStepContent()`), and `StepNavigationFooter` with a single `AppStepWizard(steps: [...], onSubmit: ..., stepLabels: [...])` component. | File diff shows removal of `currentStep`, `completedSteps`, `_canGoForward()`, `_onNext()`, `_onBack()`, `_buildStepContent()`, and the three widgets; replacement by a single `AppStepWizard` in the build tree. |
| **AD-2** | The `steps` list must contain the 5 existing step widgets in order: `SetorStep`, `LoteStep`, `CulturaStep`, `ReservatorioStep`, `ProtocoloStep`. Each must receive a unique `ValueKey(currentStep)` as currently done via `_buildStepContent()`. | `steps` parameter is `[SetorStep(...), LoteStep(...), CulturaStep(...), ReservatorioStep(...), ProtocoloStep(...)]`. |
| **AD-3** | The `onSubmit` callback must preserve the exact same submit logic as the current `_onSubmit()` method: call `store.validarRegistro()` first, then conditionally call `store.alterarLote()` or `store.registrarLote()` based on `store.isEditing`. | The `onSubmit` closure in the new code is textually identical to the old `_onSubmit()` body. |
| **AD-4** | The `stepLabels` must be the same 5 strings: `['Setor', 'Lote', 'Cultura', 'Reservatório', 'Protocolo']`. | `stepLabels` list matches the original `static const List<String> stepLabels`. |
| **AD-5** | Remove the `_onBack`, `_onNext`, `_canGoForward` methods since `AppStepWizard` handles navigation internally. Remove the `_buildStepContent()` method. Remove the `formKey` field if it was only used inside step widgets (step widgets already receive it independently). | Methods `_onBack`, `_onNext`, `_canGoForward`, `_buildStepContent` no longer exist in the file. |
| **AD-6** | Remove unused imports: `step_progress_bar.dart`, `step_navigation_footer.dart` — these are now used only indirectly via `AppStepWizard` (which imports them). Retain the import of `app_step_wizard.dart`. Also remove `package:carousel_slider` if no other usage remains. | `dart analyze` shows no unused import warnings. The file does not directly reference `StepProgressBar`, `StepNavigationFooter`, or `CarouselSlider`. |
| **AD-7** | The `Observer` builder that wraps `StepNavigationFooter` to pass `isLoading: store.isNovoLoteLoading` must be handled. `AppStepWizard` does not currently expose `isLoading`. If `AppStepWizard`'s `StepNavigationFooter` does not already observe `isNovoLoteLoading`, either (a) wrap the entire `AppStepWizard` in an `Observer` and add an `isLoading` parameter to `AppStepWizard`, or (b) keep the `Observer` around `AppStepWizard` and pass a loading state if the component accepts it. **Recommendation:** Discard the loading overlay on the footer for now — `StepNavigationFooter` already has an `isLoading` parameter (defaults to `false`) and the observable loading state was previously injected via `Observer`. Since `AppStepWizard` does not expose `isLoading`, the simplest path is to not pass loading state in this wave and accept that the footer will not show a loading spinner during submit. This is a visual regression that should be documented and fixed in a follow-up. If this is unacceptable, add an optional `isLoading` parameter to `AppStepWizard` (which is a shared component modification — see Boundaries). **Decision required.** | See Open Questions. |
| **AD-8** | Visual output must be identical to the current page on every step, except for the loading spinner on the submit button (see AD-7). The step progress bar, step labels, step content area, and navigation footer buttons must appear in the same positions with the same sizing and styling. | Screenshot comparison shows no layout or styling differences in non-loading states. |

#### Affected Files — Workstream D

| # | File | Lines | Action | Notes |
|---|------|-------|--------|-------|
| 1 | `lib/features/presenter/views/area_cultivo/N3/cadastrar_lote_page.dart` | 171 | **Modify** | Replace manual step management with `AppStepWizard`. |

> **Note:** Adoption of `AppStepWizard` in `cadastrar_area_cultivo_page.dart` (the bottom sheet with CarouselSlider) is **out of scope for Wave 2** deferred.

---

### Workstream E — Form Validation Component (VC)

Currently, 3 cadastro pages display validation errors using an inline `Text` widget with hardcoded red styling. Create a shared `AppValidationMessage` widget and replace all occurrences.

| ID | Requirement | Verification |
|----|------------|-------------|
| **VC-1** | Create `AppValidationMessage` at `lib/features/presenter/widgets/common/app_validation_message.dart`. | File exists at the specified path. |
| **VC-2** | The widget must accept a `String? message` parameter. When `message` is `null` or empty, render `SizedBox.shrink()` (zero space). When non-empty, render compact inline error text with optional icon. | `message == null || message.isEmpty` → `SizedBox.shrink()`. Non-empty → visible widget. |
| **VC-3** | The visual style must match the existing inline validation pattern exactly: `fontSize: 12`, `color: Constants.kErrorColor`, `fontStyle: FontStyle.italic`, `fontWeight: FontWeight.w600`. Maintain the same left padding (`16.0`) and bottom padding (`8.0`). | Styling matches the existing `Text` widgets' `TextStyle`. |
| **VC-4** | The icon is optional (defaults to `null`). When provided, it appears as a small `Icons.error_outline` (size 14) before the text, with a gap of 4px. | Visual inspection shows icon + gap + text when icon is non-null; text-only when icon is null. |
| **VC-5** | The component must be a `StatelessWidget` or a simple function widget. No mutable state. | Class does not extend `StatefulWidget`. |
| **VC-6** | Replace each inline `Text('Nome obrigatório')` / `Text('Volume obrigatório')` block in the 3 affected files with `AppValidationMessage(message: store.mostrarErroFormulario && store.xxx.text.isEmpty ? 'Nome obrigatório' : null)`. The `Visibility` wrapper and the `Padding` wrapper must be removed (the component incorporates padding and the conditional rendering internally). | Each replacement reduces the widget tree from `Visibility > Padding > Text` to a single `AppValidationMessage`. |
| **VC-7** | No visual properties changed — the replacement must produce the same rendered output (same font size, color, italic, weight, padding). | Screenshot comparison or DOM inspection shows identical rendering at the same position. |
| **VC-8** | After replacement, remove the `Visibility` import if no longer used elsewhere in each file. | `dart analyze` shows no unused import warnings. |

#### Affected Files — Workstream E

| # | File | Lines | Replacements | Notes |
|---|------|-------|-------------|-------|
| 1 | `lib/features/presenter/views/area_cultivo/N1/cadastrar_area_cultivo_page.dart` | 285 | 1 block (lines 75-95): `'Nome obrigatório'` | Replace `Visibility(visible: store.mostrarErroFormulario && ...) > Padding > Text` with single `AppValidationMessage(...)`. |
| 2 | `lib/features/presenter/views/area_cultivo/N2/cadastrar_setor_page.dart` | 345 | 1 block (lines 81-101): `'Nome obrigatório'` | Same pattern as above. |
| 3 | `lib/features/presenter/views/reservatorio/cadastrar_reservatorio/cadastrar_resevatorio_page.dart` | 254 | 2 blocks: `'Nome obrigatório'` (lines 65-85) and `'Volume obrigatório'` (lines 88-108) | Two separate validation messages on the same page. |

---

### Workstream F — AppDeleteDialog Component (DD)

There are 5 duplicate `_confirmarDelecao` methods across the codebase, all following the same `AlertDialog` pattern: warning icon + title, message text, information box (red-tinted `Container`), and Cancel/Delete buttons. Create a shared `AppDeleteDialog` component and replace all 5 implementations.

| ID | Requirement | Verification |
|----|------------|-------------|
| **DD-1** | Create `AppDeleteDialog` at `lib/features/presenter/widgets/common/app_delete_dialog.dart` with the static `show` method matching the proposed API. | File exists with class `AppDeleteDialog` containing a static `Future<bool> show(...)` method. |
| **DD-2** | The dialog must visually match the existing `AlertDialog` pattern across all 5 implementations: same title row layout (`Icons.warning_rounded` + `SizedBox(8)` + `Expanded(Text(...))` with `fontSize: 18`, `fontWeight: FontWeight.w600`), same message text styling (`fontSize: 15`, `height: 1.4`), same info box styling (red-tinted `Container` with `padding: 12`, `borderRadius: 8`, `color: Constants.kErrorColor.withValues(alpha: 0.08)`, icon `Icons.info_outline size: 18`, text `fontSize: 13`, `color: Constants.kErrorColor`, `height: 1.3`), same action buttons (`TextButton` for cancel, `FilledButton` with `Constants.kErrorColor` for delete). | Visual inspection or DOM attribute comparison shows the 5 old dialogs and the new shared dialog produce identical structures. |
| **DD-3** | The API must accept `title`, `message`, `infoText` as required strings. The `infoText` is rendered inside the info box. If `infoText` is empty or null, the info box is omitted (not shown as empty space). | `infoText` being `null` or empty → no info box rendered. |
| **DD-4** | `confirmLabel` defaults to `'Deletar'` and `cancelLabel` defaults to `'Cancelar'`. | Callers can omit these labels and get the defaults. |
| **DD-5** | The method returns `true` when the user taps the delete button, `false` when cancelling or dismissing (backdrop tap). | `Future<bool>` resolves correctly for both outcomes. |
| **DD-6 to DD-10** | Replace each of the 5 `_confirmarDelecao` methods with a call to `AppDeleteDialog.show(...)`. For each replacement: the entity-specific `title` (e.g. `'Deletar lote?'`), `message` (e.g. `'O lote "$nomeLote" ...'`), and `infoText` (e.g. `'Agendas com atividades...'`) must be preserved. The post-dialog block `if (confirmou == true && context.mounted) { store.deletarX(...) }` must remain unchanged. | Each file's `_confirmarDelecao` method body is reduced to approximately 10 lines: declare `nomeX`, call `AppDeleteDialog.show(...)`, and the `if` block. |
| **DD-6** | `detalhes_lote_page.dart` — `_confirmarDelecao` (line 42, body lines 42-116) | Replace `showDialog< bool >(builder: AlertDialog(...))` with `AppDeleteDialog.show(title: 'Deletar lote?', message: ..., infoText: ...)`. |
| **DD-7** | `setor_page.dart` (N2) — `_confirmarDelecaoArea` (line 203, body lines 203-277) | Same replacement. Method name `_confirmarDelecaoArea` preserved. |
| **DD-8** | `lote_page.dart` (N3) — `_confirmarDelecaoSetor` (line 224, body lines 224-298) | Same replacement. Method name `_confirmarDelecaoSetor` preserved. |
| **DD-9** | `detalhes_reservatorio_page.dart` — `_confirmarDelecao` (line 41, body lines 41-116) | Same replacement. |
| **DD-10** | `detalhes_solucao.dart` — `_confirmarDelecao` (line 19, body lines 19-94) | Same replacement. Note: this method additionally calls `Navigator.pop(context)` before `await store.deletarSolucaoNutritiva(...)`. This extra `pop` must be preserved. |

#### Mapping: Original → Shared Parameters

| File | title | message | infoText | Post-dialog store call |
|------|-------|---------|----------|----------------------|
| `detalhes_lote_page.dart` | `'Deletar lote?'` | `'O lote "$nomeLote" e todas as agendas vinculadas serão desativados permanentemente.'` | `'Agendas com atividades planejadas para este lote também serão removidas.'` | `store.deletarLoteCascade(store.loteSelecionado.id!)` |
| `setor_page.dart` (N2) | `'Deletar área?'` | `'A área "$nomeArea", todos os setores, lotes e agendas vinculados serão desativados permanentemente.'` | `'Setores, lotes e agendas desta área também serão removidos em cascata.'` | `areaStore.deletarAreaCascade(widget.areaN1.id!)` |
| `lote_page.dart` (N3) | `'Deletar setor?'` | `'O setor "$nomeSetor", todos os lotes e agendas vinculados serão desativados permanentemente.'` | `'Lotes e agendas deste setor também serão removidos em cascata.'` | `setorStore.deletarSetorCascade(widget.setorN2.id!)` |
| `detalhes_reservatorio_page.dart` | `'Deletar reservatório?'` | `'O reservatório "$nomeReservatorio" será desativado permanentemente.'` | `'Lotes e setores vinculados não serão afetados. Apenas o reservatório será removido.'` | `store.deletarReservatorio(store.reservatorioDetalhes.id!)` |
| `detalhes_solucao.dart` | `'Deletar solução?'` | `'A solução nutritiva "$nomeSolucao" será desativada permanentemente.'` | `'Reservatórios vinculados não serão afetados. Apenas a solução será removida.'` | `Navigator.pop(context); await store.deletarSolucaoNutritiva(store.solucaoSelecionada.id!)` |

---

## Boundaries — What NOT to Change

1. **No business logic or store behavior.** Store calls (`store.deletarLoteCascade()`, `store.validarRegistro()`, etc.) must remain identical — same invocations, same order, same conditional guards.

2. **No visual properties.** Do not add, remove, or modify any `Color`, `EdgeInsets`, `BorderRadius`, `BoxShadow`, `FontSize`, `FontWeight`, or `TextStyle` values. The new shared components (`AppValidationMessage`, `AppDeleteDialog`) should reproduce exactly the same visual properties as the code they replace.

3. **No shared component modifications.** The files in `lib/features/presenter/widgets/common/` that already exist (`AppFormHeader`, `AppModalSheet`, `AppPrimaryButton`, `AppStepWizard`) are off-limits. Only the two new files (`app_validation_message.dart`, `app_delete_dialog.dart`) are created.

4. **No scope creep.** Do not refactor pages or patterns beyond the files listed in each workstream's affected-files table. Do not adopt `AppStepWizard` in pages other than `cadastrar_lote_page.dart`. Do not replace validation patterns other than the specific `Text('... obrigatório')` blocks listed. Do not modify the `StepProgressBar` or `StepNavigationFooter` components.

5. **No dependency additions.** `pubspec.yaml` must remain unchanged. The new components must use only packages and constants already declared in the project.

6. **No renaming of existing methods.** The `_confirmarDelecao`, `_confirmarDelecaoArea`, `_confirmarDelecaoSetor` method names and their call sites must be preserved — only the method body is changed.

7. **No changes to `get_bottom_sheet.dart` or other shared utilities.**

---

## Validation Criteria

### Workstream D — AppStepWizard Adoption

1. **`git diff --stat`** confirms only `cadastrar_lote_page.dart` is changed.
2. **`git diff`** shows removal of `currentStep`, `completedSteps`, `totalSteps`, `stepLabels` field declarations.
3. **`git diff`** shows removal of `StepProgressBar`, `AnimatedSwitcher`, `StepNavigationFooter` from the widget tree.
4. **`git diff`** shows removal of `_buildStepContent()`, `_canGoForward()`, `_onNext()`, `_onBack()` methods.
5. **`git diff`** shows addition of a single `AppStepWizard` component in the build method, with the same 5 step widgets and the same `onSubmit` logic.
6. **`git diff`** shows removal of now-unused imports (`step_progress_bar.dart`, `step_navigation_footer.dart`).
7. **`dart analyze lib/features/presenter/views/area_cultivo/N3/cadastrar_lote_page.dart`** — zero errors, zero warnings.
8. **Visual comparison** — each step renders identically (step bar, content, navigation) except for the submit loading indicator (see AD-7 / Open Questions).

### Workstream E — Form Validation Component

1. **`git diff --stat`** confirms 4 files changed: the new component + 3 cadastro pages.
2. **New file exists** at `lib/features/presenter/widgets/common/app_validation_message.dart`.
3. **API surface** includes:
   - `final String? message`
   - `final IconData? icon` (optional)
   - When `message` is null or empty → `SizedBox.shrink()`.
   - When non-empty → styled `Text` matching existing pattern.
4. **Per-file scan**: each replaced block now uses `AppValidationMessage(message: ...)` — no `Visibility(visible: ...)` wrapping an inline `Text('... obrigatório')` remains.
5. **`dart analyze lib/features/presenter/`** — zero errors, zero warnings.
6. **Visual comparison** — each validation message renders identically (same position, font, color, italic, weight, padding).

### Workstream F — AppDeleteDialog

1. **`git diff --stat`** confirms 6 files changed: the new component + 5 detail/list pages.
2. **New file exists** at `lib/features/presenter/widgets/common/app_delete_dialog.dart`.
3. **API surface** includes:
   - `static Future<bool> show(...)` with required `title`, `message`, `infoText`.
   - Optional `confirmLabel` (default `'Deletar'`), `cancelLabel` (default `'Cancelar'`).
4. **Per-file scan**: each `_confirmarDelecao` body now calls `AppDeleteDialog.show(...)` — no `AlertDialog` construction remains in any of the 5 files.
5. **Post-dialog logic preserved**: `if (confirmou == true && context.mounted) { store.deletarX(...) }` is intact in all 5 files.
6. **`detalhes_solucao.dart`** preserves the additional `Navigator.pop(context)` before the store call.
7. **Entity-specific text preserved**: each call passes the correct `title`, `message`, and `infoText` matching the original per the mapping table.
8. **`dart analyze lib/features/presenter/`** — zero errors, zero warnings.
9. **Visual comparison** — each delete dialog appears identical to before (same icon, title, message, info box, buttons).

---

## Open Questions

1. **AD-7 (Loading state in AppStepWizard):** The current `cadastrar_lote_page.dart` wraps `StepNavigationFooter` in an `Observer` to pass `isLoading: store.isNovoLoteLoading`. `AppStepWizard` does not expose an `isLoading` parameter. Two options:
   - **(Recommended)** Accept the regression: footer will not show a loading spinner during submit. The spinner will not appear in the footer button, but the store call (which triggers the loading state) still happens. This only affects visual feedback, not functionality. Fix deferred to a follow-up wave that adds `isLoading` to `AppStepWizard`.
   - Add an optional `isLoading` parameter to `AppStepWizard`. This is a shared component modification (see Boundaries), but the change is minimal — one optional `bool` parameter passed through to `StepNavigationFooter`. If chosen, document as an ADR.

2. **VC-4 (Icon in AppValidationMessage):** The existing inline validation widgets do **not** show an icon — they are plain `Text` widgets. The spec allows an optional icon, but should the initial replacement include an icon or omit it for visual parity? **Recommendation:** Omit the icon initially (default to `null`) to maintain zero visual change. The icon parameter exists for future adopters who want it.

3. **D-2 (cadastrar_area_cultivo_page.dart CarouselSlider replacement):** Confirmed as deferred. The bottom sheet contains a CarouselSlider embedded in a bottom sheet refactored in Wave 1 to `AppModalSheet`. Replacing the CarouselSlider with `AppStepWizard` requires structural changes to the bottom sheet content and is architecturally more complex. This will be addressed in a future wave.

4. **DD-5 (Backdrop dismiss behavior):** The existing `showDialog` calls use the default barrier dismissible behavior (tap outside → dialog closes, returns `null`). Should `AppDeleteDialog.show` preserve this (return `false` on backdrop tap) or prevent backdrop dismiss? **Recommendation:** Preserve the existing behavior — willPopScope is not needed. `Navigator.pop(context)` on backdrop returns `null` from `showDialog<bool>`, which the calling code treats the same as `false` via `if (confirmou == true)`.
