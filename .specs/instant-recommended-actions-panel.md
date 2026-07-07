# Unify NextStep + Relacionados into InstantRecommendedActionsPanel

## Problem

In INSTANT adaptive mode, the home page shows a **NextStepCard** (single action with CTA button) followed by a **"Relacionados"** list — two separate components that duplicate the same purpose: showing recommended actions. The NextStepCard occupies ~160px with a full-width button and side-stripe border, consuming disproportionate space for a single recommendation. The "Relacionados" list beneath it renders secondary actions using a different visual vocabulary (`AdaptiveRecommendedActionTile`). This creates:

- Redundant navigation patterns (two components, same action type)
- Inconsistent visual hierarchy (NextStepCard competes with section cards)
- Violation of side-stripe ban (impeccable absolute ban)
- Low contrast text (`Colors.black54` → ~3.5:1, below 4.5:1)

## Solution

Create a single `InstantRecommendedActionsPanel` component that replaces both `NextStepCard` and the `_buildInstantActions` ("Relacionados") section. It follows the same visual language as the GRADUAL-mode `RecommendedActionsSection` for consistency across modes.

### Visual design

```
┌─────────────────────────────────────────────────┐
│ ⚡ Ações recomendadas              [Adaptativo] │
│ Apoio adaptativo ativo para priorizar ações.    │
│                                                  │
│ ┌──────────────────────────────────────────┐     │
│ │ 🔹 Verificar nível do reservatório      │ >  │
│ │    Tanque com nível abaixo do ideal      │     │
│ │                  [90%]                   │     │
│ └──────────────────────────────────────────┘     │
│                                                  │
│ ┌──────────────────────────────────────────┐     │
│ │ 📋 Registrar aplicação no talhão 3      │ >  │
│ │    Protocolo pendente desde ontem        │     │
│ │                  [75%]                   │     │
│ └──────────────────────────────────────────┘     │
│                                                  │
│ 💡 Baseado nas últimas atividades no talhão 2   │
└─────────────────────────────────────────────────┘
```

### Color

- Body text: `Colors.black60` (instead of current `Colors.black54`) to reach ≥4.5:1 contrast on white background.
- Tile background: `Constants.kCardColor` (#F5F5F5).
- Accent: `Constants.kPrimaryColor` for confidence badge and section icon.
- No side-stripe, no gradient, no glassmorphism.

### Typography

- Section title: `homeTitleStyle(16)` — same as GRADUAL mode.
- Section subtitle (when adaptive): `homeBodyStyle(Colors.black60)`.
- Action label: `homeTitleStyle(13)` — same as existing tile.
- Action description: `homeBodyStyle(Colors.black60)` — contrast fix.
- Confidence badge: 10px, W700.

### Spacing

- `HomePanelCard` padding: 16px (consistent with other section cards).
- Between tiles: 6px vertical.
- Tile internal padding: 12px.
- Section title to subtitle: 6px.
- Subtitle to tiles: 12px.

### Component contract

```dart
class InstantRecommendedActionsPanel extends StatelessWidget {
  final List<AdaptiveRecommendedActionViewData> actions;
  final NextStepViewData? nextStep;
  final String? reasonSummary;
  final ValueChanged<String> onActionTap;
}
```

### Behavior

- `nextStep` (if present) becomes the **first tile** in the list.
- The first tile shows a `flag` icon instead of `lightbulb`.
- If `nextStep.isProminent`, the first tile gets a small `HomeBadge("Prioritário")`.
- Tiles with `confidence > 0.7` display a rounded confidence badge.
- `reasonSummary` renders as a small chip below the tiles.
- Max 6 items shown (including nextStep if present).

### States

- **Empty** (no nextStep, no actions): returns `SizedBox.shrink()`.
- **Loading**: handled externally (skeleton already exists in INSTANT flow).
- **Default**: tiles listed as described above.

### Anti-patterns eliminated

- Side-stripe border (was on `NextStepCard`).
- Full-width button for single action.
- "Relacionados" label (replaced by unified "Ações recomendadas").
- Duplicate section headers in INSTANT mode.
- Low-contrast body text (`Colors.black54` → `Colors.black60`).

## Files

| File | Action |
|---|---|
| `components/adaptive/next_step_card.dart` | Remove (no longer used) |
| `components/adaptive/instant_recommended_actions_panel.dart` | **Create** |
| `components/home_daily_panel_content.dart` | Modify: replace NextStepCard + _buildInstantActions with InstantRecommendedActionsPanel |

## Data layer (unchanged)

- `InstantAdaptiveHomeViewData.nextStep` — still parsed, consumed by new panel.
- `InstantAdaptiveHomeViewData.recommendedActions` — still parsed, consumed by new panel.
- `InstantAdaptiveHomeViewData.reasonSummary` — still parsed, consumed by new panel.
- `NextStepViewData` class — still used, not removed.
- Mapper (`instant_adaptive_home_mapper.dart`) — no changes.

## Validation

- `flutter analyze` passes.
- `RecommendedActionsSection` (GRADUAL mode) is unaffected.
- INSTANT mode shows unified actions panel instead of NextStepCard + Relacionados.
- No import of `next_step_card.dart` remains.
