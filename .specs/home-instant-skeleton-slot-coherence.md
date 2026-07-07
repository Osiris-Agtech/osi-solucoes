# Home INSTANT Skeleton Slot Coherence

## Context

The Home screen currently loads base dashboard data first and then applies adaptive interface data. During initial load, a full Home skeleton is shown while the dashboard is unavailable. After the dashboard exists, `HomeDailyPanelContent` can render the fixed page structure before the app has resolved whether the adaptive interface/mode is `INSTANT`. If the mode later resolves to `INSTANT` while `instantViewData` is still pending, `InstantSectionSkeleton` appears in the middle of already-rendered fixed content.

This creates incoherent loading states because the inserted skeleton does not match the final INSTANT layout. The current `InstantSectionSkeleton` renders four separate placeholders: NextStep, FocusBanner, ActivityFeed, and RecommendedActions. The final INSTANT layout instead renders optional adaptive components plus a single `InstantRecommendedActionsPanel` that merges `nextStep` and `recommendedActions`, followed by fixed `HomeInfoCard` and `HomeModulesSection`.

This creates a staged, incoherent loading sequence: fixed components appear first and the adaptive skeleton appears later. `HomeInfoCard` also receives global loading state and can skeletonize due to shortcut/adaptive loading even after base data exists, despite fallback/info content being renderable.

## Goals

- Keep the full Home skeleton while base dashboard data is unavailable or the initial adaptive interface/mode has not resolved.
- Prevent fixed slots from appearing before the app knows whether the current adaptive mode is `INSTANT`.
- Preserve visible fixed slots after base data and adaptive interface/mode resolution exist.
- Make the INSTANT loading skeleton cover only the missing INSTANT adaptive area.
- Align the INSTANT skeleton with the final real slot structure.
- Prevent `HomeInfoCard` from skeletonizing solely because shortcut/adaptive loading is active after base data exists.
- Avoid visual growth and jarring middle skeleton insertion once fixed Home content is already available.

## Non-goals

- No redesign of the Home screen visual style.
- No CTA copy, action, routing, or behavior changes.
- No broad redesign of Home loading orchestration beyond tracking whether the initial adaptive interface/mode has resolved.
- No changes to dashboard, shortcut, or adaptive data contracts.
- No new analytics, telemetry, or test infrastructure.

## Technical Approach and Design Decisions

Use a two-stage loading model:

1. **Initial full-page skeleton stage**: render the full Home skeleton while base dashboard data is unavailable or the initial adaptive interface/mode is unresolved.
2. **Resolved slot-based stage**: after the adaptive interface/mode is known, render fixed slots normally and use an adaptive-area skeleton only for missing `INSTANT` payload data.

Use a slot-based loading model in `HomeDailyPanelContent` after the resolved stage begins:

1. **Header fixed slot**: render normally after base dashboard data exists.
2. **INSTANT adaptive optional area**: render adaptive content when available; while INSTANT data is loading and absent, render a skeleton that represents only this adaptive area.
3. **Info fixed slot**: keep `HomeInfoCard` visible after base data exists and do not tie its skeleton state to shortcut/adaptive loading alone.
4. **Modules fixed slot**: keep `HomeModulesSection` visible after base data exists.

Update `InstantSectionSkeleton` so its placeholders correspond to the final INSTANT adaptive slots:

- Optional focus/banner placeholder, matching `AdaptiveFocusBanner` placement when expected by the current layout rules.
- Optional activity feed placeholder, matching `ActivityFeedCard` placement when expected by the current layout rules.
- One combined actions placeholder matching `InstantRecommendedActionsPanel`, covering both `nextStep` and `recommendedActions`.
- No separate NextStep skeleton.
- No skeleton placeholders for fixed `HomeInfoCard` or `HomeModulesSection`.

Add an explicit store-level state such as `hasResolvedAdaptiveInterface` when existing state cannot safely distinguish “adaptive mode still unknown” from “known non-INSTANT/no data required”. This state should become true once the adaptive interface/mode decision has completed, regardless of whether the result is `INSTANT` or not. `home_page.dart` can then include unresolved adaptive interface/mode in the full skeleton criteria.

Prefer limiting code changes to rendering decisions, skeleton composition, and the minimal store/page state needed to represent adaptive interface/mode resolution.

If the implementation can safely distinguish initial load from later refreshes with prior layout/data available, avoid re-entering the full-page skeleton on later refresh. In that case, use the existing rendered layout and only show the scoped adaptive-area skeleton where appropriate. If this distinction is not available without broader state changes, document this as a follow-up/risk rather than over-expanding scope.

## Data Structures or Interfaces Involved

Primary UI inputs and flags:

- `dashboard`: base Home data; absence should trigger full Home skeleton.
- `isLoadingInstantAdaptation`: indicates INSTANT adaptive loading is in progress.
- `instantViewData`: INSTANT adaptive payload; absence during INSTANT loading should trigger only the INSTANT adaptive-area skeleton.
- `hasResolvedAdaptiveInterface` or equivalent: indicates the app has completed the initial adaptive interface/mode decision. While false during initial load, the full Home skeleton should remain visible even if base dashboard data already exists.
- `isLoading`: global/base loading flag; should not cause fixed slots to skeletonize after base data exists.
- `isLoadingShortcuts`: shortcut loading flag; should not force `HomeInfoCard` skeleton after base data exists when fallback/info content can render.

Target files and responsibilities:

- `lib/.../home_daily_panel_content.dart`: own slot orchestration and decide when fixed slots versus INSTANT adaptive skeleton are rendered.
- `lib/.../instant_section_skeleton.dart`: render skeleton placeholders that match final INSTANT adaptive slots.
- `lib/.../home_skeletons.dart` optionally: share or adjust reusable skeleton primitives if needed.
- `lib/.../home_page.dart`: include unresolved adaptive interface/mode in full skeleton criteria and pass resolved loading state to content.
- `lib/.../home_store.dart`: add or expose `hasResolvedAdaptiveInterface` or equivalent if not already derivable.
- `lib/.../home_store.g.dart`: regenerate/update only if a MobX observable/computed/action is added to `home_store.dart`.

Avoid changing other files unless required by an implementation blocker that is documented before expanding scope.

## Acceptance Criteria

- Full Home skeleton is rendered while base data/dashboard does not exist or the initial adaptive interface/mode has not resolved.
- Fixed slots do not render during initial load before the adaptive interface/mode has resolved, preventing fixed components from appearing before a later adaptive skeleton insertion.
- Once base data/dashboard exists and the adaptive interface/mode has resolved, fixed slots remain visible during INSTANT adaptive loading.
- While `adaptiveMode == 'INSTANT'`, no `instantViewData` exists, and INSTANT has not errored, skeleton UI covers only the INSTANT adaptive optional area.
- When adaptive interface/mode resolves to non-INSTANT, the full skeleton is removed and fixed/content slots render according to the non-INSTANT rules without waiting for `instantViewData`.
- Later refreshes do not show the full-page skeleton if prior layout/data exists and implementation can safely distinguish refresh from initial load; otherwise this limitation is explicitly documented as a follow-up/risk.
- INSTANT skeleton matches final real slots:
  - no separate NextStep skeleton;
  - one actions skeleton represents the merged `nextStep` + `recommendedActions` panel;
  - skeleton does not include fixed info/modules placeholders.
- `HomeInfoCard` does not show skeleton solely because shortcut/adaptive loading is active after base data/dashboard exists.
- No unrelated Home UI redesign, CTA change, copy change, or navigation behavior change is introduced.
- Changes are limited to the target files unless a documented blocker requires otherwise.

## Validation Commands

Run existing project validation commands after implementation, if available:

```bash
flutter analyze
flutter test
```

If the project does not have runnable tests or the environment cannot run Flutter validation, document the limitation and perform a targeted manual review of the Home INSTANT loading sequence.

## Open Questions

- Should the INSTANT skeleton always show focus/banner and activity placeholders, or should it conditionally mirror the same rules that decide whether `AdaptiveFocusBanner` and `ActivityFeedCard` appear?
- What is the intended fallback content for `HomeInfoCard` while shortcuts are loading after base dashboard data exists?
- Can the current store safely distinguish initial adaptive interface resolution from later refreshes with prior layout/data, or is an additional refresh-vs-initial-load flag needed?
